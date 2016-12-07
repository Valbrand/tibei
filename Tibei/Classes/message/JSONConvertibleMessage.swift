//
//  JSONConvertibleMessage.swift
//  Pods
//
//  Created by DANIEL J OLIVEIRA on 12/7/16.
//
//

import Foundation

protocol JSONConvertibleMessage {
    init(jsonObject:[String:Any])
    
    func toJSONObject() -> [String:Any]
}
