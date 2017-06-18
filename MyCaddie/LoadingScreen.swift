//
//  LoadingScreen.swift
//  MyCaddie
//
//  Created by Weston Mauz on 6/15/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase
import GoogleSignIn

class LoadingScreen: UIViewController {
    
    var stringPassed = ""
    var programVar : Program?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("first")
        print(programVar?.cName)
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            print("Maybe")
            print(self.programVar?.cName)
            print(self.programVar?.tName)
            print(self.programVar?.currentHoleNumber)
            self.performSegue(withIdentifier: "loadingToStats", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadingToStats" {
            // Create a variable that you want to send

            
                        let newProgramVar = Program(cName: (programVar?.cName)!, tName: (programVar?.tName)!, currentHoleNumber: (programVar?.currentHoleNumber)!)
                        // Create a new variable to store the instance of PlayerTableViewController
                        let destinationVC = segue.destination as! Stats2
                        destinationVC.programVar = newProgramVar
                        print("Final Segue")
            
        }
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToBuffer" {
            // Create a variable that you want to send
            
            var cRound = CurrentRound()
            
            let uid = Auth.auth().currentUser?.uid
            let userReference = Database.database().reference().child("Users").child(uid!).child("Current Round")
            
            var c1Ref = ""
            var t1Ref = ""
            var currentHoleNumberRef = 0
            
            userReference.observeSingleEvent(of: .value, with: {DataSnapshot in
                // Return if no data exists
                //if !DataSnapshot.exists() { return }
                var c1 = ""
                c1 = DataSnapshot.childSnapshot(forPath: "Course Name").value as! String
                var t1 = ""
                t1 = DataSnapshot.childSnapshot(forPath: "Tees").value as! String
                var currentHole = 0
                currentHole = DataSnapshot.childSnapshot(forPath: "Current Hole").value as! Int
                currentHole += 1
                print("I hate this app so much :)")
                print(c1)
                print(t1)
                print(currentHole)
                
                if (c1 != ""){
                    c1Ref = c1
                    t1Ref = t1
                    currentHoleNumberRef = currentHole
                    print("Struct References:")
                    print(c1Ref)
                    print(t1Ref)
                    print(currentHoleNumberRef)
                    cRound.currentCourse = c1
                    cRound.currentTee = t1
                    cRound.currentHole = currentHole
                    
                }
                
            })
            
            print(c1Ref)
            print(t1Ref)
            print(currentHoleNumberRef)
            
            let newProgramVar = Program(cName: "Cherry Hills", tName: "Championship", currentHoleNumber: 4)
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destination as! Stats2
            destinationVC.programVar = newProgramVar
            print("Save This Spot")
            
            
            
            /*
             let newProgramVar = Program(cName: ccc, tName: "Championship", currentHoleNumber: 4)
             // Create a new variable to store the instance of PlayerTableViewController
             let destinationVC = segue.destination as! Stats2
             destinationVC.programVar = newProgramVar
             print("Save This Spot")
             */
            /*
             if (c1 != ""){
             let newProgramVar = Program(cName: c1, tName: "Championship", currentHoleNumber: 4)
             // Create a new variable to store the instance of PlayerTableViewController
             let destinationVC = segue.destination as! Stats2
             destinationVC.programVar = newProgramVar
             print("Save This Spot")
             }
             else {
             let newProgramVar = Program(cName: "Cherry Hills", tName: "Championship", currentHoleNumber: 3)
             // Create a new variable to store the instance of PlayerTableViewController
             let destinationVC = segue.destination as! Stats2
             destinationVC.programVar = newProgramVar
             print("Watwatwat")
             }
             */
        }
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
