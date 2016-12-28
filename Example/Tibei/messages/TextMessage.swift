//
//  Message.swift
//  Tibei
//
//  Created by Daniel de Jesus Oliveira on 07/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import Tibei

class TextMessage: JSONConvertibleMessage {
    var sender: String
    var content: String
    
    init(sender: String, content: String) {
        self.sender = sender
        self.content = content
    }
    
    required init(jsonObject: [String : Any]) {
        self.sender = jsonObject["sender"] as! String
        self.content = jsonObject["content"] as! String
    }
    
    func toJSONObject() -> [String : Any] {
        return [
            "sender": self.sender,
            "content": self.content
        ]
    }
}
