//
//  ConnectionID.swift
//  Pods
//
//  Created by Daniel de Jesus Oliveira on 27/12/2016.
//
//

import Foundation

/**
 A struct that's used to identify existing connections. An uuid is generated upon this struct's instantiation, and its hashValue is used for comparison.
 */
public struct ConnectionID: Hashable {
    let id: UUID
    
    /// :nodoc:
    public var hashValue: Int {
        return self.id.hashValue
    }
    
    init() {
        self.id = UUID()
    }
    
    /// :nodoc:
    public static func ==(lhs: ConnectionID, rhs: ConnectionID) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
