//
//  ConnectionError.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

public enum ConnectionError: Error {
    case inputUnavailable
    case invalidMessageType([String:Any])
    case inputError
    
    case outputError
    case outputStreamUnavailable
    case notConnected
    
    case inexistentService
    case connectionFailure
}
