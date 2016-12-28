//
//  Messenger.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

public class ServerMessenger<Message: JSONConvertibleMessage>: Messenger {
    var connections: [ConnectionID: Connection<Message>] = [:]
    
    public var responders: ResponderChain = ResponderChain()
    var gameControllerServer: GameControllerServer<Message>!
    
    public init() {
        self.gameControllerServer = GameControllerServer<Message>(messenger: self)
        
        self.gameControllerServer.publishService()
    }
    
    func addConnection(_ connection: Connection<Message>) {
        connection.delegate = ConnectionDelegate(self)
        
        self.connections[connection.identifier] = connection
        connection.open()
    }
    
    public func sendMessage(_ message: Message, toConnectionWithID connectionID: ConnectionID) throws {
        guard let connection = self.connections[connectionID] else {
            return
        }
        
        connection.sendMessage(message)
    }
    
}

// MARK: - ConnectionDelegate protocol
extension ServerMessenger: ConnectionDelegateProtocol {
    func connection(_ connection: Connection<Message>, hasEndedWithErrors: Bool) {
        let event = ConnectionLostEvent(connectionID: connection.identifier)
        
        self.forwardEventToResponderChain(event: event, fromConnectionWithID: connection.identifier)
    }
    
    func connection(_ connection: Connection<Message>, receivedData data: [String: Any]) {
        let event = IncomingMessageEvent(message: data, connectionID: connection.identifier)
        
        self.forwardEventToResponderChain(event: event, fromConnectionWithID: connection.identifier)
    }
    
    func connection(_ connection: Connection<Message>, raisedError: Error) {
        self.responders.processError(raisedError, fromConnectionWithID: connection.identifier)
    }
    
    func connectionOpened(_ connection: Connection<Message>) {
        let event = ConnectionAcceptedEvent(connectionID: connection.identifier)
        
        self.forwardEventToResponderChain(event: event, fromConnectionWithID: connection.identifier)
    }
}
