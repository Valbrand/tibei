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
    
    let server = ServerMessenger<MessageFactory>()
    var connection = Set<Connection<MessageFactory>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        server.delegate = ServerMessengerDelegate(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ServerViewController: ServerMessengerDelegateProtocol {
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didReceiveMessage message: Message, fromConnection connection: Connection<MessageFactory>) {
        let labelContent = NSMutableAttributedString(string: "\(message.sender): \(message.content)")
        
        labelContent.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleDouble.rawValue, range: NSMakeRange(0, message.sender.characters.count + 1))
        
        DispatchQueue.main.async {
            self.incomingMessageLabel.attributedText = labelContent
        }
    }
    
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didLoseConnection connection: Connection<MessageFactory>) {
        self.connection.remove(connection)
    }
    
    func messenger(_ messenger: ServerMessenger<MessageFactory>, didAcceptConnection connection: Connection<MessageFactory>) {
        self.connection.insert(connection)
    }
}
