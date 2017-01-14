//
//  SignInVC.swift
//  DevsSociall
//
//  Created by Avinash Reddy on 1/13/17.
//  Copyright © 2017 theEine. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookButtonTapped(_ sender: Any) {
        
        // Facebook login
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Avinash Error: Unable to authenticate with Facebook: \(error)")
            } else if result?.isCancelled == true { // to handle sudden cancelllation
                
                print("Avinash Error: User Cancelled Facebok Authentication")
                
            } else {
                print("Avinash Succes: Succesfully authenticatd with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()!.signIn(with: credential) { (user, error) in
            if error != nil {
                print("Avinash Error: Unable to authenticate with Firebase \(error?.localizedDescription)")
            } else {
                print("Avinash Success: Succesfully authenticated with Firebase")
            }
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        if let email = emailTextField.text {
            if let pwd = passwordTextField.text {
                FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                    if error == nil {
                        print("Avinash Success: Successfully Authenticated")
                        
                    } else {
                        FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                            if error != nil {
                                print("Avinash Error: Unable to authenticate with Firebase \(error?.localizedDescription)")
                            } else {
                                print("Avinash Success: Succesfully Authentitcated")
                            }
                        })
                    }
                })
            }
        }
    }

}

