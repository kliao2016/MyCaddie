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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var signInControl: UISegmentedControl!
    
    @IBOutlet weak var signInButton: UIButton!
    
    var isSignIn: Bool = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
                // Check that user isn't nil
                if let u = user {
                    // If user is found, go to main screen
                    self.performSegue(withIdentifier: "mainSegue", sender: self)
                } else {
                    // Error
                }
                
            })
        } else {
            // Create user in Firebase
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passTextField.text!, completion: { (user, error) in
                // Check that user isn't nil
                if let u = user {
                    // If user is found, go to main screen
                    self.performSegue(withIdentifier: "mainSegue", sender: self)
                } else {
                    // Error
                }
            })
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Dismiss keyboard when view is tapped on
        emailTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
    }
    
}
