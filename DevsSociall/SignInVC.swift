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
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Check for keychain key
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: Segue_Main_view, sender: nil)
        }
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
                
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
                
            }
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        if let email = emailTextField.text {
            if let pwd = passwordTextField.text {
                FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                    if error == nil {
                        print("Avinash Success: Successfully Authenticated")
                        if let user = user {
                            self.completeSignIn(id: user.uid)
                        }
                        
                    } else {
                        FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                            if error != nil {
                                print("Avinash Error: Unable to authenticate with Firebase \(error?.localizedDescription)")
                            } else {
                                print("Avinash Success: Succesfully Authentitcated")
                                if let user = user {
                                    self.completeSignIn(id: user.uid)
                                }
                            }
                        })
                    }
                })
            }
        }
    }
    
    // Kechchain - here id is user.uid
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Avinash Success: Data saved to Keychain \(keychainResult)")
        performSegue(withIdentifier: Segue_Main_view, sender: nil)
    }

}

