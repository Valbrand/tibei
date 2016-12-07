//
//  JSONConvertibleMessageFactory.swift
//  Pods
//
//  Created by DANIEL J OLIVEIRA on 12/7/16.
//
//

import Foundation

protocol JSONConvertibleMessageFactory {
    associatedtype Message: JSONConvertibleMessage
    
    static func fromJSONObject(_ jsonObject: [String:Any]) -> Message?
}

extension JSONConvertibleMessageFactory {
    static func fromInput(_ input: InputStream) throws -> Message {
        /*var messageTypeByte: UInt8 = 0
        _ = stream.read(&messageTypeByte, maxLength: 1)
        let messageType: MessageType? = MessageType(rawValue: messageTypeByte)
        guard let actualMessageType = messageType else {
            throw ConnectionError.invalidMessageType(messageTypeByte)
        }
        
        var lengthInBytes = Array<UInt8>(repeating: 0, count: MemoryLayout<Length>.size)
        _ = stream.read(&lengthInBytes, maxLength: lengthInBytes.count)
        let length = UnsafePointer(lengthInBytes).withMemoryRebound(to: Length.self, capacity: 1) {
            $0.pointee
        }
        
        var actualDataBuffer = Array<UInt8>(repeating: 0, count: Int(length))
        let readBytesCount = stream.read(&actualDataBuffer, maxLength: actualDataBuffer.count)
        if readBytesCount < 0 {
            throw ConnectionError.inputError
        }
        
        let payloadData = Data(bytes: actualDataBuffer)
        let payloadDataJSON = try JSONSerialization.jsonObject(with: payloadData, options: []) as! [String: Any]
        return actualMessageType.hydratedMessage(data: payloadDataJSON) as! Self*/
        
        do {
            let payload = try JSONSerialization.jsonObject(with: input) as! [String:Any]
            if let message = Self.fromJSONObject(payload) {
                return message
            } else {
                throw ConnectionError.invalidMessageType(payload)
            }
        }
    }
}
