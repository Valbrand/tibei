//
//  ConnectionDelegate.swift
//  connectivityTest
//
//  Created by DANIEL J OLIVEIRA on 11/16/16.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

protocol ConnectionDelegate {
    func connection(_ connection: Connection, hasEndedWithErrors: Bool)
    func connection(_ connection: Connection, receivedData data: [String: Any])
    func connection(_ connection: Connection, raisedError error: Error)
    func connectionOpened(_ connection: Connection)
}
