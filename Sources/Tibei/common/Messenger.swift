//
//  Messenger.swift
//  Pods
//
//  Created by Daniel de Jesus Oliveira on 27/12/2016.
//
//

import Foundation

public protocol Messenger {
    var responders: ResponderChain { get }
}

extension Messenger {
    public func registerResponder(_ responder: ConnectionResponder) {
        self.responders.append(ResponderChainNode(responder: responder))
    }
    
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
