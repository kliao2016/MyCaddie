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
    
    var programVar : Program?
    
    
    var courseName = ""
    var tees = ""
    var currentRound = 0
    
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
        
        //let courseName2 = programVar?.cName
        //var tees2 = programVar?.tName as! String
        
        // If continuing previous round
        if (programVar?.cName != nil) {
            courseName = (programVar?.cName)!
            tees = (programVar?.tName)!
            currentHole = (programVar?.currentHoleNumber)!
            HoleNumber.text = "\(currentHole+1)"
            
            getHoleScores()
        }
        
        let yardageRef = ref.child("Golf Course Data").child(courseName).child("Tees").child(tees).child("Holes")
        let parRef = ref.child("Golf Course Data").child(courseName).child("Tees").child(tees).child("Pars")
        
        for i in 1 ..< 19 {
            yardageRef.observeSingleEvent(of: .value, with: {DataSnapshot in
                // Return if no data exists
                if !DataSnapshot.exists() { return }
                let currentYardage = DataSnapshot.childSnapshot(forPath: "\(i)").value as! String
                self.yardagesOfCourse.append(currentYardage)
                //self.HoleYardage.text = currentYardage
                //print("Oh Yeah")
                if (self.yardagesOfCourse.count > self.currentHole){
                    self.HoleYardage.text = self.yardagesOfCourse[self.currentHole]
                }
            })
        }
        
        for j in 1 ..< 19 {
            parRef.observeSingleEvent(of: .value, with: {DataSnapshot in
                // Return if no data exists
                if !DataSnapshot.exists() { return }
                let currentPar = DataSnapshot.childSnapshot(forPath: "\(j)").value as! String
                self.parsOfCourse.append(currentPar)
                //self.HolePar.text = currentPar
                //print("No, God, No")
                if (self.parsOfCourse.count > self.currentHole){
                    self.HolePar.text = self.parsOfCourse[self.currentHole]
                }
            })
        }
        
        if (yardagesOfCourse.count != 0){
            HoleYardage.text = yardagesOfCourse[currentHole]
            HolePar.text = parsOfCourse[currentHole]
        }
        
        
        // Navigation Bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "View Scorecard", style: .plain, target: self, action: #selector(displayScorecard))
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            checkIfUserWantsToCancelRound()
        }
    }
    
    
    func puttPopUp() {
        
        let popUp = UIAlertController(title: "How many putts did you have?", message: nil, preferredStyle: .alert)
        popUp.addTextField { (textField) in
            textField.keyboardType = UIKeyboardType.numberPad
            textField.text = nil
        }

        
        popUp.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [popUp] (_) in
            
//            if popUp.textFields?[0] == nil {
//                print ("Yes")
//                self.puttPopUp()
//            }
            
            //let textField = popUp.textFields![0] // Force unwrapping because we know it exists.
            
            let textField = popUp.textFields?[0]
            let actualText = Int((textField?.text)!)
            
            if (actualText != nil){
                self.putts = Int((textField?.text!)!)!
                self.updateScore()
                self.holeStatistics.putt = self.putts
                self.updateHoleData()
                self.resetHoleStats()
                if self.currentHole >= 2 {
                    self.endRound()
                    self.deleteCurrentRound()
                }
            }
            else {
                self.puttPopUp()
            }
            
            
        }))

        self.present(popUp, animated: true, completion: nil)
    }
    
    func showMainView() {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "TabController")
        
        self.present(mainView!, animated: true, completion: nil)
    }
    
    func checkIfUserWantsToCancelRound() {
        let popUp = UIAlertController(title: "Are you sure you want to go back? Going back will delete your data for this current round.", message: nil, preferredStyle: .alert)
        
        popUp.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [popUp] (_) in
            self.deleteCurrentRound()
            
            let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.showMainView()
            }
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
            holeStatistics.greensInReg = 1
        }
        currentScore += 1
        updateUI()
        puttPopUp()
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
            holeStatistics.fairways = 1
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
        currentScore += 2
        updateShotText()
        updateUI()
    }
    @IBAction func Right(_ sender: Any) {
        holeStatistics.rights = 1
        currentScore += 1
        updateShotText()
        updateUI()
    }
    @IBAction func Left(_ sender: Any) {
        holeStatistics.lefts = 1
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
        if currentHole < 18 {
            self.HoleNumber.text = "\(currentHole + 1)"
            self.HolePar.text = parsOfCourse[currentHole]
            self.HoleYardage.text = yardagesOfCourse[currentHole]
        } else if currentHole == 18 {
            return
        }
    }
    
    func updateScore(){
        if currentHole < 18 {
            holeScores[currentHole] = currentScore + putts
            holeStatistics.score = currentScore + putts
            //print(holeScores)
            currentHole += 1
        }
        currentScore = 0
        updateShotText()
        updateUI()
    }
    
    func resetHoleStats(){
        holeStatistics = HoleStats()
        putts = 0
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
    }
    
    func currentCourseUpload(counter: Int){
        
        // Par Branch Reference
        let uid = Auth.auth().currentUser?.uid
        let userReference = Database.database().reference().child("Users").child(uid!)
        userReference.child("Current Round").child("Course Name").setValue(courseName)
        userReference.child("Current Round").child("Tees").setValue(tees)
        userReference.child("Current Round").child("Current Hole").setValue(currentHole)
        userReference.child("Current Round").child("\(currentHole)").child("Greenside Bunkers").setValue(holeStatData[counter].greenBunkers)
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
    
    func deleteCurrentRound() {
        if Auth.auth().currentUser != nil {
            let uid = Auth.auth().currentUser?.uid
            let userReference = self.ref.child("Users").child(uid!)
            userReference.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild("Current Round") {
                    userReference.child("Current Round").removeValue()
                }
            })
        }
    }
    
    func endRound(){
        
        // Variables
        var totalFairwayBunkers = 0
        var totalGreenBunkers = 0
        var totalHazards = 0
        var totalOBs = 0
        var totalRights = 0
        var totalLefts = 0
        var totalFringes = 0
        var totalFairways = 0
        var totalGreensInReg = 0
        var totalPutts = 0
        var totalScore = 0
        
        let uid = Auth.auth().currentUser?.uid
        
        getCount()
        
        let holeRef = self.ref.child("Users").child(uid!).child("Current Round")
        holeRef.observe(.childAdded, with: { (snapshot) in
            
            for child in snapshot.children {
                let fbCount = child as! DataSnapshot
                if fbCount.key == "Fairway Bunkers" {
                    totalFairwayBunkers += fbCount.value as! Int
                }
                if fbCount.key == "Greenside Bunkers" {
                    totalGreenBunkers += fbCount.value as! Int
                }
                if fbCount.key == "Hazards" {
                    totalHazards += fbCount.value as! Int
                }
                if fbCount.key == "OBs" {
                    totalOBs += fbCount.value as! Int
                }
                if fbCount.key == "Putts" {
                    totalPutts += fbCount.value as! Int
                }
                if fbCount.key == "Score" {
                    totalScore += fbCount.value as! Int
                }
                if fbCount.key == "Fringes" {
                    totalFringes += fbCount.value as! Int
                }
                if fbCount.key == "Fairways" {
                    totalFairways += fbCount.value as! Int
                }
                if fbCount.key == "Greens" {
                    totalGreensInReg += fbCount.value as! Int
                }
                if fbCount.key == "Rights" {
                    totalRights += fbCount.value as! Int
                }
                if fbCount.key == "Lefts" {
                    totalLefts += fbCount.value as! Int
                }
                
            }
            
            let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                let courseReference = Database.database().reference().child("Users").child(uid!).child("Courses").child(self.courseName)
                courseReference.child("Round \(self.currentRound)").child("Fairway Bunkers").setValue(totalFairwayBunkers)
                courseReference.child("Round \(self.currentRound)").child("Greenside Bunkers").setValue(totalGreenBunkers)
                courseReference.child("Round \(self.currentRound)").child("Hazards").setValue(totalHazards)
                courseReference.child("Round \(self.currentRound)").child("OBs").setValue(totalOBs)
                courseReference.child("Round \(self.currentRound)").child("Putts").setValue(totalPutts)
                courseReference.child("Round \(self.currentRound)").child("Score").setValue(totalScore)
                courseReference.child("Round \(self.currentRound)").child("Fringes").setValue(totalFringes)
                courseReference.child("Round \(self.currentRound)").child("Fairways").setValue(totalFairways)
                courseReference.child("Round \(self.currentRound)").child("Greens").setValue(totalGreensInReg)
                courseReference.child("Round \(self.currentRound)").child("Rights").setValue(totalRights)
                courseReference.child("Round \(self.currentRound)").child("Lefts").setValue(totalLefts)
            }
        })
        
        // Score Data Structure
        let scoreData : [String: AnyObject] = ["1": holeScores[0] as AnyObject, "2": holeScores[1] as AnyObject, "3": holeScores[2] as AnyObject, "4": holeScores[3] as AnyObject,"5": holeScores[4] as AnyObject, "6": holeScores[5] as AnyObject, "7": holeScores[6] as AnyObject, "8": holeScores[7] as AnyObject,"9": holeScores[8] as AnyObject, "10": holeScores[9] as AnyObject, "11": holeScores[10] as AnyObject, "12": holeScores[11] as AnyObject,"13": holeScores[12] as AnyObject, "14": holeScores[13] as AnyObject, "15": holeScores[14] as AnyObject, "16": holeScores[15] as AnyObject, "17": holeScores[16] as AnyObject, "18": holeScores[17] as AnyObject]
        
        // Score Upload
        let courseReference = Database.database().reference().child("Users").child(uid!).child("Courses").child(self.courseName)
        let when = DispatchTime.now() + 1 // change to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            courseReference.child("Round \(self.currentRound)").child("Scores").setValue(scoreData)
        }
    }
    
    func getCount(){
        var count = 1
        let uid = Auth.auth().currentUser?.uid
        let courseReference = self.ref.child("Users").child(uid!).child("Courses").child(self.courseName)
        
        courseReference.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            //print(DataSnapshot.childrenCount)
            
            count = Int(DataSnapshot.childrenCount)+1
            self.currentRound = count
            print(self.currentRound)
            
        })
    }
    
    func getHoleScores() {
        
        var dynamicScore = 0
        var count = 0
        
        let uid = Auth.auth().currentUser?.uid
        let userRoundRef = ref.child("Users").child(uid!).child("Current Round")
        userRoundRef.observe(.childAdded, with: { (snapshot) in
            for child in snapshot.children {
                let tag = child as! DataSnapshot
                if tag.key == "Score" {
                    dynamicScore = tag.value as! Int
                    self.holeScores[count] = dynamicScore
                    count += 1
                }
            }
        })
    }
    
}
