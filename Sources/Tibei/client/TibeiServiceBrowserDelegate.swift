//
//  MessageSender.swift
//  connectivityTest
//
//  Created by Daniel de Jesus Oliveira on 15/11/2016.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import Foundation

protocol TibeiServiceBrowserDelegate {
    func gameControllerServiceBrowser(_ browser: TibeiServiceBrowser, raisedErrors errorDict: [String:NSNumber])
    func gameControllerServiceBrowser(_ browser: TibeiServiceBrowser, foundService service: NetService, moreComing: Bool)
    func gameControllerServiceBrowser(_ browser: TibeiServiceBrowser, removedService service: NetService, moreComing: Bool)
}
