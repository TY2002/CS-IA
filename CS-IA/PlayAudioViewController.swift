//
//  PlayAudioViewController.swift
//  CS-IA
//
//  Created by Trevor Yip on 14/9/2019.
//  Copyright © 2019 Trevor Yip. All rights reserved.
//

import UIKit
import Firebase

class PlayAudioViewController: UIViewController {
    
    ///Gradient: Atlas
    var PAViewBackgroundFirstRGB : RGBObject = RGBObject.init(r: 254, g: 172, b: 94)
    var PAViewBackgroundSecondRGB : RGBObject = RGBObject.init(r: 199, g: 121, b: 208)
    var PAViewBackgroundThirdRGB : RGBObject = RGBObject.init(r: 75, g: 192, b: 200)
    
    var ButtonTags : [Int: String] =
    [
        0 : "a",
        1 : "b",
        2 : "c-k-ck",
        3 : "d",
        4 : "e",
        5 : "f",
        6 : "g",
        7 : "h",
        8 : "i",
        9 : "j",
        10 : "c-k-ck",
        11 : "l",
        12 : "m",
        13 : "n",
        14 : "o",
        15 : "p",
        16 : "qu",
        17 : "r",
        18 : "s",
        19 : "t",
        20 : "u",
        21 : "v",
        22 : "w",
        23 : "x",
        24 : "y",
        25 : "z",
    ]
    
    @IBOutlet weak var bottomStackView: UIStackView!
    
    /// Plays sound when button is pressed
    ///
    /// - Parameter sender: The button pressed by the user
    @IBAction func playSound(_ sender: UIButton) {
        let fileName : String = ButtonTags[sender.tag]!
        DDsounds.playSoundImmediately(fileName + ".m4a")
    }
    
    /// Presents alert on screen containing instructions when user presses instruction button
    ///
    /// - Parameter sender: Instruction button
    //Alert code based on https://learnappmaking.com/uialertcontroller-alerts-swift-how-to/
    @IBAction func instructions(_ sender: Any) {
        let PAalert = UIAlertController(title: "Instructions", message: "The Play Audio tool allows you to play audio. Tap on the appropriate buttons and the corresponding sound will play.", preferredStyle: .alert)
        PAalert.addAction(UIAlertAction(title: "Exit", style: .default, handler: nil))
        self.present(PAalert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgView = UIView.init(frame: self.view.frame)
        let gradientLayer = UI_Util.get3ColourGradient(uiView: bgView, firstRGB: PAViewBackgroundFirstRGB, secondRGB: PAViewBackgroundSecondRGB, thirdRGB: PAViewBackgroundThirdRGB)
        self.view.layer.insertSublayer(gradientLayer, below: bottomStackView.layer)
    }

}
