//
//  Connection.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import UIKit

/**
 Represents a single connection between server and client. The same class is used on either side.
 */
public class Connection: NSObject, StreamDelegate {
    let outwardMessagesQueue: OperationQueue = OperationQueue()
    /// An unique identifier for the connection
    public let identifier: ConnectionID
    
    var input: InputStream
    var output: OutputStream
    var isWriteable: Bool = false {
        didSet {
            self.outwardMessagesQueue.isSuspended = !self.isWriteable
        }
    }
    var isReady: Bool = false
    var pingTimer = Timer()
    /// :nodoc:
    override public var hashValue: Int {
        return self.identifier.id.hashValue
    }
    
    var delegate: ConnectionDelegate?
    
    init(input: InputStream, output: OutputStream, identifier: ConnectionID? = nil) {
        self.input = input
        self.output = output
        
        self.outwardMessagesQueue.maxConcurrentOperationCount = 1
        self.outwardMessagesQueue.isSuspended = true
        self.identifier = identifier ?? ConnectionID()
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
    
    func sendMessage<Message: JSONConvertibleMessage>(_ message: Message) {
        self.outwardMessagesQueue.addOperation {
            do {
                _ = try self.output.writeMessage(message)
            } catch {
                self.delegate?.connection(self, raisedError: error)
            }
        }
    }
    
    func dataFromInput(_ stream: InputStream) throws -> IncomingData {
        var lengthInBytes = Array<UInt8>(repeating: 0, count: MemoryLayout<Constants.MessageLength>.size)
        _ = stream.read(&lengthInBytes, maxLength: lengthInBytes.count)
        let length: Constants.MessageLength = UnsafePointer(lengthInBytes).withMemoryRebound(to: Constants.MessageLength.self, capacity: 1) {
            $0.pointee
        }
        
        guard length > 0 else {
            return .nilMessage
        }
        
        var actualDataBuffer = Array<UInt8>(repeating: 0, count: Int(length))
        let readBytesCount = stream.read(&actualDataBuffer, maxLength: actualDataBuffer.count)
        if readBytesCount < 0 {
            throw ConnectionError.inputError
        }
        
        let payloadData = Data(bytes: actualDataBuffer)
        
        do {
            let payload = try JSONSerialization.jsonObject(with: payloadData, options: []) as! [String:Any]
            
            if let messageType = payload[Fields.messageTypeField] as? String, messageType == KeepAliveMessage.type {
                let keepAliveMessage = self.keepAliveMessage(jsonObject: payload)
                
                if !keepAliveMessage.hasMoreData {
                    return .keepAliveMessage
                }
            }
            
            print("Received payload:")
            print(payload)
            
            return .data(payload)
        }
    }
    
    func keepAliveMessage(jsonObject: [String: Any]) -> KeepAliveMessage {
        return KeepAliveMessage(jsonObject: jsonObject)
    }
    
    // MARK: - keeping connection alive
    
    func startKeepAliveRoutine() {
        self.pingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Connection.sendKeepAliveMessage), userInfo: nil, repeats: true)
    }
    
    @objc private func sendKeepAliveMessage() throws {
        do {
            self.outwardMessagesQueue.addOperation {
                do {
                    try self.output.writeMessage(KeepAliveMessage())
                } catch {
                    self.delegate?.connection(self, raisedError: error)
                }
            }
        }
    }
    
    func stopKeepAliveRoutine() {
        self.pingTimer.invalidate()
    }
    
    // MARK: - StreamDelegate protocol
    
    /// :nodoc:
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
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
                self.startKeepAliveRoutine()
                self.delegate?.connectionOpened(self)
            }
        case Stream.Event.hasBytesAvailable:
            do {
                let incomingData: IncomingData = try self.dataFromInput(self.input)
                
                if case .data(let payload) = incomingData {
                    self.delegate?.connection(self, receivedData: payload)
                }
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
