//
//  ConnectionID.swift
//  Pods
//
//  Created by Daniel de Jesus Oliveira on 27/12/2016.
//
//

import Foundation

public struct ConnectionID: Hashable {
    let id: UUID
    
    public var hashValue: Int {
        return self.id.hashValue
    }
    
    init() {
        self.id = UUID()
    }
    
    public static func ==(lhs: ConnectionID, rhs: ConnectionID) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
