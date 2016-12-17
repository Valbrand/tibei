//
//  CodecExtensions.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

extension OutputStream {
    typealias Length = UInt32
    
    func writeMessage(_ message: JSONConvertibleMessage) throws -> Int {
        guard self.hasSpaceAvailable else {
            throw ConnectionError.outputStreamUnavailable
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: message.toJSONObject())
            var payloadLength: Length = Length(data.count)
            
            var dataWithLength = withUnsafePointer(to: &payloadLength) {
                pointer in
                
                return Data(bytes: pointer, count: MemoryLayout<Length>.size)
            }
            
            dataWithLength.append(data)

            let bytesWritten = dataWithLength.withUnsafeBytes {
                unsafeDataPointer in

                self.write(unsafeDataPointer, maxLength: dataWithLength.count)
            }
            
            if bytesWritten != dataWithLength.count {
                throw ConnectionError.outputError
            }

            return bytesWritten
        }
    }
}
