//
//  ConnectionDelegate.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

protocol ConnectionDelegateProtocol {
    associatedtype Message: JSONConvertibleMessage
    
    func connection(_ connection: Connection<Message>, hasEndedWithErrors: Bool)
    func connection(_ connection: Connection<Message>, receivedData data: [String: Any])
    func connection(_ connection: Connection<Message>, raisedError error: Error)
    func connectionOpened(_ connection: Connection<Message>)
}

fileprivate class AbstractConnectionDelegate<Message: JSONConvertibleMessage>: ConnectionDelegateProtocol {
    func connection(_ connection: Connection<Message>, hasEndedWithErrors: Bool) {
        fatalError()
    }
    
    func connection(_ connection: Connection<Message>, receivedData data: [String: Any]) {
        fatalError()
    }
    
    func connection(_ connection: Connection<Message>, raisedError error: Error) {
        fatalError()
    }
    
    func connectionOpened(_ connection: Connection<Message>) {
        fatalError()
    }
}

fileprivate class ConnectionDelegateWrapper<CDP: ConnectionDelegateProtocol>: AbstractConnectionDelegate<CDP.Message> {
    private let base: CDP
    typealias Message = CDP.Message
    
    init(_ base: CDP) {
        self.base = base
    }
    
    override func connection(_ connection: Connection<Message>, hasEndedWithErrors: Bool) {
        self.base.connection(connection, hasEndedWithErrors: hasEndedWithErrors)
    }
    
    override func connection(_ connection: Connection<Message>, receivedData data: [String: Any]) {
        self.base.connection(connection, receivedData: data)
    }
    
    override func connection(_ connection: Connection<Message>, raisedError error: Error) {
        self.base.connection(connection, raisedError: error)
    }
    
    override func connectionOpened(_ connection: Connection<Message>) {
        self.base.connectionOpened(connection)
    }
}

final class ConnectionDelegate<Message: JSONConvertibleMessage>: ConnectionDelegateProtocol {
    private let delegateImplementation: AbstractConnectionDelegate<Message>
    
    init<CDP: ConnectionDelegateProtocol>(_ delegateImplementation: CDP) where CDP.Message == Message {
        self.delegateImplementation = ConnectionDelegateWrapper(delegateImplementation)
    }
    
    func connection(_ connection: Connection<Message>, hasEndedWithErrors: Bool) {
        self.delegateImplementation.connection(connection, hasEndedWithErrors: hasEndedWithErrors)
    }
    
    func connection(_ connection: Connection<Message>, receivedData data: [String: Any]) {
        self.delegateImplementation.connection(connection, receivedData: data)
    }
    
    func connection(_ connection: Connection<Message>, raisedError error: Error) {
        self.delegateImplementation.connection(connection, raisedError: error)
    }
    
    func connectionOpened(_ connection: Connection<Message>) {
        self.delegateImplementation.connectionOpened(connection)
    }
}
