//
//  KeepAliveMessage.swift
//  Pods
//
//  Created by DANIEL J OLIVEIRA on 12/7/16.
//
//

import Foundation

struct KeepAliveMessage: JSONConvertibleMessage {
    init() { }
    
    init(jsonObject: [String : Any]) { }
    
    func toJSONObject() -> [String : Any] {
        return [
            "_keepAlive": true
        ]
    }
}
