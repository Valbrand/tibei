//
//  ClientMessageReceiver.swift
//  Pods
//
//  Created by Daniel de Jesus Oliveira on 27/12/2016.
//
//

import Foundation

public protocol ClientConnectionResponder: ConnectionResponder {
    func availableServicesChanged(availableServiceIDs: [String])
}

public extension ClientConnectionResponder {
    func availableServicesChanged(availableServiceIDs: [String]) {
    }
}
