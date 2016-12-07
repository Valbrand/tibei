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
    
    func startBrowsing() {
        var serviceType: String

        #if DEBUG
            let baseServiceType = Bundle.main.object(forInfoDictionaryKey: "GameControllerServiceType") as! String
            let currentUser = Bundle.main.object(forInfoDictionaryKey: "CurrentUser") as? String ?? ""

            serviceType = "\(baseServiceType)\(currentUser)._tcp"
        #else
            let baseServiceType = Bundle.main.object(forInfoDictionaryKey: "GameControllerServiceType") as! String

            serviceType = "\(baseServiceType)._tcp"
        #endif

        self.serviceBrowser.searchForServices(ofType: serviceType, inDomain: "local")
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
