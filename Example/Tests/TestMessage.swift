//
//  TestMessage.swift
//  Tibei
//
//  Created by Daniel de Jesus Oliveira on 27/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Tibei

class TestMessage: JSONConvertibleMessage {
    let message: String
    
    init(message: String) {
        self.message = message
    }
    
    required init?(jsonObject: [String : Any]) {
        guard let message = jsonObject["payload"] as? String else {
            return nil
        }
        
        self.message = message
    }
    
    func toJSONObject() -> [String : Any] {
        return [
            "payload": self.message
        ]
    }
}
