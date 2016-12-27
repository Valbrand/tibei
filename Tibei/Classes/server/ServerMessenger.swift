//
//  Messenger.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

public class ServerMessenger<MessageFactory: JSONConvertibleMessageFactory> {
    var connections: [ConnectionID: Connection<MessageFactory>] = [:]
    
    public var delegate: ServerMessengerDelegate<MessageFactory>?
    
    var gameControllerServer: GameControllerServer<MessageFactory>!
    
    public init() {
        self.gameControllerServer = GameControllerServer<MessageFactory>(messenger: self)
        
        self.gameControllerServer.publishService()
    }
    
    func addConnection(_ connection: Connection<MessageFactory>) {
        connection.delegate = ConnectionDelegate(self)
        
        self.connections[connection.identifier] = connection
        connection.open()
    }
    
    public func sendMessage(_ message: MessageFactory.Message, toConnectionWithID connectionID: ConnectionID) throws {
        guard let connection = self.connections[connectionID] else {
            return
        }
        
        connection.sendMessage(message)
    }
    
}

// MARK: - ConnectionDelegate protocol
extension ServerMessenger: ConnectionDelegateProtocol {
    func connection(_ connection: Connection<MessageFactory>, hasEndedWithErrors: Bool) {
        self.delegate?.messenger(self, didLoseConnectionWithID: connection.identifier)
    }
    
    func connection(_ connection: Connection<MessageFactory>, receivedMessage: MessageFactory.Message) {
        self.delegate?.messenger(self, didReceiveMessage: receivedMessage, fromConnectionWithID: connection.identifier)
    }
    
    func connection(_ connection: Connection<MessageFactory>, raisedError: Error) {
        self.delegate?.messenger(self, didLoseConnectionWithID: connection.identifier)
    }
    
    func connectionOpened(_ connection: Connection<MessageFactory>) {
        self.delegate?.messenger(self, didAcceptConnectionWithID: connection.identifier)
    }
}
