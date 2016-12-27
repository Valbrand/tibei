//
//  Messenger.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

public class ServerMessenger<Message: JSONConvertibleMessage> {
    var connections: [ConnectionID: Connection<Message>] = [:]
    
    public var delegate: ServerMessengerDelegate<Message>?
    
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
        self.delegate?.messenger(self, didLoseConnectionWithID: connection.identifier)
    }
    
    func connection(_ connection: Connection<Message>, receivedMessage: Message) {
        self.delegate?.messenger(self, didReceiveMessage: receivedMessage, fromConnectionWithID: connection.identifier)
    }
    
    func connection(_ connection: Connection<Message>, raisedError: Error) {
        self.delegate?.messenger(self, didLoseConnectionWithID: connection.identifier)
    }
    
    func connectionOpened(_ connection: Connection<Message>) {
        self.delegate?.messenger(self, didAcceptConnectionWithID: connection.identifier)
    }
}
