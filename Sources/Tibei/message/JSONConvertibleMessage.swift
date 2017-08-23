//
//  JSONConvertibleMessage.swift
//  Pods
//
//  Created by DANIEL J OLIVEIRA on 12/7/16.
//
//

import Foundation

/**
 A protocol that allows Tibei to convert your custom messages to a JSON format. Note that it is mandatory to represent your object as a dictionary. That's because Tibei embeds metadata in the data before sending it.
 */
public protocol JSONConvertibleMessage {
    /**
     Initializes an object from a dictionary representing the JSON object. It's called upon receiving a message
     */
    init(jsonObject:[String:Any])
    
    /**
     Transforms the instance of the message into a JSON dictionary.
     */
    func toJSONObject() -> [String:Any]
}

extension JSONConvertibleMessage {
    static var type: String {
        return String(describing: Self.self)
    }
}
