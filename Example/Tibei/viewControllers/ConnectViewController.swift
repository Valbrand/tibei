 //
//  ViewController.swift
//  Tibei
//
//  Created by Daniel Oliveira on 12/07/2016.
//  Copyright (c) 2016 Daniel Oliveira. All rights reserved.
//

import UIKit
import Tibei

class ConnectViewController: UIViewController {

    @IBOutlet weak var messageContentTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var pingButton: UIButton!
    
    let client = ClientMessenger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.client.registerResponder(self)
        self.client.browseForServices(withIdentifier: "_tibei")
        
    }

    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        let sender = UIDevice.current.name
        let messageContent = self.messageContentTextField.text
        let trimmedMessage = messageContent!.trimmingCharacters(in: .whitespaces)
        
        if !trimmedMessage.isEmpty {
            let message = TextMessage(sender: sender, content: trimmedMessage)
            
            do {
                try self.client.sendMessage(message)
            } catch {
                print("Error trying to send message:")
                print(error)
            }
        }
    }
    
    @IBAction func pingButtonTapped(_ sender: Any) {
        let sender = UIDevice.current.name
        
        let message = PingMessage(sender: sender)
        
        do {
            try self.client.sendMessage(message)
        } catch {
            print("Error trying to send message:")
            print(error)
        }
    }
}
 
extension ConnectViewController: ClientConnectionResponder {
    func availableServicesChanged(availableServiceIDs: [String]) {
        do {
            try self.client.connect(serviceName: availableServiceIDs.first!)
        } catch {
            print("An error occurred while trying to connect")
            print(error)
        }
    }
    
    func acceptedConnection(withID connectionID: ConnectionID) {
        self.sendMessageButton.isEnabled = true
        self.pingButton.isEnabled = true
    }
}

