//
//  UI_Util.swift
//  CS-IA
//
//  Created by Trevor Yip on 26/9/2019.
//  Copyright © 2019 Trevor Yip. All rights reserved.
//

import Foundation
import UIKit


//Code based on https://stackoverflow.com/questions/24380535/how-to-apply-gradient-to-background-view-of-ios-swift-app
class UI_Util {
    
    /// Creates UIColor object from RGB values
    /// - Parameters:
    ///   - r: Red value
    ///   - g: Green value
    ///   - b: Blue value
    static func makeUIColour(r : Double, g : Double, b : Double) -> CGColor
    {
        return UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: 1.0).cgColor
    }
    
    /// Sets background gradient
    /// - Parameters:
    ///   - uiView: Table view
    ///   - firstRGB: First colour
    ///   - secondRGB: Second colour
    ///   - thirdRGB: Third colour
    static func setGradient(uiView: UIView, firstRGB: RGBObject, secondRGB: RGBObject, thirdRGB: RGBObject) {
        
        let colorTop =  makeUIColour(r: firstRGB.red, g: firstRGB.green, b: firstRGB.blue)
        let colorMiddle = makeUIColour(r: secondRGB.red, g: secondRGB.green, b: secondRGB.blue)
        let colorBottom = makeUIColour(r: thirdRGB.red, g: thirdRGB.green, b: thirdRGB.blue)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorMiddle, colorBottom]
        gradientLayer.locations = [ 0.0, 0.5, 1.0]
        gradientLayer.frame = uiView.bounds
        
        uiView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// Creates a gradient layer with 3 colours
    /// - Parameters:
    ///   - uiView: View
    ///   - firstRGB: First colour
    ///   - secondRGB: Second colour
    ///   - thirdRGB: Third colour
    static func get3ColourGradient(uiView: UIView, firstRGB: RGBObject, secondRGB: RGBObject, thirdRGB: RGBObject) -> CAGradientLayer {
        
        let colorTop =  makeUIColour(r: firstRGB.red, g: firstRGB.green, b: firstRGB.blue)
        let colorMiddle = makeUIColour(r: secondRGB.red, g: secondRGB.green, b: secondRGB.blue)
        let colorBottom = makeUIColour(r: thirdRGB.red, g: thirdRGB.green, b: thirdRGB.blue)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorMiddle, colorBottom]
        gradientLayer.locations = [ 0.0, 0.5, 1.0]
        gradientLayer.frame = uiView.bounds
        
        return gradientLayer
    }

    /// Creates a gradient layer with 2 colours
    /// - Parameters:
    ///   - uiView: View
    ///   - firstRGB: First colour
    ///   - secondRGB: Second colour
    static func get2ColourGradient(uiView: UIView, firstRGB: RGBObject, secondRGB: RGBObject) -> CAGradientLayer {
        
        let colorTop = makeUIColour(r: firstRGB.red, g: firstRGB.green, b: firstRGB.blue)
        let colorBottom = makeUIColour(r: secondRGB.red, g: secondRGB.green, b: secondRGB.blue)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = uiView.bounds
        
        return gradientLayer
    }
}
