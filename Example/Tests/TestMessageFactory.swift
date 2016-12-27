//
//  TestMessageFactory.swift
//  Tibei
//
//  Created by Daniel de Jesus Oliveira on 27/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Tibei

class TestMessageFactory: JSONConvertibleMessageFactory {
    static func fromJSONObject(_ jsonObject: [String : Any]) -> TestMessage? {
        return TestMessage(jsonObject: jsonObject)
    }
}
