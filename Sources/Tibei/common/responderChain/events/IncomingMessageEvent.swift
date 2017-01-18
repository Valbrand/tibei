//
//  IncomingMessageEvent.swift
//  Pods
//
//  Created by Daniel de Jesus Oliveira on 27/12/2016.
//
//

import Foundation

struct IncomingMessageEvent: ConnectionEvent {
    let message: [String: Any]
    let connectionID: ConnectionID
}
