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
    
    var courseName = ""
    var tees = ""
    
    var ref = Database.database().reference()
    
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
        
        let yardageRef = ref.child("Golf Course Data").child(courseName).child("Tees").child(tees).child("Holes")
        let parRef = ref.child("Golf Course Data").child(courseName).child("Tees").child(tees).child("Pars")
        
        for i in 1 ..< 19 {
            yardageRef.observeSingleEvent(of: .value, with: {DataSnapshot in
                // Return if no data exists
                if !DataSnapshot.exists() { return }
                let currentYardage = DataSnapshot.childSnapshot(forPath: "\(i)").value as! String
                self.yardagesOfCourse.append(currentYardage)
                self.HoleYardage.text = currentYardage
            })
        }
        
        for j in 1 ..< 19 {
            parRef.observeSingleEvent(of: .value, with: {DataSnapshot in
                // Return if no data exists
                if !DataSnapshot.exists() { return }
                let currentPar = DataSnapshot.childSnapshot(forPath: "\(j)").value as! String
                self.HolePar.text = currentPar
                self.parsOfCourse.append(currentPar)
            })
        }
        
        // Navigation Bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "View Scorecard", style: .plain, target: self, action: #selector(displayScorecard))
        
        self.navigationItem.leftBarButtonItem?.action = #selector(checkIfUserWantsToCancelRound)
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
            print("Fairway?: \(self.holeStatistics.fairways)")
            print("Greens in Reg?: \(self.holeStatistics.greensInReg)")
            print("Green Bunkers?: \(self.holeStatistics.greenBunkers)")
            print("Fairway Bunkers?: \(self.holeStatistics.fairwayBunkers)")
            self.holeStatData.append(self.holeStatistics)
            self.resetHoleStats()
            self.testPrint()
        }))

        self.present(popUp, animated: true, completion: nil)
    }
    
    func checkIfUserWantsToCancelRound() {
        let popUp = UIAlertController(title: "Are you sure you want to go back? Going back will delete your data for this current round.", message: nil, preferredStyle: .alert)
        
        popUp.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [popUp] (_) in
            let uid = Auth.auth().currentUser?.uid
            let userRef = self.ref.child("Users").child(uid!)
            let scoreRef = userRef.child("Courses").child(self.courseName).child("Tees").child(self.tees).child("Scores")
            scoreRef.removeValue()
        }))
        
        popUp.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [popUp] (_) in
            popUp.dismiss(animated: true, completion: nil)
        }))
        
        self.present(popUp, animated: true, completion: nil)
    }
    
    func displayScorecard() {
        self.performSegue(withIdentifier: "scorecardSegue", sender: self)
    }
    
    // Buttons
    @IBAction func Green(_ sender: Any) {
        holeStatistics.greensInReg = true
        currentScore += 1
        PuttPopUp()
        uploadToDatabase()
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
        print(yardagesOfCourse)
        print(parsOfCourse)
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
        putts = 0
        currentScore = 0
        updateShotText()
        updateUI()
    }
    
    func resetHoleStats(){
        holeStatistics.greenBunkers = 0
        holeStatistics.fairwayBunkers = 0
        holeStatistics.hazards = 0
        holeStatistics.obs = 0
        holeStatistics.rights = false
        holeStatistics.lefts = false
        holeStatistics.fringes = 0
        holeStatistics.fairways = false
        holeStatistics.greensInReg = false
    }
    
    func testPrint(){
        print("Fairway?: \(self.holeStatistics.fairways)")
        print("Greens in Reg?: \(self.holeStatistics.greensInReg)")
        print("Green Bunkers?: \(self.holeStatistics.greenBunkers)")
        print("Fairway Bunkers?: \(self.holeStatistics.fairwayBunkers)")
    }
    
    func uploadToDatabase() {
        if Auth.auth().currentUser != nil {
            let uid = Auth.auth().currentUser?.uid
            let userRef = ref.child("Users").child(uid!)
            userRef.child("Courses").child(courseName).child("Tees").child(tees).child("Scores").child(HoleNumber.text!).setValue(currentScore)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scorecardSegue" {
            let scrollView = segue.destination as! ScorecardScroll
            let scorecard1 = Scorecard()
            let scorecard2 = Scorecard2()
            
            scorecard1.CourseName.text = self.courseName
            scorecard2.CourseName.text = self.courseName
            scorecard1.tees = self.tees
            scorecard2.tees = self.tees
            
            scorecard1.restorationIdentifier = "FrontNine"
            scorecard2.restorationIdentifier = "BackNine"
        }
    }
    
}
