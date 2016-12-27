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

    static let keepAliveField: String = "_keepAlive"
    
    var hasMoreData: Bool = false
    
    init() { }
    
    init?(jsonObject: [String : Any]) {
        let isKeepAliveMessage: Bool = jsonObject[KeepAliveMessage.keepAliveField] as? Bool ?? false
        
        if isKeepAliveMessage {
            if jsonObject.count > 1 {
                self.hasMoreData = true
            }
        } else {
            return nil
        }
    }
    
    func toJSONObject() -> [String : Any] {
        return [
            KeepAliveMessage.keepAliveField: true
        ]
    }
}
