//
//  RGBObject.swift
//  CS-IA
//
//  Created by Trevor Yip on 26/9/2019.
//  Copyright © 2019 Trevor Yip. All rights reserved.
//

import Foundation
import UIKit

class RGBObject: NSObject
{
    var red: Double = 0
    var green: Double = 0
    var blue: Double = 0
    
    init(r: Double, g: Double, b: Double)
    {
        self.red = r
        self.green = g
        self.blue = b
    }
}
