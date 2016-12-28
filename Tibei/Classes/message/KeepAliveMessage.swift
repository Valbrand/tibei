//
//  KeepAliveMessage.swift
//  Pods
//
//  Created by DANIEL J OLIVEIRA on 12/7/16.
//
//

import Foundation

struct KeepAliveMessage: JSONConvertibleMessage {
    public static func fromJSONObject(_ jsonObject: [String : Any]) -> KeepAliveMessage? {
        return KeepAliveMessage(jsonObject: jsonObject)
    }
    
    var hasMoreData: Bool = false
    
    init() { }
    
    init(jsonObject: [String : Any]) {
        if jsonObject.count > 1 {
            self.hasMoreData = true
        }
    }
    
    func toJSONObject() -> [String : Any] {
        return [:]
    }
}
