//
//  ServerViewController.swift
//  Tibei
//
//  Created by DANIEL J OLIVEIRA on 12/7/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Tibei

class ServerViewController: UIViewController {

    @IBOutlet weak var incomingMessageLabel: UILabel!
    
    let server = ServerMessenger(serviceIdentifier: "_tibei")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        server.registerResponder(self)
    }
}

extension ServerViewController: ConnectionResponder {
    var allowedMessages: [JSONConvertibleMessage.Type] {
        return [TextMessage.self, PingMessage.self]
    }
    
    func processMessage(_ message: JSONConvertibleMessage, fromConnectionWithID connectionID: ConnectionID) {
        
        switch message {
        case let textMessage as TextMessage:
            let labelContent = NSMutableAttributedString(string: "\(textMessage.sender): \(textMessage.content)")
            
            labelContent.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleDouble.rawValue, range: NSMakeRange(0, textMessage.sender.characters.count + 1))
            
            DispatchQueue.main.async {
                self.incomingMessageLabel.attributedText = labelContent
            }
            
        case let pingMessage as PingMessage:
            let labelContent = NSMutableAttributedString(string: "PING FROM \(pingMessage.sender)!!")
            
            DispatchQueue.main.async {
                self.incomingMessageLabel.attributedText = labelContent
            }
            
        default:
            break
        }
    }
    
    func acceptedConnection(withID connectionID: ConnectionID) {
        let rawContent: String = "New connection with id #\(connectionID.hashValue)"
        let labelContent = NSMutableAttributedString(string: rawContent)
        
        labelContent.addAttribute(NSForegroundColorAttributeName, value: UIColor.purple, range: NSMakeRange(0, rawContent.characters.count))
        
        DispatchQueue.main.async {
            self.incomingMessageLabel.attributedText = labelContent
        }
    }
    
    func lostConnection(withID connectionID: ConnectionID) {
        let rawContent: String = "Lost connection with id #\(connectionID.hashValue)"
        let labelContent = NSMutableAttributedString(string: rawContent)
        
        labelContent.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSMakeRange(0, rawContent.characters.count))
        
        DispatchQueue.main.async {
            self.incomingMessageLabel.attributedText = labelContent
        }
    }
    
    func processError(_ error: Error, fromConnectionWithID connectionID: ConnectionID?) {
        print("Error raised from connection #\(connectionID?.hashValue):")
        print(error)
    }
}
