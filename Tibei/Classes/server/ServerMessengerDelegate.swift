//
//  MessageReceiver.swift
//  connectivityTest
//
//  Created by Daniel de Jesus Oliveira on 15/11/2016.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

protocol ServerMessengerDelegateProtocol {
    associatedtype MessageFactory: JSONConvertibleMessageFactory
    
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didReceiveMessage message: MessageFactory.Message, fromConnection connection: Connection<MessageFactory>)
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didAcceptConnection connection: Connection<MessageFactory>)
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didLoseConnection connection: Connection<MessageFactory>)
}

fileprivate class AbstractServerMessengerDelegate<MessageFactory: JSONConvertibleMessageFactory>: ServerMessengerDelegateProtocol {
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didReceiveMessage message: MessageFactory.Message, fromConnection connection: Connection<MessageFactory>) {
        fatalError()
    }
    
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didAcceptConnection connection: Connection<MessageFactory>) {
        fatalError()
    }
    
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didLoseConnection connection: Connection<MessageFactory>) {
        fatalError()
    }
}

fileprivate class ServerMessengerDelegateWrapper<SMDP: ServerMessengerDelegateProtocol>: AbstractServerMessengerDelegate<SMDP.MessageFactory> {
    let base: SMDP
    typealias MessageFactory = SMDP.MessageFactory
    
    init(_ base: SMDP) {
        self.base = base
    }
    
    override func messenger(_ messenger: ServerMessenger<MessageFactory>, didReceiveMessage message: MessageFactory.Message, fromConnection connection: Connection<MessageFactory>) {
        self.base.messenger(messenger, didReceiveMessage: message, fromConnection: connection)
    }
    
    override func messenger(_ messenger: ServerMessenger<MessageFactory>, didAcceptConnection connection: Connection<MessageFactory>) {
        self.base.messenger(messenger, didAcceptConnection: connection)
    }
    
    override func messenger(_ messenger: ServerMessenger<SMDP.MessageFactory>, didLoseConnection connection: Connection<SMDP.MessageFactory>) {
        self.base.messenger(messenger, didLoseConnection: connection)
    }
}

final class ServerMessengerDelegate<MessageFactory: JSONConvertibleMessageFactory>: ServerMessengerDelegateProtocol {
    private let delegateImplementation: AbstractServerMessengerDelegate<MessageFactory>
    
    init<SMDP: ServerMessengerDelegateProtocol>(_ delegateImplementation: SMDP) where MessageFactory == SMDP.MessageFactory {
        self.delegateImplementation = ServerMessengerDelegateWrapper(delegateImplementation)
    }
    
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didReceiveMessage message: MessageFactory.Message, fromConnection connection: Connection<MessageFactory>) {
        self.delegateImplementation.messenger(messenger, didReceiveMessage: message, fromConnection: connection)
    }
    
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didAcceptConnection connection: Connection<MessageFactory>) {
        self.delegateImplementation.messenger(messenger, didAcceptConnection: connection)
    }
    
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didLoseConnection connection: Connection<MessageFactory>) {
        self.delegateImplementation.messenger(messenger, didLoseConnection: connection)
    }
}
