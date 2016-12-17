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
    
    let client = ClientMessenger<MessageFactory>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.client.delegate = ClientMessengerDelegate(self)
        self.client.browseForServices()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        let sender = UIDevice.current.name
        let messageContent = self.messageContentTextField.text
        let trimmedMessage = messageContent!.trimmingCharacters(in: .whitespaces)
        
        if !trimmedMessage.isEmpty {
            let message = Message(sender: sender, content: trimmedMessage)
            
            do {
                try self.client.sendMessage(message)
            } catch {
                print("Error trying to send message:")
                print(error)
            }
        }
    }
}

extension ConnectViewController: ClientMessengerDelegateProtocol {
    func messengerConnected(_ messenger: ClientMessenger<MessageFactory>) {
        self.sendMessageButton.isEnabled = true
    }
    
    func messengerDisconnected(_ messenger: ClientMessenger<MessageFactory>) {
        
    }
    
    func messenger(_ messenger: ClientMessenger<MessageFactory>, didReceiveMessage message: Message) {
        
    }
    
    func messenger(_ messenger: ClientMessenger<MessageFactory>, didUpdateServices services: [String]) {
        do {
            try self.client.connect(serviceName: services.first!)
        } catch {
            print("An error occurred while trying to connect")
            print(error)
        }
    }
}

