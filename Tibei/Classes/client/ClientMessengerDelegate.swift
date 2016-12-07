//
//  ClientMessengerDelegate.swift
//  connectivityTest
//
//  Created by Daniel de Jesus Oliveira on 16/11/2016.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

protocol ClientMessengerDelegateProtocol {
    associatedtype MessageFactory: JSONConvertibleMessageFactory
    
    func messenger(_ messenger: ClientMessenger<MessageFactory>, didUpdateServices services: [String])
    func messenger(_ messenger: ClientMessenger<MessageFactory>, didReceiveMessage message: MessageFactory.Message)
    func messengerConnected(_ messenger: ClientMessenger<MessageFactory>)
    func messengerDisconnected(_ messenger: ClientMessenger<MessageFactory>)
}

fileprivate class AbstractClientMessengerDelegate<MessageFactory: JSONConvertibleMessageFactory>: ClientMessengerDelegateProtocol {
    func messenger(_ messenger: ClientMessenger<MessageFactory>, didUpdateServices services: [String]) {
        fatalError()
    }
    
    func messenger(_ messenger: ClientMessenger<MessageFactory>, didReceiveMessage message: MessageFactory.Message) {
        fatalError()
    }
    
    func messengerConnected(_ messenger: ClientMessenger<MessageFactory>) {
        fatalError()
    }
    
    func messengerDisconnected(_ messenger: ClientMessenger<MessageFactory>) {
        fatalError()
    }
}

fileprivate class ClientMessengerDelegateWrapper<CMDP: ClientMessengerDelegateProtocol>: AbstractClientMessengerDelegate<CMDP.MessageFactory> {
    let base: CMDP
    typealias MessageFactory = CMDP.MessageFactory
    
    init(_ base: CMDP) {
        self.base = base
    }
    
    override func messenger(_ messenger: ClientMessenger<MessageFactory>, didUpdateServices services: [String]) {
        self.base.messenger(messenger, didUpdateServices: services)
    }
    
    override func messenger(_ messenger: ClientMessenger<MessageFactory>, didReceiveMessage message: MessageFactory.Message) {
        self.base.messenger(messenger, didReceiveMessage: message)
    }
    
    override func messengerConnected(_ messenger: ClientMessenger<MessageFactory>) {
        self.base.messengerConnected(messenger)
    }
    
    override func messengerDisconnected(_ messenger: ClientMessenger<MessageFactory>) {
        self.base.messengerDisconnected(messenger)
    }
}

final class ClientMessengerDelegate<MessageFactory: JSONConvertibleMessageFactory>: ClientMessengerDelegateProtocol {
    private let delegateImplementation: AbstractClientMessengerDelegate<MessageFactory>
    
    init<CMDP: ClientMessengerDelegateProtocol>(_ delegateImplementation: CMDP) where CMDP.MessageFactory == MessageFactory {
        self.delegateImplementation = ClientMessengerDelegateWrapper(delegateImplementation)
    }
    
    func messenger(_ messenger: ClientMessenger<MessageFactory>, didUpdateServices services: [String]) {
        self.delegateImplementation.messenger(messenger, didUpdateServices: services)
    }
    
    func messenger(_ messenger: ClientMessenger<MessageFactory>, didReceiveMessage message: MessageFactory.Message) {
        self.delegateImplementation.messenger(messenger, didReceiveMessage: message)
    }
    
    func messengerConnected(_ messenger: ClientMessenger<MessageFactory>) {
        self.delegateImplementation.messengerConnected(messenger)
    }
    
    func messengerDisconnected(_ messenger: ClientMessenger<MessageFactory>) {
        self.delegateImplementation.messengerDisconnected(messenger)
    }
}
