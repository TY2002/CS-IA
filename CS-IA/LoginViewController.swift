//
//  LoginViewController.swift
//  CS-IA
//
//  Created by Trevor Yip on 18/10/2019.
//  Copyright © 2019 Trevor Yip. All rights reserved.
//

import UIKit
import FirebaseAuth

//Login system code based on https://medium.com/@ashikabala01/how-to-build-login-and-sign-up-functionality-for-your-ios-app-using-firebase-within-15-mins-df4731faf2f7
class LoginViewController: UIViewController {

    ///Gradient: Digital Water
    let loginViewBackgroundFirstRGB : RGBObject = RGBObject.init(r: 116, g: 235, b: 213)
    let loginViewBackgroundSecondRGB : RGBObject = RGBObject.init(r: 172, g: 182, b: 229)
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    /// Logs in user and performs segue to NavigationTableViewController
    ///
    /// - Parameter sender: Login button
    @IBAction func login(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil
            {
                self.performSegue(withIdentifier: "loginToHome", sender: self)
            }
            else
            {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ///Sets background gradient
        //Code based on https://stackoverflow.com/questions/18638779/setting-a-background-layer-below-uitableview
        let bgView = UIView.init(frame: self.view.frame)
        let gradientLayer = UI_Util.get2ColourGradient(uiView: bgView, firstRGB: loginViewBackgroundFirstRGB, secondRGB: loginViewBackgroundSecondRGB)
        self.view.layer.insertSublayer(gradientLayer, below: email.layer)
        hideKeyboardWhenTappedAround()
    }
}
