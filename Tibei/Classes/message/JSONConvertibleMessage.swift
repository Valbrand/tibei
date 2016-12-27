//
//  JSONConvertibleMessage.swift
//  Pods
//
//  Created by DANIEL J OLIVEIRA on 12/7/16.
//
//

import Foundation

public protocol JSONConvertibleMessage {
    init?(jsonObject:[String:Any])
    
    func toJSONObject() -> [String:Any]
}

extension JSONConvertibleMessage {
    typealias Length = UInt32
    
    static func fromInput(_ stream: InputStream) throws -> IncomingMessageData<Self> {
        var lengthInBytes = Array<UInt8>(repeating: 0, count: MemoryLayout<Length>.size)
        _ = stream.read(&lengthInBytes, maxLength: lengthInBytes.count)
        let length: Length = UnsafePointer(lengthInBytes).withMemoryRebound(to: Length.self, capacity: 1) {
            $0.pointee
        }
        
        guard length > 0 else {
            return .nilMessage
        }
        
        var actualDataBuffer = Array<UInt8>(repeating: 0, count: Int(length))
        let readBytesCount = stream.read(&actualDataBuffer, maxLength: actualDataBuffer.count)
        if readBytesCount < 0 {
            throw ConnectionError.inputError
        }
        
        let payloadData = Data(bytes: actualDataBuffer)
        
        do {
            let payload = try JSONSerialization.jsonObject(with: payloadData, options: []) as! [String:Any]
            
            if let keepAliveMessage = KeepAliveMessage(jsonObject: payload) {
                if !keepAliveMessage.hasMoreData {
                    return .keepAliveMessage
                }
            }
            
            if let message = Self.init(jsonObject: payload) {
                return .message(message)
            } else {
                throw ConnectionError.invalidMessageType(payload)
            }
        }
    }
}
