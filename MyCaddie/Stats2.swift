//
//  Stats2.swift
//  MyCaddie
//
//  Created by Weston Mauz on 6/6/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class Stats2: UIViewController {
    
    var ref = Database.database().reference()
    var databaseHandle: DatabaseHandle?
    
    
    
    var shotCount = String()
    
    var holeScores = [4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4]
    
    // Label text to change every shot
    @IBOutlet weak var ShotNumberText: UILabel!
    // currentScore Display
    @IBOutlet weak var Actual: UILabel!
    // Current Hole
    @IBOutlet weak var HoleNumber: UILabel!
    // Current Yardage
    @IBOutlet weak var HoleYardage: UILabel!
    // Current Par
    @IBOutlet weak var HolePar: UILabel!
    
    
    var putts = Int ()
    var currentHole = Int()
    var currentScore = Int()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initial text
        ShotNumberText.text = "Where was your first shot?"
        Actual.text = "Shots hit: 0"
        HoleNumber.text = "1"
        
        let YardageRef2 = Database.database().reference().child("Golf Course Data").child("www").child("Tees").child("Championship").child("Holes")
        YardageRef2.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            
            let currentYardage = DataSnapshot.childSnapshot(forPath: "\(self.currentHole + 1)").value as! String
            //print("Yardage: " + "\(currentYardage)")
            self.HoleYardage.text = currentYardage
        })
        let ParRef2 = Database.database().reference().child("Golf Course Data").child("www").child("Tees").child("Championship").child("Pars")
        ParRef2.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            //print("Current Hole: " + "\(self.currentHole)")
            let currentPar = DataSnapshot.childSnapshot(forPath: "\(self.currentHole + 1)").value as! String
            //print("Current Par: " + "\(currentPar)")
            self.HolePar.text = currentPar
        })
    }
    
    func PuttPopUp() {
        let popUp = UIAlertController(title: "How many putts did you have?", message: nil, preferredStyle: .alert)
        popUp.addTextField { (textField) in
            textField.text = nil
        }
        
        popUp.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [popUp] (_) in
            let textField = popUp.textFields![0] // Force unwrapping because we know it exists.
            self.putts = Int(textField.text!)!
            self.updateScore()
        }))

        self.present(popUp, animated: true, completion: nil)
    }
    
    // Buttons
    @IBAction func Green(_ sender: Any) {
        currentScore += 1
        PuttPopUp()
    }
    @IBAction func Fringe(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func GreenSand(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func FairwaySand(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func Fairway(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func Hazard(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func OB(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func Right(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func Left(_ sender: Any) {
        currentScore += 1
        updateShotText()
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateShotText() {
        switch currentScore {
        case 0:
            shotCount = "first"
            break
        case 1:
            shotCount = "second"
            break
        case 2:
            shotCount = "third"
            break
        case 3:
            shotCount = "fourth"
            break
        case 4:
            shotCount = "fifth"
            break
        case 5:
            shotCount = "sixth"
            break
        case 6:
            shotCount = "seventh"
            break
        case 7:
            shotCount = "eighth"
            break
        case 8:
            shotCount = "ninth"
            break
        case 9:
            shotCount = "tenth"
            break
        default:
            shotCount = "????"
        }
    }
    
    func updateUI(){
        Actual.text = "Shots Hit: \(currentScore)"
        ShotNumberText.text = "Where was your \(shotCount) shot?"
        HoleNumber.text = "\(currentHole + 1)"
        ref = Database.database().reference()
        let ParRef = Database.database().reference().child("Golf Course Data").child("www").child("Tees").child("Championship").child("Pars")
        let YardageRef = Database.database().reference().child("Golf Course Data").child("www").child("Tees").child("Championship").child("Holes")
        ParRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            //print("Current Hole: " + "\(self.currentHole)")
            let currentPar = DataSnapshot.childSnapshot(forPath: "\(self.currentHole + 1)").value as! String
            //print("Current Par: " + "\(currentPar)")
            self.HolePar.text = currentPar
        })
        YardageRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            
            let currentYardage = DataSnapshot.childSnapshot(forPath: "\(self.currentHole + 1)").value as! String
            //print("Yardage: " + "\(currentYardage)")
            self.HoleYardage.text = currentYardage
        })
    }
    
    func updateScore(){
        holeScores[currentHole] = currentScore + putts
        print(holeScores)
        //print("Non-Putts: " + "\(currentScore)")
        currentHole += 1
        //print("Current Hole: " + "\(currentHole)")
        putts = 0
        currentScore = 0
        updateShotText()
        updateUI()
    }
    
    
}
