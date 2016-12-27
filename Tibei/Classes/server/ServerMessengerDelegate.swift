//
//  MessageReceiver.swift
//  connectivityTest
//
//  Created by Daniel de Jesus Oliveira on 15/11/2016.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

public protocol ServerMessengerDelegateProtocol {
    associatedtype MessageFactory: JSONConvertibleMessageFactory
    
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didReceiveMessage message: MessageFactory.Message, fromConnectionWithID connectionID: ConnectionID)
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didAcceptConnectionWithID connectionID: ConnectionID)
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didLoseConnectionWithID connectionID: ConnectionID)
}

fileprivate class AbstractServerMessengerDelegate<MessageFactory: JSONConvertibleMessageFactory>: ServerMessengerDelegateProtocol {
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didReceiveMessage message: MessageFactory.Message, fromConnectionWithID connectionID: ConnectionID) {
        fatalError()
    }
    
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didAcceptConnectionWithID connectionID: ConnectionID) {
        fatalError()
    }
    
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didLoseConnectionWithID connectionID: ConnectionID) {
        fatalError()
    }
}

fileprivate class ServerMessengerDelegateWrapper<SMDP: ServerMessengerDelegateProtocol>: AbstractServerMessengerDelegate<SMDP.MessageFactory> {
    let base: SMDP
    typealias MessageFactory = SMDP.MessageFactory
    
    init(_ base: SMDP) {
        self.base = base
    }
    
    override func messenger(_ messenger: ServerMessenger<MessageFactory>, didReceiveMessage message: MessageFactory.Message, fromConnectionWithID connectionID: ConnectionID) {
        self.base.messenger(messenger, didReceiveMessage: message, fromConnectionWithID: connectionID)
    }
    
    override func messenger(_ messenger: ServerMessenger<MessageFactory>, didAcceptConnectionWithID connectionID: ConnectionID) {
        self.base.messenger(messenger, didAcceptConnectionWithID: connectionID)
    }
    
    override func messenger(_ messenger: ServerMessenger<SMDP.MessageFactory>, didLoseConnectionWithID connectionID: ConnectionID) {
        self.base.messenger(messenger, didLoseConnectionWithID: connectionID)
    }
}

public final class ServerMessengerDelegate<MessageFactory: JSONConvertibleMessageFactory>: ServerMessengerDelegateProtocol {
    private let delegateImplementation: AbstractServerMessengerDelegate<MessageFactory>
    
    public init<SMDP: ServerMessengerDelegateProtocol>(_ delegateImplementation: SMDP) where MessageFactory == SMDP.MessageFactory {
        self.delegateImplementation = ServerMessengerDelegateWrapper(delegateImplementation)
    }
    
    public func messenger(_ messenger: ServerMessenger<MessageFactory>, didReceiveMessage message: MessageFactory.Message, fromConnectionWithID connectionID: ConnectionID) {
        self.delegateImplementation.messenger(messenger, didReceiveMessage: message, fromConnectionWithID: connectionID)
    }
    
    public func messenger(_ messenger: ServerMessenger<MessageFactory>, didAcceptConnectionWithID connectionID: ConnectionID) {
        self.delegateImplementation.messenger(messenger, didAcceptConnectionWithID: connectionID)
    }
    
    public func messenger(_ messenger: ServerMessenger<MessageFactory>, didLoseConnectionWithID connectionID: ConnectionID) {
        self.delegateImplementation.messenger(messenger, didLoseConnectionWithID: connectionID)
    }
}
