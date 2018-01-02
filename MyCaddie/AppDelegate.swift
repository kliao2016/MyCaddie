
//
//  AppDelegate.swift
//  MyCaddie
//
//  Created by Kevin Liao on 5/27/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import GooglePlaces
import GooglePlacePicker

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Configure Google Firebase
        FirebaseApp.configure()
        
        // Configure Google Sign-In
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        // Indicate when user is signed in
        GIDSignIn.sharedInstance().delegate = self
        
        // Configure Google Places API
        GMSPlacesClient.provideAPIKey("AIzaSyCIbrOSJmIigUGGX47BGKqb8hK2l-8L-5o")
        
        // Configure Google PlacePicker
        GMSServices.provideAPIKey("AIzaSyCIbrOSJmIigUGGX47BGKqb8hK2l-8L-5o")
        
        UITextField.appearance().keyboardAppearance = .dark
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [UIApplicationOpenURLOptionsKey.annotation])
    }
    
    // Necessary for app to run in ios 8 or later
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    // Methods to handle Google Sign-In process
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if error == nil && user != nil {
            // Get authentication tokens
            guard let authentication = user.authentication else { return }
            let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credentials) { (user, error) in
                if error == nil && user != nil {
                    let databaseRef = Database.database().reference()
                    let uid = Auth.auth().currentUser?.uid
                    let userReference = databaseRef.child("Users").child(uid!)
                    userReference.observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.hasChild("Name") {
                            if let dictionary = snapshot.value as? [String: AnyObject] {
                                Main.appUser.name = dictionary["Name"] as? String
                                Main.appUser.email = dictionary["Email"] as? String
                                self.segueToMain()
                            }
                        } else {
                            Main.appUser.name = user?.displayName
                            Main.appUser.email = user?.email
                            let values = ["Name": Main.appUser.name, "Email": Main.appUser.email]
                            
                            let databaseRef = Database.database().reference()
                            let uid = Auth.auth().currentUser?.uid
                            let userReference = databaseRef.child("Users").child(uid!)
                            let lifetimeRef = userReference.child("Lifetime Stats")
                            let lifetimeStats = ["Fairways": 0, "Fairway Bunkers": 0, "Greens": 0, "Greenside Bunkers": 0, "Hazards": 0, "Fringes": 0, "Lefts": 0, "Rights": 0, "OBs": 0, "Putts": 0, "Score": 0]
                            userReference.child("Handicap").setValue("0")
                            
                            lifetimeRef.updateChildValues(lifetimeStats)
                            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                                if error != nil {
                                    print("Error signing in with Google")
                                }
                            })
                            self.segueToMain()
                        }
                    }, withCancel: nil)
                    return
                }
            }
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        
    }
    
    func segueToMain() {
        // Access the storyboard and fetch an instance of the view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let viewController = storyboard.instantiateViewController(withIdentifier: "mainMenu")
        
        // Push that view controller onto the navigation stack
        let rootViewController = self.window!.rootViewController!;
        rootViewController.present(viewController, animated: true, completion: nil)
    }

}
