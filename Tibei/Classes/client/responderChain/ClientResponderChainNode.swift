//
//  ClientReceiverChain.swift
//  Pods
//
//  Created by Daniel de Jesus Oliveira on 27/12/2016.
//
//

import Foundation

class ClientResponderChainNode: ResponderChainNode {
    override func respond(to event: ConnectionEvent) throws {
        switch event {
        case let availableServicesChanged as ServiceAvailabilityChangeEvent:
            if let clientResponder = self.responder as? ClientConnectionResponder {
                clientResponder.availableServicesChanged(availableServiceIDs: availableServicesChanged.availableServiceIDs)
            }
        default:
            do {
                try super.respond(to: event)
            }
        }
        
        do {
            try self.next?.respond(to: event)
        }
    }
}
