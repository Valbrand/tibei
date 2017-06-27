//
//  ClientMessageReceiver.swift
//  Pods
//
//  Created by Daniel de Jesus Oliveira on 27/12/2016.
//
//

import Foundation

/**
 A specialization of `ConnectionResponder` with additional behavior for the client side.
 */
public protocol ClientConnectionResponder: ConnectionResponder {
    /** 
     If the `ClientMessenger` instance is browsing for services, this method gets called whenever a new service becomes available (or if an available service goes offline), receiving the updated service list as a parameter.
    */
    func availableServicesChanged(availableServiceIDs: [String])
}

public extension ClientConnectionResponder {
    /// Does nothing
    func availableServicesChanged(availableServiceIDs: [String]) {
    }
}
