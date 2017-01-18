//
//  Facade.swift
//  Tibei
//
//  Created by Daniel de Jesus Oliveira on 18/01/2017.
//
//

import Foundation
import Tibei

class Facade {
    static let shared = Facade()
    
    var client: ClientMessenger
    var server: ServerMessenger
    
    private init() {
        self.client = ClientMessenger()
        self.server = ServerMessenger(serviceIdentifier: "_tibei")
    }
    
    func startServer() {
        self.server.publishService()
    }
}
