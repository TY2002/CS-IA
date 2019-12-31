//
//  StartViewController.swift
//  CS-IA
//
//  Created by Trevor Yip on 18/10/2019.
//  Copyright © 2019 Trevor Yip. All rights reserved.
//

import UIKit
import Firebase

//Login system code based on https://medium.com/@ashikabala01/how-to-build-login-and-sign-up-functionality-for-your-ios-app-using-firebase-within-15-mins-df4731faf2f7
class StartViewController: UIViewController {

    ///Gradient: Digital Water
    let startViewBackgroundFirstRGB : RGBObject = RGBObject.init(r: 116, g: 235, b: 213)
    let startViewBackgroundSecondRGB : RGBObject = RGBObject.init(r: 172, g: 182, b: 229)
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    /// Performs segue to LoginViewController
    ///
    /// - Parameter sender: loginButton
    @IBAction func segueToLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "startToLogin", sender: self)
    }
    
    /// Performs segue to SignUpViewController
    ///
    /// - Parameter sender: signUpButton
    @IBAction func segueToSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "startToSignUp", sender: self)
    }
    
    //Code based on https://stackoverflow.com/questions/30052587/how-can-i-go-back-to-the-initial-view-controller-in-swift
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ///Sets background gradient
        //Code based on https://stackoverflow.com/questions/18638779/setting-a-background-layer-below-uitableview
        let bgView = UIView.init(frame: self.view.frame)
        let gradientLayer = UI_Util.get2ColourGradient(uiView: bgView, firstRGB: startViewBackgroundFirstRGB, secondRGB: startViewBackgroundSecondRGB)
        self.view.layer.insertSublayer(gradientLayer, below: loginButton.layer)
    }
    
    /// Automatic login if user is recognised
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: self)
        }
        hideKeyboardWhenTappedAround()
    }
}

//Code from https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
