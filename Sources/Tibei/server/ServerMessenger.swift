//
//  Messenger.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

/**
 Represents a messenger that sends and receives messages on the server side.
 */
public class ServerMessenger: Messenger {
    var connections: [ConnectionID: Connection] = [:]
    
    /**
     The current responder chain
     */
    public var responders: ResponderChain = ResponderChain()
    var gameControllerServer: TibeiServer!
    
    /**
     Initializes the messenger. The service will **not** be published through Bonjour until `publishService` is called.
     
     - Parameter serviceIdentifier: The string that will distinguish this service from others in the Bonjour discovery process
     */
    public init(serviceIdentifier: String) {
        self.gameControllerServer = TibeiServer(messenger: self, serviceIdentifier: serviceIdentifier)
    }
    
    
    /**
     Publishes the service through Bonjour, making it discoverable to any client that searches for this server's service identifier
     */
    public func publishService() {
        self.gameControllerServer.publishService()
    }
    
    /**
     Make this server's service undiscoverable. No clients will be able to connect from the moment this method is called.
     */
    public func unpublishService() {
        self.gameControllerServer.unpublishService()
    }
    
    func addConnection(_ connection: Connection) {
        connection.delegate = self
        
        self.connections[connection.identifier] = connection
        connection.open()
    }
    
    /**
     Sends a message to a client identified by its connection identifier.
     
     - Parameters:
        - message: The message to be sent
        - connectionID: The identifier of the connection through which the message should be sent
     */
    public func sendMessage<Message: JSONConvertibleMessage>(_ message: Message, toConnectionWithID connectionID: ConnectionID) {
        guard let connection = self.connections[connectionID] else {
            return
        }
        
        connection.sendMessage(message)
    }
    
    /**
     Sends a message to all active connections.
     
     - Parameter message: The message to be sent
     */
    public func broadcastMessage<Message: JSONConvertibleMessage>(_ message: Message){
        for (_, connection) in self.connections{
            connection.sendMessage(message)
        }
    }
}

// MARK: - ConnectionDelegate protocol
extension ServerMessenger: ConnectionDelegate {
    func connection(_ connection: Connection, hasEndedWithErrors: Bool) {
        let event = ConnectionLostEvent(connectionID: connection.identifier)
        
        self.forwardEventToResponderChain(event: event, fromConnectionWithID: connection.identifier)
    }
    
    func connection(_ connection: Connection, receivedData data: [String: Any]) {
        let event = IncomingMessageEvent(message: data, connectionID: connection.identifier)
        
        self.forwardEventToResponderChain(event: event, fromConnectionWithID: connection.identifier)
    }
    
    func connection(_ connection: Connection, raisedError: Error) {
        self.responders.processError(raisedError, fromConnectionWithID: connection.identifier)
    }
    
    func connectionOpened(_ connection: Connection) {
        let event = ConnectionAcceptedEvent(connectionID: connection.identifier)
        
        self.forwardEventToResponderChain(event: event, fromConnectionWithID: connection.identifier)
    }
}
