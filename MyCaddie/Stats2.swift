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
    
    var courseName = ""
    var tees = ""
    
    var ref = Database.database().reference()
    
    
    // Stores Round Data
    var holeStatData = [HoleStats]()
    // Initial Object
    var holeStatistics = HoleStats()
    
    var shotCount = String()
    var counter = 0
    
    var holeScores = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
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
    
    func puttPopUp() {
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
            //self.testPrint()
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
        if currentScore < (Int(parsOfCourse[currentHole])! - 2){
            holeStatistics.greensInReg = true
        }
        currentScore += 1
        updateUI()
        puttPopUp()
        uploadToDatabase()
        if currentHole == 2 {
            endRound()
        }
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
        holeStatistics.score = currentScore + putts
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
    
    /*
    func testPrint(){
        print("Fairway?: \(self.holeStatistics.fairways)")
        print("Greens in Reg?: \(self.holeStatistics.greensInReg)")
        print("Green Bunkers?: \(self.holeStatistics.greenBunkers)")
        print("Fairway Bunkers?: \(self.holeStatistics.fairwayBunkers)")
    }
 */
    

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
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            scrollView.scorecard1 = storyboard.instantiateViewController(withIdentifier: "FrontNine") as! Scorecard
            scrollView.scorecard2 = storyboard.instantiateViewController(withIdentifier: "BackNine") as! Scorecard2
            scrollView.scorecard1.parentCourseName = self.courseName
            scrollView.scorecard2.parentCourseName = self.courseName
            scrollView.scorecard1.tees = self.tees
            scrollView.scorecard2.tees = self.tees
            
        }
    }
  
    func updateHoleData(){
        holeStatData.append(holeStatistics)
        currentCourseUpload(counter: counter)
        counter += 1
        
         /*
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
        */
    }
    
    func currentCourseUpload(counter: Int){
        
        // Par Branch Reference
        let uid = Auth.auth().currentUser?.uid
        let userReference = Database.database().reference().child("Users").child(uid!)
        userReference.child("Current Round").child("Course Name").setValue(courseName)
        userReference.child("Current Round").child("Tees").setValue(tees)
        userReference.child("Current Round").child("\(currentHole)").child("GreenSide Bunkers").setValue(holeStatData[counter].greenBunkers)
        userReference.child("Current Round").child("\(currentHole)").child("Fairway Bunkers").setValue(holeStatData[counter].fairwayBunkers)
        userReference.child("Current Round").child("\(currentHole)").child("Hazards").setValue(holeStatData[counter].hazards)
        userReference.child("Current Round").child("\(currentHole)").child("OBs").setValue(holeStatData[counter].obs)
        userReference.child("Current Round").child("\(currentHole)").child("Rights").setValue(holeStatData[counter].rights)
        userReference.child("Current Round").child("\(currentHole)").child("Lefts").setValue(holeStatData[counter].lefts)
        userReference.child("Current Round").child("\(currentHole)").child("Fringes").setValue(holeStatData[counter].fringes)
        userReference.child("Current Round").child("\(currentHole)").child("Fairways").setValue(holeStatData[counter].fairways)
        userReference.child("Current Round").child("\(currentHole)").child("Greens").setValue(holeStatData[counter].greensInReg)
        userReference.child("Current Round").child("\(currentHole)").child("Putts").setValue(holeStatData[counter].putt)
        userReference.child("Current Round").child("\(currentHole)").child("Score").setValue(holeStatData[counter].score)
        
    }
    
    func endRound(){
        // Variables
        var totalFairwayBunkers = 0
        var totalGreenBunkers = 0
        var totalHazards = 0
        var totalOBs = 0
        var rights = false
        var lefts = false
        var fringes = 0
        var fairways = false
        var greensInReg = false
        var putt = 0
        var score = 0
        
        let uid = Auth.auth().currentUser?.uid
        
//        for i in 1 ..< 4 {
//            //let holeRef = self.ref.child("Users").child(uid!).child("Current Round").child("\(i)")
//            let holeRef = self.ref.child("Users").child(uid!).child("Current Round")
//            holeRef.observeSingleEvent(of: .value, with: {DataSnapshot in
//                let fb = DataSnapshot.childSnapshot(forPath: "Fairway Bunkers").value as! NSNumber
//                print(fb)
//                totalFairwayBunkers += Int(fb)
//                print(totalFairwayBunkers)
//                let gb = DataSnapshot.childSnapshot(forPath: "GreenSide Bunkers").value as! NSNumber
//                totalGreenBunkers += Int(gb)
//                let hz = DataSnapshot.childSnapshot(forPath: "Hazards").value as! NSNumber
//                totalHazards += Int(hz)
//                let ob = DataSnapshot.childSnapshot(forPath: "OBs").value as! NSNumber
//                totalOBs += Int(ob)
//            })
//            print("Iteration")
//            print(totalFairwayBunkers)
//        }
//        print("WHY THO")
//        print(totalFairwayBunkers)
        
        let holeRef = self.ref.child("Users").child(uid!).child("Current Round")
//        holeRef.observe(of: .childAdded, with: { (snapshot) in
        holeRef.observe(.childAdded, with: { (snapshot) in
            
            for child in snapshot.children {
                let fbCount = child as! DataSnapshot
                if fbCount.key == "Fairway Bunkers" {
                    totalFairwayBunkers += fbCount.value as! Int
                }
            }
            print(totalFairwayBunkers)
            let courseReference = Database.database().reference().child("Golf Course Data").child(self.courseName)
            courseReference.child("Round 1").child("Fairwayyyy Bunkers").setValue(totalFairwayBunkers)
        })
        
    }
}
