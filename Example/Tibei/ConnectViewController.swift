//
//  ViewController.swift
//  Tibei
//
//  Created by Daniel Oliveira on 12/07/2016.
//  Copyright (c) 2016 Daniel Oliveira. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {

    @IBOutlet weak var messageContentTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        
    }
}

