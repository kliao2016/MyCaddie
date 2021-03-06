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
        print(programVar?.cName as Any)
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            print("Maybe")
            print(self.programVar?.cName as Any)
            print(self.programVar?.tName as Any)
            print(self.programVar?.currentHoleNumber as Any)
            self.performSegue(withIdentifier: "loadToStatsSegue", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadToStatsSegue" {
            // Create a variable that you want to send
            let newProgramVar = Program(cName: (programVar?.cName)!, tName: (programVar?.tName)!, currentHoleNumber: (programVar?.currentHoleNumber)!)
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destination as! ContinueRound
            destinationVC.programVar = newProgramVar
            print("Final Segue")
            
        }
    }
    
    func showMainView() {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "TabController")
        
        self.present(mainView!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
