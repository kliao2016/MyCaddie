//
//  LoadingScreen.swift
//  MyCaddie
//
//  Created by Weston Mauz on 6/15/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class LoadingScreen: UIViewController {
    
    var stringPassed = ""
    var programVar : Program?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let a = stringPassed
        print("Ayo")
        print(stringPassed)
        print(a)
        
        print("Maybe")
        print(programVar?.cName)
        print(programVar?.tName)
        print(programVar?.currentHoleNumber)
        
        
        
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
