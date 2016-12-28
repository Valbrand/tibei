//
//  ClientMessenger.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import UIKit

public class ClientMessenger: Messenger {
    var services: [String:NetService] = [:]
    var isReady: Bool = false
    
    public var responders: ResponderChain = ResponderChain()
    var connection: Connection?
    var serviceBrowser: GameControllerServiceBrowser
    
    public init() {
        self.serviceBrowser = GameControllerServiceBrowser()
        
        self.serviceBrowser.delegate = self
    }
    
    public func browseForServices() {
        if self.serviceBrowser.isBrowsing {
            if !self.services.isEmpty {
                let event = ServiceAvailabilityChangeEvent(availableServiceIDs: Array(self.services.keys))
                
                self.forwardEventToResponderChain(event: event, fromConnectionWithID: nil)
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
        
        let newConnection = Connection(input: inputStream!, output: outputStream!)
        self.connection = newConnection
        newConnection.delegate = self
        newConnection.open()
    }
    
    public func disconnect() {
        self.isReady = false
        
        self.connection?.close()
        self.connection = nil
    }
    
    public func sendMessage<Message: JSONConvertibleMessage>(_ message: Message) throws {
        guard self.isReady else {
            throw ConnectionError.notConnected
        }
        
        self.connection?.sendMessage(message)
    }
    
    public func registerResponder(_ responder: ConnectionResponder) {
        if let clientResponder = responder as? ClientConnectionResponder {
            self.responders.append(ClientResponderChainNode(responder: responder))
        } else {
            self.responders.append(ResponderChainNode(responder: responder))
        }
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
            let event = ServiceAvailabilityChangeEvent(availableServiceIDs: Array(self.services.keys))
            
            self.forwardEventToResponderChain(event: event, fromConnectionWithID: nil)
        }
    }
    
    func gameControllerServiceBrowser(_ browser: GameControllerServiceBrowser, removedService service: NetService, moreComing: Bool) {
        self.services.removeValue(forKey: service.name)
        
        if !moreComing {
            let event = ServiceAvailabilityChangeEvent(availableServiceIDs: Array(self.services.keys))
            
            self.forwardEventToResponderChain(event: event, fromConnectionWithID: nil)
        }
    }
}

// MARK: - ConnectionDelegate protocol

extension ClientMessenger: ConnectionDelegate {
    func connection(_ connection: Connection, hasEndedWithErrors: Bool) {
        self.disconnect()
        
        let event = ConnectionLostEvent(connectionID: connection.identifier)
        
        self.forwardEventToResponderChain(event: event, fromConnectionWithID: connection.identifier)
    }
    
    func connection(_ connection: Connection, raisedError error: Error) {
        self.disconnect()
        
        let event = ConnectionLostEvent(connectionID: connection.identifier)
        
        self.forwardEventToResponderChain(event: event, fromConnectionWithID: connection.identifier)
    }
    
    func connection(_ connection: Connection, receivedData data: [String: Any]) {
        let event = IncomingMessageEvent(message: data, connectionID: connection.identifier)
        
        self.forwardEventToResponderChain(event: event, fromConnectionWithID: connection.identifier)
    }
    
    func connectionOpened(_ connection: Connection) {
        self.isReady = true
        
        let event = ConnectionAcceptedEvent(connectionID: connection.identifier)
        
        self.forwardEventToResponderChain(event: event, fromConnectionWithID: connection.identifier)
    }
}
