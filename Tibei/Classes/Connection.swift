//
//  Connection.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import UIKit

class Connection<MessageFactory: JSONConvertibleMessageFactory>: NSObject, StreamDelegate {
    let outwardMessagesQueue: OperationQueue = OperationQueue()
    
    var input: InputStream
    var output: OutputStream
    var identifier: UUID
    var isWriteable: Bool = false {
        didSet {
            self.outwardMessagesQueue.isSuspended = !self.isWriteable
        }
    }
    var isReady: Bool = false
    var pingTimer = Timer()
    
    var delegate: ConnectionDelegate<MessageFactory>?
    
    init(input: InputStream, output: OutputStream) {
        self.input = input
        self.output = output
        
        self.outwardMessagesQueue.maxConcurrentOperationCount = 1
        self.outwardMessagesQueue.isSuspended = true
        self.identifier = UUID()
    }
    
    func open() {
        self.openStream(self.input)
        self.openStream(self.output)
    }
    
    func close() {
        self.closeStream(self.input)
        self.closeStream(self.output)
    }
    
    private func openStream(_ stream: Stream) {
        stream.delegate = self
        stream.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        stream.open()
    }
    
    private func closeStream(_ stream: Stream) {
        stream.remove(from: RunLoop.current, forMode: .defaultRunLoopMode)
        stream.close()
    }
    
    func sendMessage(_ message: MessageFactory.Message) {
        self.outwardMessagesQueue.addOperation {
            do {
                _ = try self.output.writeMessage(message)
            } catch {
                self.delegate?.connection(self, raisedError: error)
            }
        }
    }
    
    // MARK: - keeping connection alive
    
    func startKeepAliveRoutine() {
        self.pingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Connection.sendKeepAliveMessage), userInfo: nil, repeats: true)
    }
    
    @objc private func sendKeepAliveMessage() throws {
        do {
            try self.output.writeMessage(KeepAliveMessage())
        }
    }
    
    func stopKeepAliveRoutine() {
        self.pingTimer.invalidate()
    }
    
    // MARK: - StreamDelegate protocol
    // As opposed to the rest of the project, this method is inside the class definition instead
    // of inside an extension because otherwise, an @nonobjc attribute would be needed
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.errorOccurred:
            self.stopKeepAliveRoutine()
            self.delegate?.connection(self, hasEndedWithErrors: true)
        case Stream.Event.endEncountered:
            self.stopKeepAliveRoutine()
            self.delegate?.connection(self, hasEndedWithErrors: false)
        case Stream.Event.openCompleted:
            let wasReady = self.isReady
            let inputIsOpen = self.input.streamStatus == Stream.Status.open
            let outputIsOpen = self.output.streamStatus == Stream.Status.open
            self.isReady = inputIsOpen && outputIsOpen
            
            if !wasReady && self.isReady {
                self.delegate?.connectionOpened(self)
            }
        case Stream.Event.hasBytesAvailable:
            do {
                let message: MessageFactory.Message = try MessageFactory.fromInput(self.input)
                
                self.delegate?.connection(self, receivedMessage: message)
            } catch {
                self.stopKeepAliveRoutine()
                self.delegate?.connection(self, raisedError: error)
            }
        case Stream.Event.hasSpaceAvailable:
            self.isWriteable = true
        default:
            return
        }
    }
}
