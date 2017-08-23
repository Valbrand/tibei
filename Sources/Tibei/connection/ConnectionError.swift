//
//  ConnectionError.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

/**
 An error that may occur at any point of the connection's lifecycle.
 */
public enum ConnectionError: Error {
    /**
     Thrown if the `OutputStream` of a `Connection` can't take any more data.
     */
    case inputUnavailable
    /**
     Thrown if a responder receives a message with a `_type` field that is not valid (i.e. is not a string).
     */
    case invalidMessageType([String:Any])
    /**
     Thrown if an error occurs while reading from a `Connection`'s `InputStream`.
     */
    case inputError
    
    /**
     Thrown if an error occurs while writing to a `Connection`'s `OutputStream`.
     */
    case outputError
    /**
     Thrown if a `Connection`'s output stream has no space left.
     */
    case outputStreamUnavailable
    /**
     Thrown if an attempt to send a message is made without an active `Connection`.
     */
    case notConnected
    
    /**
     Thrown if an attempt to connect to a service that doesn't exists is made.
     */
    case inexistentService
    /**
     Thrown if an error occurred while trying to obtain a `Connection`'s input and output streams.
     */
    case connectionFailure
}
