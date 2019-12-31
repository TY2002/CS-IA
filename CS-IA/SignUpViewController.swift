//
//  SignUpViewController.swift
//  CS-IA
//
//  Created by Trevor Yip on 18/10/2019.
//  Copyright © 2019 Trevor Yip. All rights reserved.
//

import UIKit
import Firebase

//Login system code based on https://medium.com/@ashikabala01/how-to-build-login-and-sign-up-functionality-for-your-ios-app-using-firebase-within-15-mins-df4731faf2f7
class SignUpViewController: UIViewController {

    ///Gradient: Digital Water
    let signUpViewBackgroundFirstRGB : RGBObject = RGBObject.init(r: 116, g: 235, b: 213)
    let signUpViewBackgroundSecondRGB : RGBObject = RGBObject.init(r: 172, g: 182, b: 229)
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    
    /// Creates new user with provided credentials, performs segue to NavigationTableViewController
    ///
    /// - Parameter sender: signUp button
    @IBAction func signUp(_ sender: Any) {
        if password.text != passwordConfirm.text
        {
            let alertController = UIAlertController(title: "Passwords Do Not Match", message: "Please re-type password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
                if error == nil
                {
                    self.performSegue(withIdentifier: "signUpToHome", sender: self)
                }
                else
                {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Code based on https://stackoverflow.com/questions/18638779/setting-a-background-layer-below-uitableview
        ///Sets background gradient
        let bgView = UIView.init(frame: self.view.frame)
        let gradientLayer = UI_Util.get2ColourGradient(uiView: bgView, firstRGB: signUpViewBackgroundFirstRGB, secondRGB: signUpViewBackgroundSecondRGB)
        self.view.layer.insertSublayer(gradientLayer, below: email.layer)
        
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Code based on https://stackoverflow.com/questions/25369412/swift-pass-data-through-navigation-controller
        let navigationController = segue.destination as! UINavigationController
        let navigationTableViewController = navigationController.viewControllers.first as! NavigationTableViewController
        navigationTableViewController.loggedInBefore = false
    }
}
