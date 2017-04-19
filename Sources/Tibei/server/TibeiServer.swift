//
//  GameControllerService.swift
//  connectivityTest
//
//  Created by Daniel de Jesus Oliveira on 15/11/2016.
//  Copyright © 2016 Daniel de Jesus Oliveira. All rights reserved.
//

import UIKit
import Foundation

class TibeiServer: NSObject, NetServiceDelegate {
    let deviceName: String = UIDevice.current.name
    
    let service: NetService
    
    let messenger: ServerMessenger
    
    init(messenger: ServerMessenger, serviceIdentifier: String) {
        self.messenger = messenger
        
        let serviceType = "\(serviceIdentifier)._tcp"
        
        self.service = NetService(domain: "local", type: serviceType, name: self.deviceName)
        
        super.init()
    }
    
    func publishService() {
        self.service.includesPeerToPeer = true
        self.service.delegate = self
        self.service.publish(options: .listenForConnections)
    }
    
    func unpublishService() {
        self.service.stop()
    }
    
    // MARK: - NetServiceDelegate protocol
    // As opposed to the rest of the project, this method is inside the class definition instead
    // of inside an extension because otherwise, an @nonobjc attribute would be needed
    func netService(_ sender: NetService, didAcceptConnectionWith inputStream: InputStream, outputStream: OutputStream) {
        OperationQueue.main.addOperation {
            [weak self] in
            
            let newConnection = Connection(input: inputStream, output: outputStream)
            
            self?.messenger.addConnection(newConnection)
        }
    }
}
