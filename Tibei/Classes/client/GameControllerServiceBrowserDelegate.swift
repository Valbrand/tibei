//
//  MessageSender.swift
//  connectivityTest
//
//  Created by Daniel de Jesus Oliveira on 15/11/2016.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

protocol GameControllerServiceBrowserDelegate {
    func gameControllerServiceBrowser(_ browser: GameControllerServiceBrowser, raisedErrors errorDict: [String:NSNumber])
    func gameControllerServiceBrowser(_ browser: GameControllerServiceBrowser, foundService service: NetService, moreComing: Bool)
    func gameControllerServiceBrowser(_ browser: GameControllerServiceBrowser, removedService service: NetService, moreComing: Bool)
}
