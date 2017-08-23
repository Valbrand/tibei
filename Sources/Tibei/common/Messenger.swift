//
//  Messenger.swift
//  Pods
//
//  Created by Daniel de Jesus Oliveira on 27/12/2016.
//
//

import Foundation

/**
 Represents an entity that receives messages from a connection. This protocol is implemented by both `ClientMessenger` and `ServerMessenger`.
 */
public protocol Messenger {
    /// The chain of registered message responders
    var responders: ResponderChain { get }
}

extension Messenger {
    /**
     Registers a new responder to the responder chain.
     
     - Parameter responder: the `ConnectionResponder` to be registered to the chain.
     */
    public func registerResponder(_ responder: ConnectionResponder) {
        self.responders.append(ResponderChainNode(responder: responder))
    }
    
    /**
     Removes a responder from the responder chain.
     
     - Parameter responder: the `ConnectionResponder` to be removed from the chain.
     */
    public func unregisterResponder(_ responder: ConnectionResponder) {
        self.responders.remove(ResponderChainNode(responder: responder))
    }
    
    func forwardEventToResponderChain(event: ConnectionEvent, fromConnectionWithID connectionID: ConnectionID?) {
        do {
            try self.responders.respond(to: event)
        } catch {
            self.responders.processError(error, fromConnectionWithID: connectionID)
        }
    }
}
