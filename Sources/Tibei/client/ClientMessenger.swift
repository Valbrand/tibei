//
//  ClientMessenger.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import UIKit

/**
 Represents a messenger that sends and receives messages from the client-side.

 After a connection takes place, it will represent the connection.
*/
public class ClientMessenger: Messenger {
    var services: [String:NetService] = [:]
    var isReady: Bool = false
    
    /// The chain of registered message responders
    public var responders: ResponderChain = ResponderChain()
    var connection: Connection?
    var serviceBrowser: TibeiServiceBrowser
    
    /**
     Default initializer.
     
     Note that after this call, the `ClientMessenger` instance won't be browsing for services yet.
     
     - SeeAlso: ```browseForServices(withIdentifier:)```
    */
    public init() {
        self.serviceBrowser = TibeiServiceBrowser()
        
        self.serviceBrowser.delegate = self
    }
    
    /**
     Browses for services that are currently being published via Bonjour with a certain service identifier.
     
     - Parameter serviceIdentifier: Service identifier being currently browsed for
     */
    public func browseForServices(withIdentifier serviceIdentifier: String) {
        if self.serviceBrowser.isBrowsing {
            if !self.services.isEmpty {
                let event = ServiceAvailabilityChangeEvent(availableServiceIDs: Array(self.services.keys))
                
                self.forwardEventToResponderChain(event: event, fromConnectionWithID: nil)
            }
        }
        
        self.serviceBrowser.startBrowsing(forServiceType: serviceIdentifier)
    }
    
    /// Stops browsing for services.
    /// ConnectionResponders will stop receiving `availableServicesChanged` calls after this is called.
    public func stopBrowsingForServices() {
        self.serviceBrowser.stopBrowsing()
    }
    
    /// Connects to a service based on its provider's identifier
    ///
    /// - Parameter serviceName: The name of the service to connect to
    /// - Throws: `ConnectionError.inexistentService` if the `serviceName` parameter is provided, and `ConnectionError.connectionFailure` if some error occurred while obtaining input stream from connection
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
    
    /// Disconnects from the currently connected service. Does nothing if this messenger is not connected to any service.
    public func disconnect() {
        self.isReady = false
        
        self.connection?.close()
        self.connection = nil
    }
    
    /// Sends a message to the currently active connection.
    ///
    /// - Parameter message: Message to send.
    /// - Throws: `ConnectionError.notConnected` if there is no connection to send the message to.
    public func sendMessage<Message: JSONConvertibleMessage>(_ message: Message) throws {
        guard self.isReady else {
            throw ConnectionError.notConnected
        }
        
        self.connection?.sendMessage(message)
    }
    
    /// Registers a new responder to this messenger's responder chain.
    ///
    /// - Parameter responder: Responder to register in the chain.
    public func registerResponder(_ responder: ConnectionResponder) {
        if responder is ClientConnectionResponder {
            self.responders.append(ClientResponderChainNode(responder: responder))
        } else {
            self.responders.append(ResponderChainNode(responder: responder))
        }
    }
}

// MARK: - GameControllerServiceBrowserDelegate protocol

extension ClientMessenger: TibeiServiceBrowserDelegate {
    func gameControllerServiceBrowser(_ browser: TibeiServiceBrowser, raisedErrors errorDict: [String : NSNumber]) {
        print("Service browser raised errors:")
        print(errorDict)
    }
    
    func gameControllerServiceBrowser(_ browser: TibeiServiceBrowser, foundService service: NetService, moreComing: Bool) {
        self.services[service.name] = service
        
        if !moreComing {
            let event = ServiceAvailabilityChangeEvent(availableServiceIDs: Array(self.services.keys))
            
            self.forwardEventToResponderChain(event: event, fromConnectionWithID: nil)
        }
    }
    
    func gameControllerServiceBrowser(_ browser: TibeiServiceBrowser, removedService service: NetService, moreComing: Bool) {
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
