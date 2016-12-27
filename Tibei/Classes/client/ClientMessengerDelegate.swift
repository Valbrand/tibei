//
//  ClientMessengerDelegate.swift
//  connectivityTest
//
//  Created by Daniel de Jesus Oliveira on 16/11/2016.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

public protocol ClientMessengerDelegateProtocol {
    associatedtype Message: JSONConvertibleMessage
    
    func messenger(_ messenger: ClientMessenger<Message>, didUpdateServices services: [String])
    func messenger(_ messenger: ClientMessenger<Message>, didReceiveMessage message: Message)
    func messengerConnected(_ messenger: ClientMessenger<Message>)
    func messengerDisconnected(_ messenger: ClientMessenger<Message>)
}

fileprivate class AbstractClientMessengerDelegate<Message: JSONConvertibleMessage>: ClientMessengerDelegateProtocol {
    func messenger(_ messenger: ClientMessenger<Message>, didUpdateServices services: [String]) {
        fatalError()
    }
    
    func messenger(_ messenger: ClientMessenger<Message>, didReceiveMessage message: Message) {
        fatalError()
    }
    
    func messengerConnected(_ messenger: ClientMessenger<Message>) {
        fatalError()
    }
    
    func messengerDisconnected(_ messenger: ClientMessenger<Message>) {
        fatalError()
    }
}

fileprivate class ClientMessengerDelegateWrapper<CMDP: ClientMessengerDelegateProtocol>: AbstractClientMessengerDelegate<CMDP.Message> {
    let base: CMDP
    typealias Message = CMDP.Message
    
    init(_ base: CMDP) {
        self.base = base
    }
    
    override func messenger(_ messenger: ClientMessenger<Message>, didUpdateServices services: [String]) {
        self.base.messenger(messenger, didUpdateServices: services)
    }
    
    override func messenger(_ messenger: ClientMessenger<Message>, didReceiveMessage message: Message) {
        self.base.messenger(messenger, didReceiveMessage: message)
    }
    
    override func messengerConnected(_ messenger: ClientMessenger<Message>) {
        self.base.messengerConnected(messenger)
    }
    
    override func messengerDisconnected(_ messenger: ClientMessenger<Message>) {
        self.base.messengerDisconnected(messenger)
    }
}

public final class ClientMessengerDelegate<Message: JSONConvertibleMessage>: ClientMessengerDelegateProtocol {
    private let delegateImplementation: AbstractClientMessengerDelegate<Message>
    
    public init<CMDP: ClientMessengerDelegateProtocol>(_ delegateImplementation: CMDP) where CMDP.Message == Message {
        self.delegateImplementation = ClientMessengerDelegateWrapper(delegateImplementation)
    }
    
    public func messenger(_ messenger: ClientMessenger<Message>, didUpdateServices services: [String]) {
        self.delegateImplementation.messenger(messenger, didUpdateServices: services)
    }
    
    public func messenger(_ messenger: ClientMessenger<Message>, didReceiveMessage message: Message) {
        self.delegateImplementation.messenger(messenger, didReceiveMessage: message)
    }
    
    public func messengerConnected(_ messenger: ClientMessenger<Message>) {
        self.delegateImplementation.messengerConnected(messenger)
    }
    
    public func messengerDisconnected(_ messenger: ClientMessenger<Message>) {
        self.delegateImplementation.messengerDisconnected(messenger)
    }
}
