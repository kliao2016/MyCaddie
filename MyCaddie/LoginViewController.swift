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
import FirebaseStorage
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController, GIDSignInUIDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    var isUserEmailVerified = false
    
    var databaseRef: DatabaseReference?
    let main = Main()
    
    var isSignIn: Bool = true
    
    // All Buttons
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reference to database
        databaseRef = Database.database().reference()
        
        nameTextField.isUserInteractionEnabled = false
        
        // Set UI Delegate for GIDSignIn object
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
      
        // Uncomment to Sign in user automatically
        // GIDSignIn.sharedInstance().signInSilently()
        
        signInButton.backgroundColor = UIColor(red: 0, green: 128/255, blue: 64/255, alpha: 1.0)
        signInButton.layer.cornerRadius = 1.5
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "N/A", attributes: [NSForegroundColorAttributeName: UIColor.white])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes: [NSForegroundColorAttributeName: UIColor.white])
        passTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSForegroundColorAttributeName: UIColor.white])
        nameTextField.delegate = self
        emailTextField.delegate = self
        passTextField.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    @IBAction func selectorChange(_ sender: UISegmentedControl) {
        
        // Flip boolean
        isSignIn = !isSignIn
        
        // Check boolean and change labels and button accordingly
        if isSignIn {
            signInButton.setTitle("Sign In", for: .normal)
            nameTextField.isUserInteractionEnabled = false
            nameTextField.attributedPlaceholder = NSAttributedString(string: "N/A", attributes: [NSForegroundColorAttributeName: UIColor.white])
        } else {
            signInButton.setTitle("Sign Up with Email", for: .normal)
            nameTextField.isUserInteractionEnabled = true
            nameTextField.attributedPlaceholder = NSAttributedString(string: "USERNAME", attributes: [NSForegroundColorAttributeName: UIColor.white])
        }
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        
        // TODO: Make sure email and password fields are valid
        
        
        // Check if signing in or registering
        if isSignIn {
            // Log in the user with Firebase
            login()
        } else {
            // Create user in Firebase
            signUp()
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Dismiss keyboard when view is tapped on
        emailTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }
    
    private func displayAlert() {
        let alertController = UIAlertController(title: "Error", message: "The username or password you entered is incorrect. Please try again.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func displayAlert2() {
        let alertController = UIAlertController(title: "Error", message: "You must sign up with a valid email and password!", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func displayAlertEmailVerification() {
        let alertController = UIAlertController(title: "Verify Email", message: "Please verify your email using the link we sent you.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Login and Sign Up functions
    private func login() {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passTextField.text!, completion: { (user, error) in
            // Check that credentials are valid
            if error == nil && user != nil {
                self.setUp()
                if self.isUserEmailVerified == true {
                    self.displayMainMenu()
                }
            } else {
                self.displayAlert()
            }
        })
    }
    
    private func signUp() {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passTextField.text!, completion: { (user, error) in
            // Check that user isn't nil
            if error == nil && user != nil {
                user?.sendEmailVerification(completion: nil)
                self.setUp()
                if self.isUserEmailVerified == true {
                    self.displayMainMenu()
                }
            } else {
                self.displayAlert2()
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let userReference = self.databaseRef?.child("Users").child(uid)
            self.main.appUser.name = self.nameTextField.text
            let values = ["Name": self.main.appUser.name, "Email": self.emailTextField.text, "Password": self.passTextField.text]
            
            let lifetimeRef = self.databaseRef?.child("Users").child(uid).child("Lifetime Stats")
            let lifetimeStats = ["Fairways": 0, "Fairway Bunkers": 0, "Greens": 0, "Greenside Bunkers": 0, "Hazards": 0, "Fringes": 0, "Lefts": 0, "Rights": 0, "OBs": 0, "Putts": 0, "Score": 0]
            userReference?.child("Handicap").setValue("0")
            
            lifetimeRef?.updateChildValues(lifetimeStats)
            userReference?.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    self.displayAlert2()
                }
            })
        })
    }
    
    func displayMainMenu() {
        let mainMenu = storyboard?.instantiateViewController(withIdentifier: "mainMenu")
        self.present(mainMenu!, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Constrain view to be only portrait
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            nameTextField.resignFirstResponder()
        }
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
        }
        if textField == passTextField {
            passTextField.resignFirstResponder()
        }
        return true
    }
    
    func setUp() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                if user.isEmailVerified {
                    self.isUserEmailVerified = true
                } else {
                    self.displayAlertEmailVerification()
                }
            }
        }
    }
    
    @IBAction func unwindToLoginMenu(segue: UIStoryboardSegue) {}
    @IBAction func unwindToLoginMenu2(segue: UIStoryboardSegue) {}
    @IBAction func unwindToLoginFromProfile(segue: UIStoryboardSegue) {}
    
}
