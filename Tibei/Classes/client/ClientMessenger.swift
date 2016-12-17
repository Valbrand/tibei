//
//  ClientMessenger.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import UIKit

public class ClientMessenger<MessageFactory: JSONConvertibleMessageFactory> {
    var services: [String:NetService] = [:]
    var isReady: Bool = false
    
    var connection: Connection<MessageFactory>?
    var serviceBrowser: GameControllerServiceBrowser
    public var delegate: ClientMessengerDelegate<MessageFactory>?
    
    public init() {
        self.serviceBrowser = GameControllerServiceBrowser()
        
        self.serviceBrowser.delegate = self
    }
    
    public func browseForServices() {
        if self.serviceBrowser.isBrowsing {
            if !self.services.isEmpty {
                self.delegate?.messenger(self, didUpdateServices: Array(self.services.keys))
            }
        }
        
        self.serviceBrowser.startBrowsing()
    }
    
    public func stopBrowsingForServices() {
        self.serviceBrowser.stopBrowsing()
    }
    
    public func connect(serviceName: String) throws {
        guard let service = self.services[serviceName] else {
            throw ConnectionError.inexistentService
        }
        
        var inputStream: InputStream?
        var outputStream: OutputStream?
        
        let connected: Bool = service.getInputStream(&inputStream, outputStream: &outputStream)
        guard connected else {
            throw ConnectionError.connectionFailure
        }
        
        let newConnection = Connection<MessageFactory>(input: inputStream!, output: outputStream!)
        self.connection = newConnection
        newConnection.delegate = ConnectionDelegate(self)
        newConnection.open()
    }
    
    public func disconnect() {
        self.isReady = false
        
        self.connection?.close()
        self.connection = nil
        
        self.delegate?.messengerDisconnected(self)
    }
    
    public func sendMessage(_ message: MessageFactory.Message) throws {
        guard self.isReady else {
            throw ConnectionError.notConnected
        }
        
        self.connection?.sendMessage(message)
    }
}

// MARK: - GameControllerServiceBrowserDelegate protocol

extension ClientMessenger: GameControllerServiceBrowserDelegate {
    func gameControllerServiceBrowser(_ browser: GameControllerServiceBrowser, raisedErrors errorDict: [String : NSNumber]) {
        print("Service browser raised errors:")
        print(errorDict)
    }
    
    func gameControllerServiceBrowser(_ browser: GameControllerServiceBrowser, foundService service: NetService, moreComing: Bool) {
        self.services[service.name] = service
        
        if !moreComing {
            self.delegate?.messenger(self, didUpdateServices: Array(self.services.keys))
        }
    }
    
    func gameControllerServiceBrowser(_ browser: GameControllerServiceBrowser, removedService service: NetService, moreComing: Bool) {
        self.services.removeValue(forKey: service.name)
        
        if !moreComing {
            self.delegate?.messenger(self, didUpdateServices: Array(self.services.keys))
        }
    }
}

// MARK: - ConnectionDelegate protocol

extension ClientMessenger: ConnectionDelegateProtocol {
    func connection(_ connection: Connection<MessageFactory>, hasEndedWithErrors: Bool) {
        self.disconnect()
    }
    
    func connection(_ connection: Connection<MessageFactory>, raisedError error: Error) {
        self.disconnect()
    }
    
    func connection(_ connection: Connection<MessageFactory>, receivedMessage message: MessageFactory.Message) {
        self.delegate?.messenger(self, didReceiveMessage: message)
    }
    
    func connectionOpened(_ connection: Connection<MessageFactory>) {
        self.isReady = true
        self.delegate?.messengerConnected(self)
    }
}
