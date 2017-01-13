//
//  AvailableServicesChangedEvent.swift
//  Pods
//
//  Created by Daniel de Jesus Oliveira on 27/12/2016.
//
//

import Foundation

struct ServiceAvailabilityChangeEvent: ConnectionEvent {
    let availableServiceIDs: [String]
}
