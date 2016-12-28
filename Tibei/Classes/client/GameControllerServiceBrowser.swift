//
//  GameControllerClient.swift
//  connectivityTest
//
//  Created by Daniel de Jesus Oliveira on 15/11/2016.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import UIKit

class GameControllerServiceBrowser: NSObject {
    let serviceBrowser: NetServiceBrowser = NetServiceBrowser()
    
    var inputStream: InputStream?
    var outputStream: OutputStream?
    
    var isBrowsing: Bool = false
    var delegate: GameControllerServiceBrowserDelegate?

    override init() {
        super.init()
        
        self.serviceBrowser.includesPeerToPeer = true
        self.serviceBrowser.delegate = self
    }
    
    func startBrowsing(forServiceType serviceIdentifier: String) {
        self.serviceBrowser.searchForServices(ofType: "\(serviceIdentifier)._tcp", inDomain: "local")
    }
    
    func stopBrowsing() {
        self.serviceBrowser.stop()
    }
}

extension GameControllerServiceBrowser: NetServiceBrowserDelegate {
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        self.isBrowsing = true
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        self.isBrowsing = false
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        self.delegate?.gameControllerServiceBrowser(self, raisedErrors: errorDict)
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        self.delegate?.gameControllerServiceBrowser(self, foundService: service, moreComing: moreComing)
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        self.delegate?.gameControllerServiceBrowser(self, removedService: service, moreComing: moreComing)
    }
}
