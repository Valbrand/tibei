//
//  MessageFactory.swift
//  Tibei
//
//  Created by Daniel de Jesus Oliveira on 08/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import Tibei

class MessageFactory: JSONConvertibleMessageFactory {
    static func fromJSONObject(_ jsonObject: [String : Any]) -> Message? {
        return Message(jsonObject: jsonObject)
    }
}
