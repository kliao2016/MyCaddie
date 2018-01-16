//
//  Scorecard2.swift
//  MyCaddie
//
//  Created by Weston Mauz on 6/6/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import UIKit

class Scorecard2: UIViewController {
    
    var parentCourseName = ""
    var tees = ""
    
    // Overall Database Reference
    var ref = Database.database().reference()
    var databaseHandle: DatabaseHandle?
    
    // Yardage and Par Arrays
    var yardageData = [String]()
    var parData = [String]()
    
    // Label References
    
    // Titles
    @IBOutlet weak var CourseName: UILabel!
    @IBOutlet weak var Slope: UILabel!
    @IBOutlet weak var Rating: UILabel!
    @IBOutlet weak var Back9Score: UILabel!
    
    // Pars
    @IBOutlet weak var Par10: UILabel!
    @IBOutlet weak var Par11: UILabel!
    @IBOutlet weak var Par12: UILabel!
    @IBOutlet weak var Par13: UILabel!
    @IBOutlet weak var Par14: UILabel!
    @IBOutlet weak var Par15: UILabel!
    @IBOutlet weak var Par16: UILabel!
    @IBOutlet weak var Par17: UILabel!
    @IBOutlet weak var Par18: UILabel!
    
    // Yardages
    @IBOutlet weak var Yardage10: UILabel!
    @IBOutlet weak var Yardage11: UILabel!
    @IBOutlet weak var Yardage12: UILabel!
    @IBOutlet weak var Yardage13: UILabel!
    @IBOutlet weak var Yardage14: UILabel!
    @IBOutlet weak var Yardage15: UILabel!
    @IBOutlet weak var Yardage16: UILabel!
    @IBOutlet weak var Yardage17: UILabel!
    @IBOutlet weak var Yardage18: UILabel!
    
    // Scores
    @IBOutlet weak var Score10: UILabel!
    @IBOutlet weak var Score11: UILabel!
    @IBOutlet weak var Score12: UILabel!
    @IBOutlet weak var Score13: UILabel!
    @IBOutlet weak var Score14: UILabel!
    @IBOutlet weak var Score15: UILabel!
    @IBOutlet weak var Score16: UILabel!
    @IBOutlet weak var Score17: UILabel!
    @IBOutlet weak var Score18: UILabel!
    
    // Totals
    @IBOutlet weak var Back9Pars: UILabel!
    @IBOutlet weak var Back9Yards: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Total Variables
        var totalYards = 0
        var totalPars = 0
        
        // Limit "course name" text to 25 characters
        
        if self.parentCourseName.characters.count > 22 {
            let index = self.parentCourseName.index(parentCourseName.startIndex, offsetBy: 22)
            var mySubstring = String(self.parentCourseName[..<index])
            mySubstring = mySubstring + "..."
            self.CourseName?.text = mySubstring
        }
        else {
            self.CourseName?.text = self.parentCourseName
        }
        
        // Set Firebase Database
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let userRef = ref.child("Users").child(uid!)
        
        // Par Branch Reference
        let parRef = ref.child("Golf Course Data").child(parentCourseName).child("Tees").child(tees).child("Pars")
        // Yardage Branch Reference
        let yardageRef = ref.child("Golf Course Data").child(parentCourseName).child("Tees").child(tees).child("Holes")
        let scoreRef = userRef.child("Current Round")
        
        // Slope and Rating Reference and Output
        let slopeRef = ref.child("Golf Course Data").child(parentCourseName).child("Tees").child(tees)
        
        slopeRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            if !DataSnapshot.exists() { return }
            
