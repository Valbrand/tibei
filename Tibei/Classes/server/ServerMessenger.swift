//
//  Messenger.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

public class ServerMessenger: Messenger {
    var connections: [ConnectionID: Connection] = [:]
    
    public var responders: ResponderChain = ResponderChain()
    var gameControllerServer: GameControllerServer!
    
    public init() {
        self.gameControllerServer = GameControllerServer(messenger: self)
        
        self.gameControllerServer.publishService()
    }
    
    func addConnection(_ connection: Connection) {
        connection.delegate = self
        
        self.connections[connection.identifier] = connection
        connection.open()
    }
    
    public func sendMessage<Message: JSONConvertibleMessage>(_ message: Message, toConnectionWithID connectionID: ConnectionID) throws {
        guard let connection = self.connections[connectionID] else {
            return
        }
        
        connection.sendMessage(message)
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
