//
//  IncomingMessageData.swift
//  Pods
//
//  Created by Daniel de Jesus Oliveira on 17/12/2016.
//
//

import Foundation

enum IncomingData {
    case nilMessage
    case keepAliveMessage
    case data([String:Any])
}
