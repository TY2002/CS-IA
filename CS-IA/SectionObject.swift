//
//  SectionObject.swift
//  CS-IA
//
//  Created by Trevor Yip on 6/9/2019.
//  Copyright © 2019 Trevor Yip. All rights reserved.
//

import UIKit

class SectionObject: NSObject {
    var name : String!
    var content : Array<String>!
    
    init(name: String, content: Array<String>)
    {
        self.name = name
        self.content = content
    }
}
