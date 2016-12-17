//
//  IncomingMessageData.swift
//  Pods
//
//  Created by Daniel de Jesus Oliveira on 17/12/2016.
//
//

import Foundation

enum IncomingMessageData<Message: JSONConvertibleMessage> {
    case nilMessage
    case keepAliveMessage
    case message(Message)
}
