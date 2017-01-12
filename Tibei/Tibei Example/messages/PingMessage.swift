//
//  PingMessage.swift
//  Tibei
//
//  Created by Daniel de Jesus Oliveira on 28/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Tibei

class PingMessage: JSONConvertibleMessage {
    var sender: String
    
    init(sender: String) {
        self.sender = sender
    }
    
    required init(jsonObject: [String : Any]) {
        self.sender = jsonObject["sender"] as! String
    }
    
    func toJSONObject() -> [String : Any] {
        return [
            "sender": self.sender
        ]
    }
}
