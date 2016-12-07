//
//  CodecExtensions.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

extension OutputStream {
    func writeMessage(_ message: JSONConvertibleMessage) throws -> Int {
        guard self.hasSpaceAvailable else {
            throw ConnectionError.outputStreamUnavailable
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: message.toJSONObject())

            let bytesWritten = data.withUnsafeBytes {
                unsafeDataPointer in

                self.write(unsafeDataPointer, maxLength: data.count)
            }

            if bytesWritten != data.count {
                throw ConnectionError.outputError
            }

            return bytesWritten
        }
    }
}
