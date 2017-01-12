//
//  MessageReceiver.swift
//  Pods
//
//  Created by Daniel de Jesus Oliveira on 27/12/2016.
//
//

public protocol ConnectionResponder: class {
    var allowedMessages: [JSONConvertibleMessage.Type] { get }
    
    func processMessage(_ message: JSONConvertibleMessage, fromConnectionWithID connectionID: ConnectionID)
    func acceptedConnection(withID connectionID: ConnectionID)
    func lostConnection(withID connectionID: ConnectionID)
    func processError(_ error: Error, fromConnectionWithID connectionID: ConnectionID?)
}

public extension ConnectionResponder {
    var allowedMessages: [JSONConvertibleMessage.Type] {
        return []
    }
    
    func processMessage(_ message: JSONConvertibleMessage, fromConnectionWithID connectionID: ConnectionID) {
    }
    
    func acceptedConnection(withID connectionID: ConnectionID) {
    }
    
    func lostConnection(withID connectionID: ConnectionID) {
    }
    
    func processError(_ error: Error, fromConnectionWithID connectionID: ConnectionID?) {
    }
}
