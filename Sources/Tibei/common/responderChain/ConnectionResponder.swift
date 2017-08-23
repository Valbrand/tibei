//
//  MessageReceiver.swift
//  Pods
//
//  Created by Daniel de Jesus Oliveira on 27/12/2016.
//
//

/**
 Represents an entity that responds to received messages. It can explicitly state which types of messages it expects, and will only be prompted to process a message if appropriated.
 */
public protocol ConnectionResponder: class {
    /**
     An array of types representing the messages it wants to receive.
     */
    var allowedMessages: [JSONConvertibleMessage.Type] { get }
    
    /**
     Processes a message that was received through an active connection.
     
     - Parameters:
        - message: The message received through the connection
        - connectionID: The identifier of the connection that received the message
     */
    func processMessage(_ message: JSONConvertibleMessage, fromConnectionWithID connectionID: ConnectionID)
    /**
     Notifies the responder that a connection has been accepted
     
     - Parameter connectionID: The identifier of the accepted connection
     */
    func acceptedConnection(withID connectionID: ConnectionID)
    /**
     Notifies the responder that a connection has been lost
     
     - Parameter connectionID: The identifier of the lost connection
     */
    func lostConnection(withID connectionID: ConnectionID)
    /**
     Processes an error that occurred while handling an active connection
     
     - Parameters:
        - error: The error that occurred.
        - connectionID: The identifier of the connection that raised the error.
     */
    func processError(_ error: Error, fromConnectionWithID connectionID: ConnectionID?)
}

public extension ConnectionResponder {
    /**
     An empty array. Note that this will cause the responder not to receive any messages. You have to explicitly state the messages that your responder will handle.
     */
    var allowedMessages: [JSONConvertibleMessage.Type] {
        return []
    }
    
    /// :nodoc:
    func processMessage(_ message: JSONConvertibleMessage, fromConnectionWithID connectionID: ConnectionID) {
    }
    
    /// :nodoc:
    func acceptedConnection(withID connectionID: ConnectionID) {
    }
    
    /// :nodoc:
    func lostConnection(withID connectionID: ConnectionID) {
    }
    
    /// :nodoc:
    func processError(_ error: Error, fromConnectionWithID connectionID: ConnectionID?) {
    }
}
