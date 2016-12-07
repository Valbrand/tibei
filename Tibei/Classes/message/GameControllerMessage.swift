//
//  GameControllerMessage.swift
//  FamilyTrivia
//
//  Created by Daniel de Jesus Oliveira on 20/11/2016.
//  Copyright © 2016 Back St Eltons. All rights reserved.
//

import Foundation

protocol GameControllerMessage {
    var payload: [String:Any] { get }
    var type: GameControllerMessageType { get }
    
    static func rejectionMessage() -> Self
    static func keepAliveMessage() -> Self
}

extension GameControllerMessage {
    typealias Length = UInt32
    
    func dehydrated() -> Data {
        var messageTypeValue: UInt8 = self.type.rawValue
        var dataWithTypeAndLength = withUnsafePointer(to: &messageTypeValue) {
            pointer in
            
            return Data(bytes: pointer, count: MemoryLayout<UInt8>.size)
        }
        
        let dehydratedPayload: Data = try! JSONSerialization.data(withJSONObject: self.payload, options: [])
        var payloadLength: Length = Length(dehydratedPayload.count)
        
        let lengthData = withUnsafePointer(to: &payloadLength) {
            pointer in
            
            return Data(bytes: pointer, count: MemoryLayout<Length>.size)
        }
        
        dataWithTypeAndLength.append(lengthData)
        dataWithTypeAndLength.append(dehydratedPayload)
        
        return dataWithTypeAndLength
    }
    
    static func fromStream<MessageType: GameControllerMessageType>(_ stream: InputStream, messageType: MessageType.Type) throws -> Self {
        var messageTypeByte: UInt8 = 0
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
        return actualMessageType.hydratedMessage(data: payloadDataJSON) as! Self
    }
}
