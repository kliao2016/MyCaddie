//
//  LoginViewController.swift
//  MyCaddie
//
//  Created by Kevin Liao on 5/27/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var signInControl: UISegmentedControl!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var googleSignIn: GIDSignInButton!
    
    var isSignIn: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set UI Delegate for GIDSignIn object
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment Sign in user automatically
        // GIDSignIn.sharedInstance().signIn()
        
        googleSignIn = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectorChange(_ sender: UISegmentedControl) {
        
        // Flip boolean
        isSignIn = !isSignIn
        
        // Check boolean and change labels and button accordingly
        if isSignIn {
            signInLabel.text = "Sign In"
            signInButton.setTitle("Sign In", for: .normal)
        } else {
            signInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        
        // TODO: Make sure email and password fields are valid
        
        
        // Check if signing in or registering
        if isSignIn {
            // Log in the user with Firebase
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passTextField.text!, completion: { (user, error) in
                // Check that credentials are valid
                if error != nil {
                    // If user is found, go to main screen
                    self.performSegue(withIdentifier: "mainSegue", sender: self)
                } else {
                    self.displayAlert()
                }
                
            })
        } else {
            // Create user in Firebase
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passTextField.text!, completion: { (user, error) in
                // Check that user isn't nil
                if error != nil {
                    // If user is found, go to main screen
                    self.performSegue(withIdentifier: "mainSegue", sender: self)
                } else {
                    self.displayAlert()
                }
            })
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Dismiss keyboard when view is tapped on
        emailTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
    }
    
    func displayAlert() {
        let alertController = UIAlertController(title: "Error", message: "The username or password you entered is incorrect. Please trya gain.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
