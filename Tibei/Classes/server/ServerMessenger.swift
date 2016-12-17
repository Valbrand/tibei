//
//  Messenger.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

public class ServerMessenger<MessageFactory: JSONConvertibleMessageFactory> {
    var idleConnections: Set<Connection<MessageFactory>> = Set<Connection<MessageFactory>>()
    
    public var delegate: ServerMessengerDelegate<MessageFactory>?
    
    var gameControllerServer: GameControllerServer<MessageFactory>!
    
    public init() {
        self.gameControllerServer = GameControllerServer<MessageFactory>(messenger: self)
        
        self.gameControllerServer.publishService()
    }
    
    func addConnection(_ connection: Connection<MessageFactory>) {
        connection.delegate = ConnectionDelegate(self)
        
        self.idleConnections.insert(connection)
        connection.open()
    }
    
}

// MARK: - ConnectionDelegate protocol
extension ServerMessenger: ConnectionDelegateProtocol {
    func connection(_ connection: Connection<MessageFactory>, hasEndedWithErrors: Bool) {
        print("Connection \(connection) ended \(hasEndedWithErrors ? "with errors" : "gracefully")")
        
        self.idleConnections.remove(connection)
        self.delegate?.messenger(self, didLoseConnection: connection)
    }
    
    func connection(_ connection: Connection<MessageFactory>, receivedMessage: MessageFactory.Message) {
        self.delegate?.messenger(self, didReceiveMessage: receivedMessage, fromConnection: connection)
    }
    
    func connection(_ connection: Connection<MessageFactory>, raisedError: Error) {
        print("Connection \(connection) raised error: \(raisedError)")
        
        self.idleConnections.remove(connection)
        self.delegate?.messenger(self, didLoseConnection: connection)
    }
    
    func connectionOpened(_ connection: Connection<MessageFactory>) {
        self.idleConnections.remove(connection)
        self.delegate?.messenger(self, didAcceptConnection: connection)
    }
}
