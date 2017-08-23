//
//  ReceiverChain.swift
//  Pods
//
//  Created by Daniel de Jesus Oliveira on 27/12/2016.
//
//

import Foundation

class ResponderChainNode {
    let responder: ConnectionResponder
    var next: ResponderChainNode?
    
    init(responder: ConnectionResponder) {
        self.responder = responder
    }
    
    func respond(to event: ConnectionEvent) throws {
        switch event {
        case let incomingMessage as IncomingMessageEvent:
            do {
                try self.processMessage(incomingMessage.message, fromConnectionWithID: incomingMessage.connectionID)
            }
            
        case let acceptedConnection as ConnectionAcceptedEvent:
            self.responder.acceptedConnection(withID: acceptedConnection.connectionID)
            
        case let lostConnection as ConnectionLostEvent:
            self.responder.lostConnection(withID: lostConnection.connectionID)
            
        default:
            break
        }
        
        do {
            try self.next?.respond(to: event)
        }
    }
    
    func processMessage(_ jsonObject: [String: Any], fromConnectionWithID connectionID: ConnectionID) throws {
        guard let messageType = jsonObject[Fields.messageTypeField] as? String else {
            throw ConnectionError.invalidMessageType(jsonObject)
        }
        
        for allowedMessageType in self.responder.allowedMessages {
            if allowedMessageType.type == messageType {
                let messageObject = allowedMessageType.init(jsonObject: jsonObject)
                
                self.responder.processMessage(messageObject, fromConnectionWithID: connectionID)
                break
            }
        }
    }
    
    func processError(_ error: Error, fromConnectionWithID connectionID: ConnectionID?) {
        self.responder.processError(error, fromConnectionWithID: connectionID)
        
        self.next?.processError(error, fromConnectionWithID: connectionID)
    }
}

/**
 In Tibei, incoming messages are processed by a chain of objects that may be set as responders in a chain. Responders must conform to the `ConnectionResponder` or `ClientConnectionResponder` protocols.
 
 Currently, you have to manage the order in which elements are added to the chain, so take care if this is any relevant.
 
 - SeeAlso: `ConnectionResponder`
 - SeeAlso: `ClientConnectionResponder`
 */
public class ResponderChain {
    var head: ResponderChainNode?
    var tail: ResponderChainNode?
    
    private let chainMutationQueue: OperationQueue = OperationQueue()
    
    init() {
        self.chainMutationQueue.maxConcurrentOperationCount = 1
    }
    
    // MARK: - Responder chain mutating functions
    
    func append(_ newNode: ResponderChainNode) {
        self.chainMutationQueue.addOperation {
            [unowned self] in
            
            guard let chainTail = self.tail else {
                self.head = newNode
                self.tail = newNode
                
                return
            }
            
            chainTail.next = newNode
            self.tail = newNode
        }
    }
    
    func remove(_ nodeToRemove: ResponderChainNode) {
        self.chainMutationQueue.addOperation {
            [unowned self] in
            
            if let head = self.head {
                if head.responder === nodeToRemove.responder {
                    if head === self.tail {
                        self.tail = nil
                    }
                    
                    self.head = head.next
                    head.next = nil
                    return
                }
                
                var iteratingNode: ResponderChainNode = head
                
                while let lookaheadNode = iteratingNode.next {
                    if lookaheadNode.responder === nodeToRemove.responder {
                        iteratingNode.next = lookaheadNode.next
                        lookaheadNode.next = nil
                        
                        if self.tail === lookaheadNode {
                            self.tail = iteratingNode
                        }
                    }
                    
                    iteratingNode = lookaheadNode
                }
            }
        }
    }
    
    // MARK: - Event handling functions
    
    func respond(to event: ConnectionEvent) throws {
        do {
            try self.head?.respond(to: event)
        }
    }
    
    func processError(_ error: Error, fromConnectionWithID connectionID: ConnectionID?) {
        self.head?.processError(error, fromConnectionWithID: connectionID)
    }
}
