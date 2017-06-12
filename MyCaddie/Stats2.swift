//
//  Stats2.swift
//  MyCaddie
//
//  Created by Weston Mauz on 6/6/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase
import GoogleSignIn

class Stats2: UIViewController {
    
    var ref = Database.database().reference()
    var databaseHandle: DatabaseHandle?
    
    
    // Stores Round Data
    var holeStatData = [HoleStats]()
    // Initial Object
    var holeStatistics = HoleStats()
    
    var shotCount = String()
    
    var holeScores = [4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4]
    var parsOfCourse = [String]()
    var yardagesOfCourse = [String]()
    
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
    
    // Variables
    var putts = Int ()
    var currentHole = Int()
    var currentScore = Int()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initial text
        ShotNumberText.text = "Where was your first shot?"
        Actual.text = "Shots hit: 0"
        HoleNumber.text = "1"
        
        let YardageRef = Database.database().reference().child("Golf Course Data").child("www").child("Tees").child("Championship").child("Holes")
        let ParRef = Database.database().reference().child("Golf Course Data").child("www").child("Tees").child("Championship").child("Pars")
        
        for i in 1 ..< 19 {
            YardageRef.observeSingleEvent(of: .value, with: {DataSnapshot in
                // Return if no data exists
                if !DataSnapshot.exists() { return }
                let currentYardage = DataSnapshot.childSnapshot(forPath: "\(i)").value as! String
                self.yardagesOfCourse.append(currentYardage)
                self.HoleYardage.text = currentYardage
            })
        }
        for j in 1 ..< 19 {
            ParRef.observeSingleEvent(of: .value, with: {DataSnapshot in
                // Return if no data exists
                if !DataSnapshot.exists() { return }
                let currentPar = DataSnapshot.childSnapshot(forPath: "\(j)").value as! String
                self.HolePar.text = currentPar
                self.parsOfCourse.append(currentPar)
            })
        }
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
            //print("Fairway?: \(self.holeStatistics.fairways)")
            //print("Greens in Reg?: \(self.holeStatistics.greensInReg)")
            //print("Green Bunkers?: \(self.holeStatistics.greenBunkers)")
            //print("Fairway Bunkers?: \(self.holeStatistics.fairwayBunkers)")
            self.holeStatistics.putt = self.putts
            self.updateHoleData()
            self.resetHoleStats()
            self.testPrint()
        }))

        self.present(popUp, animated: true, completion: nil)
    }
    
    // Buttons
    @IBAction func Green(_ sender: Any) {
        holeStatistics.greensInReg = true
        currentScore += 1
        updateUI()
        PuttPopUp()
    }
    @IBAction func Fringe(_ sender: Any) {
        holeStatistics.fringes += 1
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func GreenSand(_ sender: Any) {
        holeStatistics.greenBunkers += 1
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func FairwaySand(_ sender: Any) {
        holeStatistics.fairwayBunkers += 1
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func Fairway(_ sender: Any) {
        if currentScore == 0 {
            holeStatistics.fairways = true
        }
        //print(yardagesOfCourse)
        //print(parsOfCourse)
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func Hazard(_ sender: Any) {
        holeStatistics.hazards += 1
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func OB(_ sender: Any) {
        holeStatistics.obs += 1
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func Right(_ sender: Any) {
        holeStatistics.rights = true
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func Left(_ sender: Any) {
        holeStatistics.lefts = true
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
        self.HolePar.text = parsOfCourse[currentHole]
        self.HoleYardage.text = yardagesOfCourse[currentHole]
    }
    
    func updateScore(){
        holeScores[currentHole] = currentScore + putts
        print(holeScores)
        currentHole += 1
        currentScore = 0
        updateShotText()
        updateUI()
    }
    
    func resetHoleStats(){
        holeStatistics = HoleStats()
        putts = 0
    }
    
    func testPrint(){
        print("Fairway?: \(self.holeStatistics.fairways)")
        print("Greens in Reg?: \(self.holeStatistics.greensInReg)")
        print("Green Bunkers?: \(self.holeStatistics.greenBunkers)")
        print("Fairway Bunkers?: \(self.holeStatistics.fairwayBunkers)")
    }
    
    func updateHoleData(){
        holeStatData.append(holeStatistics)
        currentCourseUpload()
        
         
        for i in 0 ..< holeStatData.count {
            print("Greenside Bunkers \(i) : \(holeStatData[i].greenBunkers)")
        }
        for i in 0 ..< holeStatData.count {
            print("Fairway Bunkers \(i) : \(holeStatData[i].fairwayBunkers)")
        }
        for i in 0 ..< holeStatData.count {
            print("Hazards \(i) : \(holeStatData[i].hazards)")
        }
        for i in 0 ..< holeStatData.count {
            print("OBS \(i) : \(holeStatData[i].obs)")
        }
        for i in 0 ..< holeStatData.count {
            print("R \(i) : \(holeStatData[i].rights)")
        }
        for i in 0 ..< holeStatData.count {
            print("L \(i) : \(holeStatData[i].lefts)")
        }
        for i in 0 ..< holeStatData.count {
            print("Fringes \(i) : \(holeStatData[i].fringes)")
        }
        for i in 0 ..< holeStatData.count {
            print("Fairways \(i) : \(holeStatData[i].fairways)")
        }
        for i in 0 ..< holeStatData.count {
            print("GIR \(i) : \(holeStatData[i].greensInReg)")
        }
        for i in 0 ..< holeStatData.count {
            print("Putts \(i) : \(holeStatData[i].putt)")
        }
    }
    
    func currentCourseUpload(){
        
        // Par Branch Reference
        let uid = Auth.auth().currentUser?.uid
        let userReference = Database.database().reference().child("Users").child(uid!)
        //let greenBunkerData = [String: AnyObject] =
        userReference.child("GreensideBunkers").setValue(holeStatData[0].greenBunkers)
        //userReference.child("CurrentRound").setValue
        /*
         let parData : [String: AnyObject] = ["1": pars[0] as AnyObject, "2": pars[1] as AnyObject, "3": pars[2] as AnyObject, "4": pars[3] as AnyObject,"5": pars[4] as AnyObject, "6": pars[5] as AnyObject, "7": pars[6] as AnyObject, "8": pars[7] as AnyObject,"9": pars[8] as AnyObject, "10": pars[9] as AnyObject, "11": pars[10] as AnyObject, "12": pars[11] as AnyObject,"13": pars[12] as AnyObject, "14": pars[13] as AnyObject, "15": pars[14] as AnyObject, "16": pars[15] as AnyObject, "17": pars[16] as AnyObject, "18": pars[17] as AnyObject]
         
         // Par Upload
         userReference.child("Courses").child(courseName.text!).child("Tees").child(dropTextBox.text!).child("Pars").setValue(parData)
         */
    }
    
    
    
}