            let slopeHold = DataSnapshot.childSnapshot(forPath: "Slope").value as! String
            let ratingHold = DataSnapshot.childSnapshot(forPath: "Rating").value as! String
            self.Slope.text = "Slo: \(slopeHold)"
            self.Rating.text = "Rat: \(ratingHold)"
        })
        
        // Course Name Reference
        //let SlopeRef = Database.database().reference().child("Golf Course Data") Get the input here for course name
        
        // Player Name Reference
        
        // Reading Par Data from Course
        parRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            
            //
            let p1 = DataSnapshot.childSnapshot(forPath: "10").value as! String
            let p2 = DataSnapshot.childSnapshot(forPath: "11").value as! String
            let p3 = DataSnapshot.childSnapshot(forPath: "12").value as! String
            let p4 = DataSnapshot.childSnapshot(forPath: "13").value as! String
            let p5 = DataSnapshot.childSnapshot(forPath: "14").value as! String
            let p6 = DataSnapshot.childSnapshot(forPath: "15").value as! String
            let p7 = DataSnapshot.childSnapshot(forPath: "16").value as! String
            let p8 = DataSnapshot.childSnapshot(forPath: "17").value as! String
            let p9 = DataSnapshot.childSnapshot(forPath: "18").value as! String
            self.parData.append(p1)
            self.parData.append(p2)
            self.parData.append(p3)
            self.parData.append(p4)
            self.parData.append(p5)
            self.parData.append(p6)
            self.parData.append(p7)
            self.parData.append(p8)
            self.parData.append(p9)
            //print(self.parData)
            self.Par10.text = self.parData[0]
            self.Par11.text = self.parData[1]
            self.Par12.text = self.parData[2]
            self.Par13.text = self.parData[3]
            self.Par14.text = self.parData[4]
            self.Par15.text = self.parData[5]
            self.Par16.text = self.parData[6]
            self.Par17.text = self.parData[7]
            self.Par18.text = self.parData[8]
            
            // Total Par
            //print(self.parData)
            for i in 0 ..< 9 {
                totalPars += Int(self.parData[i])!
            }
            //print(totalYards)
            self.Back9Pars.text = "\(totalPars)"
            
        })
        
        // Reading Yardage Data from Course
        yardageRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            
            //
            let y1 = DataSnapshot.childSnapshot(forPath: "10").value as! String
            let y2 = DataSnapshot.childSnapshot(forPath: "11").value as! String
            let y3 = DataSnapshot.childSnapshot(forPath: "12").value as! String
            let y4 = DataSnapshot.childSnapshot(forPath: "13").value as! String
            let y5 = DataSnapshot.childSnapshot(forPath: "14").value as! String
            let y6 = DataSnapshot.childSnapshot(forPath: "15").value as! String
            let y7 = DataSnapshot.childSnapshot(forPath: "16").value as! String
            let y8 = DataSnapshot.childSnapshot(forPath: "17").value as! String
            let y9 = DataSnapshot.childSnapshot(forPath: "18").value as! String
            self.yardageData.append(y1)
            self.yardageData.append(y2)
            self.yardageData.append(y3)
            self.yardageData.append(y4)
            self.yardageData.append(y5)
            self.yardageData.append(y6)
            self.yardageData.append(y7)
            self.yardageData.append(y8)
            self.yardageData.append(y9)
            //print(self.yardageData)
            self.Yardage10.text = self.yardageData[0]
            self.Yardage11.text = self.yardageData[1]
            self.Yardage12.text = self.yardageData[2]
            self.Yardage13.text = self.yardageData[3]
            self.Yardage14.text = self.yardageData[4]
            self.Yardage15.text = self.yardageData[5]
            self.Yardage16.text = self.yardageData[6]
            self.Yardage17.text = self.yardageData[7]
            self.Yardage18.text = self.yardageData[8]
            
            // Total Yardage
            //print(self.yardageData)
            for i in 0 ..< 9 {
                totalYards += Int(self.yardageData[i])!
            }
            self.Back9Yards.text = "\(totalYards)"
        })
        
        scoreRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            
            //
            if DataSnapshot.hasChild("10") {
                if let s10 = DataSnapshot.childSnapshot(forPath: "10/Score").value as? NSNumber {
                    self.Score10.text = "\(s10)"
                }
            } else {
                self.Score10.text = " "
            }
            
            if DataSnapshot.hasChild("11") {
                if let s11 = DataSnapshot.childSnapshot(forPath: "11/Score").value as? NSNumber {
                    self.Score11.text = "\(s11)"
                }
            } else {
                self.Score11.text = " "
            }
            
            if DataSnapshot.hasChild("12") {
                if let s12 = DataSnapshot.childSnapshot(forPath: "12/Score").value as? NSNumber {
                    self.Score12.text = "\(s12)"
                }
            } else {
                self.Score12.text = " "
            }
            
            if DataSnapshot.hasChild("13") {
                if let s13 = DataSnapshot.childSnapshot(forPath: "13/Score").value as? NSNumber {
                    self.Score13.text = "\(s13)"
                }
            } else {
                self.Score13.text = " "
            }
            
            if DataSnapshot.hasChild("14") {
                if let s14 = DataSnapshot.childSnapshot(forPath: "14/Score").value as? NSNumber {
                    self.Score14.text = "\(s14)"
                }
            } else {
                self.Score14.text = " "
            }
            
            if DataSnapshot.hasChild("15") {
                if let s15 = DataSnapshot.childSnapshot(forPath: "15/Score").value as? NSNumber {
                    self.Score15.text = "\(s15)"
                }
            } else {
                self.Score15.text = " "
            }
            
            if DataSnapshot.hasChild("16") {
                if let s16 = DataSnapshot.childSnapshot(forPath: "16/Score").value as? NSNumber {
                    self.Score16.text = "\(s16)"
                }
            } else {
                self.Score16.text = " "
            }
            
            if DataSnapshot.hasChild("17") {
                if let s17 = DataSnapshot.childSnapshot(forPath: "17/Score").value as? NSNumber {
                    self.Score17.text = "\(s17)"
                }
            } else {
                self.Score17.text = " "
            }
            
            if DataSnapshot.hasChild("18") {
                if let s18 = DataSnapshot.childSnapshot(forPath: "18/Score").value as? NSNumber {
                    self.Score18.text = "\(s18)"
                }
            } else {
                self.Score18.text = " "
            }
        })
        
        // Dynamic Score
        var dynamicScore = 0
        
        //          Dynamic Score Allocation
        let userRoundRef = ref.child("Users").child(uid!).child("Current Round")
        userRoundRef.observe(.childAdded, with: { (snapshot) in
            for child in snapshot.children {
                let tag = child as! DataSnapshot
                if tag.key == "Score" {
                    dynamicScore += tag.value as! Int
                }
            }
            //print(dynamicScore)
            self.Back9Score.text = "\(dynamicScore)"
        })
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismissScorecard(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Constrain view to be only portrait
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
}

