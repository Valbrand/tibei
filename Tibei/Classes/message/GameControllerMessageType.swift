//
//  GameControllerMessageType.swift
//  FamilyTrivia
//
//  Created by Daniel de Jesus Oliveira on 20/11/2016.
//  Copyright © 2016 Back St Eltons. All rights reserved.
//

import Foundation

protocol GameControllerMessageType {
    var rawValue: UInt8 { get }
    
    init?(rawValue: UInt8)
    
    func hydratedMessage(data: [String:Any]) -> GameControllerMessage
}
