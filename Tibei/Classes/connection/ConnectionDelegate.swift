//
//  ConnectionDelegate.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

protocol ConnectionDelegateProtocol {
    associatedtype MessageFactory: JSONConvertibleMessageFactory
    
    func connection(_ connection: Connection<MessageFactory>, hasEndedWithErrors: Bool)
    func connection(_ connection: Connection<MessageFactory>, receivedMessage message: MessageFactory.Message)
    func connection(_ connection: Connection<MessageFactory>, raisedError error: Error)
    func connectionOpened(_ connection: Connection<MessageFactory>)
}

fileprivate class AbstractConnectionDelegate<MessageFactory: JSONConvertibleMessageFactory>: ConnectionDelegateProtocol {
    func connection(_ connection: Connection<MessageFactory>, hasEndedWithErrors: Bool) {
        fatalError()
    }
    
    func connection(_ connection: Connection<MessageFactory>, receivedMessage message: MessageFactory.Message) {
        fatalError()
    }
    
    func connection(_ connection: Connection<MessageFactory>, raisedError error: Error) {
        fatalError()
    }
    
    func connectionOpened(_ connection: Connection<MessageFactory>) {
        fatalError()
    }
}

fileprivate class ConnectionDelegateWrapper<CDP: ConnectionDelegateProtocol>: AbstractConnectionDelegate<CDP.MessageFactory> {
    private let base: CDP
    typealias MessageFactory = CDP.MessageFactory
    
    init(_ base: CDP) {
        self.base = base
    }
    
    override func connection(_ connection: Connection<MessageFactory>, hasEndedWithErrors: Bool) {
        self.base.connection(connection, hasEndedWithErrors: hasEndedWithErrors)
    }
    
    override func connection(_ connection: Connection<MessageFactory>, receivedMessage message: MessageFactory.Message) {
        self.base.connection(connection, receivedMessage: message)
    }
    
    override func connection(_ connection: Connection<MessageFactory>, raisedError error: Error) {
        self.base.connection(connection, raisedError: error)
    }
    
    override func connectionOpened(_ connection: Connection<MessageFactory>) {
        self.base.connectionOpened(connection)
    }
}

final class ConnectionDelegate<MessageFactory: JSONConvertibleMessageFactory>: ConnectionDelegateProtocol {
    private let delegateImplementation: AbstractConnectionDelegate<MessageFactory>
    
    init<CDP: ConnectionDelegateProtocol>(_ delegateImplementation: CDP) where CDP.MessageFactory == MessageFactory {
        self.delegateImplementation = ConnectionDelegateWrapper(delegateImplementation)
    }
    
    func connection(_ connection: Connection<MessageFactory>, hasEndedWithErrors: Bool) {
        self.delegateImplementation.connection(connection, hasEndedWithErrors: hasEndedWithErrors)
    }
    
    func connection(_ connection: Connection<MessageFactory>, receivedMessage message: MessageFactory.Message) {
        self.delegateImplementation.connection(connection, receivedMessage: message)
    }
    
    func connection(_ connection: Connection<MessageFactory>, raisedError error: Error) {
        self.delegateImplementation.connection(connection, raisedError: error)
    }
    
    func connectionOpened(_ connection: Connection<MessageFactory>) {
        self.delegateImplementation.connectionOpened(connection)
    }
}
