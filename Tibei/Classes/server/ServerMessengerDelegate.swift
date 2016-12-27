//
//  MessageReceiver.swift
//  connectivityTest
//
//  Created by Daniel de Jesus Oliveira on 15/11/2016.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

public protocol ServerMessengerDelegateProtocol {
    associatedtype Message: JSONConvertibleMessage
    
    func messenger(_ messenger: ServerMessenger<Message>, didReceiveMessage message: Message, fromConnectionWithID connectionID: ConnectionID)
    func messenger(_ messenger: ServerMessenger<Message>, didAcceptConnectionWithID connectionID: ConnectionID)
    func messenger(_ messenger: ServerMessenger<Message>, didLoseConnectionWithID connectionID: ConnectionID)
}

fileprivate class AbstractServerMessengerDelegate<Message: JSONConvertibleMessage>: ServerMessengerDelegateProtocol {
    func messenger(_ messenger: ServerMessenger<Message>, didReceiveMessage message: Message, fromConnectionWithID connectionID: ConnectionID) {
        fatalError()
    }
    
    func messenger(_ messenger: ServerMessenger<Message>, didAcceptConnectionWithID connectionID: ConnectionID) {
        fatalError()
    }
    
    func messenger(_ messenger: ServerMessenger<Message>, didLoseConnectionWithID connectionID: ConnectionID) {
        fatalError()
    }
}

fileprivate class ServerMessengerDelegateWrapper<SMDP: ServerMessengerDelegateProtocol>: AbstractServerMessengerDelegate<SMDP.Message> {
    let base: SMDP
    typealias Message = SMDP.Message
    
    init(_ base: SMDP) {
        self.base = base
    }
    
    override func messenger(_ messenger: ServerMessenger<Message>, didReceiveMessage message: Message, fromConnectionWithID connectionID: ConnectionID) {
        self.base.messenger(messenger, didReceiveMessage: message, fromConnectionWithID: connectionID)
    }
    
    override func messenger(_ messenger: ServerMessenger<Message>, didAcceptConnectionWithID connectionID: ConnectionID) {
        self.base.messenger(messenger, didAcceptConnectionWithID: connectionID)
    }
    
    override func messenger(_ messenger: ServerMessenger<SMDP.Message>, didLoseConnectionWithID connectionID: ConnectionID) {
        self.base.messenger(messenger, didLoseConnectionWithID: connectionID)
    }
}

public final class ServerMessengerDelegate<Message: JSONConvertibleMessage>: ServerMessengerDelegateProtocol {
    private let delegateImplementation: AbstractServerMessengerDelegate<Message>
    
    public init<SMDP: ServerMessengerDelegateProtocol>(_ delegateImplementation: SMDP) where Message == SMDP.Message {
        self.delegateImplementation = ServerMessengerDelegateWrapper(delegateImplementation)
    }
    
    public func messenger(_ messenger: ServerMessenger<Message>, didReceiveMessage message: Message, fromConnectionWithID connectionID: ConnectionID) {
        self.delegateImplementation.messenger(messenger, didReceiveMessage: message, fromConnectionWithID: connectionID)
    }
    
    public func messenger(_ messenger: ServerMessenger<Message>, didAcceptConnectionWithID connectionID: ConnectionID) {
        self.delegateImplementation.messenger(messenger, didAcceptConnectionWithID: connectionID)
    }
    
    public func messenger(_ messenger: ServerMessenger<Message>, didLoseConnectionWithID connectionID: ConnectionID) {
        self.delegateImplementation.messenger(messenger, didLoseConnectionWithID: connectionID)
    }
}
