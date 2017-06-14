//
//  Scorecard.swift
//  MyCaddie
//
//  Created by Weston Mauz on 6/2/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import UIKit

class Scorecard: UIViewController {
    
    var parentCourseName = ""
    var tees = ""
    
    // Overall Database Reference
    var ref = Database.database().reference()
    
    // Yardage and Par Arrays
    var yardageData = [String]()
    var parData = [String]()
    
    // Label References
    
    // Titles
    @IBOutlet weak var outScore: UILabel!
    @IBOutlet weak var totalPar: UILabel!
    @IBOutlet weak var totalYardage: UILabel!
    @IBOutlet weak var CourseName: UILabel!
    @IBOutlet weak var Slope: UILabel!
    @IBOutlet weak var Rating: UILabel!
    
    // Pars
    @IBOutlet weak var Par1: UILabel!
    @IBOutlet weak var Par2: UILabel!
    @IBOutlet weak var Par3: UILabel!
    @IBOutlet weak var Par4: UILabel!
    @IBOutlet weak var Par5: UILabel!
    @IBOutlet weak var Par6: UILabel!
    @IBOutlet weak var Par7: UILabel!
    @IBOutlet weak var Par8: UILabel!
    @IBOutlet weak var Par9: UILabel!
    
    // Yardages
    @IBOutlet weak var Yardage1: UILabel!
    @IBOutlet weak var Yardage2: UILabel!
    @IBOutlet weak var Yardage3: UILabel!
    @IBOutlet weak var Yardage4: UILabel!
    @IBOutlet weak var Yardage5: UILabel!
    @IBOutlet weak var Yardage6: UILabel!
    @IBOutlet weak var Yardage7: UILabel!
    @IBOutlet weak var Yardage8: UILabel!
    @IBOutlet weak var Yardage9: UILabel!
    
    // User Scores
    @IBOutlet weak var Score1: UILabel!
    @IBOutlet weak var Score2: UILabel!
    @IBOutlet weak var Score3: UILabel!
    @IBOutlet weak var Score4: UILabel!
    @IBOutlet weak var Score5: UILabel!
    @IBOutlet weak var Score6: UILabel!
    @IBOutlet weak var Score7: UILabel!
    @IBOutlet weak var Score8: UILabel!
    @IBOutlet weak var Score9: UILabel!
    
    // Totals
    @IBOutlet weak var Front9Yards: UILabel!
    @IBOutlet weak var Front9Pars: UILabel!
    @IBOutlet weak var Front9Score: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Total Variables
        var totalYards = 0
        var totalPars = 0
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.CourseName?.text = self.parentCourseName
        
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
            self.Slope.text = "Slope: \(slopeHold)"
            self.Rating.text = "Rating: \(ratingHold)"
        })
        
        // Course Name Reference
        //let SlopeRef = Database.database().reference().child("Golf Course Data") Get the input here for course name
        
        // Player Name Reference
        
        // Reading Par Data from Course
        parRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            
            //
            let p1 = DataSnapshot.childSnapshot(forPath: "1").value as! String
            let p2 = DataSnapshot.childSnapshot(forPath: "2").value as! String
            let p3 = DataSnapshot.childSnapshot(forPath: "3").value as! String
            let p4 = DataSnapshot.childSnapshot(forPath: "4").value as! String
            let p5 = DataSnapshot.childSnapshot(forPath: "5").value as! String
            let p6 = DataSnapshot.childSnapshot(forPath: "6").value as! String
            let p7 = DataSnapshot.childSnapshot(forPath: "7").value as! String
            let p8 = DataSnapshot.childSnapshot(forPath: "8").value as! String
            let p9 = DataSnapshot.childSnapshot(forPath: "9").value as! String
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
            self.Par1.text = self.parData[0]
            self.Par2.text = self.parData[1]
            self.Par3.text = self.parData[2]
            self.Par4.text = self.parData[3]
            self.Par5.text = self.parData[4]
            self.Par6.text = self.parData[5]
            self.Par7.text = self.parData[6]
            self.Par8.text = self.parData[7]
            self.Par9.text = self.parData[8]
            
            // Total Par
            print(self.parData)
            for i in 0 ..< 9 {
                totalPars += Int(self.parData[i])!
                print(totalPars)
            }
            //print(totalYards)
            self.Front9Pars.text = "\(totalPars)"
        })
        
        // Reading Yardage Data from Course
        yardageRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            
            //
            let y1 = DataSnapshot.childSnapshot(forPath: "1").value as! String
            let y2 = DataSnapshot.childSnapshot(forPath: "2").value as! String
            let y3 = DataSnapshot.childSnapshot(forPath: "3").value as! String
            let y4 = DataSnapshot.childSnapshot(forPath: "4").value as! String
            let y5 = DataSnapshot.childSnapshot(forPath: "5").value as! String
            let y6 = DataSnapshot.childSnapshot(forPath: "6").value as! String
            let y7 = DataSnapshot.childSnapshot(forPath: "7").value as! String
            let y8 = DataSnapshot.childSnapshot(forPath: "8").value as! String
            let y9 = DataSnapshot.childSnapshot(forPath: "9").value as! String
            
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
            self.Yardage1.text = self.yardageData[0]
            self.Yardage2.text = self.yardageData[1]
            self.Yardage3.text = self.yardageData[2]
            self.Yardage4.text = self.yardageData[3]
            self.Yardage5.text = self.yardageData[4]
            self.Yardage6.text = self.yardageData[5]
            self.Yardage7.text = self.yardageData[6]
            self.Yardage8.text = self.yardageData[7]
            self.Yardage9.text = self.yardageData[8]
            
            // Total Yardage
            print(self.yardageData)
            for i in 0 ..< 9 {
                totalYards += Int(self.yardageData[i])!
                print(totalYards)
            }
            self.Front9Yards.text = "\(totalYards)"
            
        })
        
        // Reading Score Data from database
        scoreRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            
            //
            if DataSnapshot.hasChild("1") {
                if let s1 = DataSnapshot.childSnapshot(forPath: "1/Score").value as? NSNumber {
                    self.Score1.text = "\(s1)"
                }
            } else {
                self.Score1.text = " "
            }
            
            if DataSnapshot.hasChild("2") {
                if let s2 = DataSnapshot.childSnapshot(forPath: "2/Score").value as? NSNumber {
                    self.Score2.text = "\(s2)"
                }
            } else {
                self.Score2.text = " "
            }
            
            if DataSnapshot.hasChild("3") {
                if let s3 = DataSnapshot.childSnapshot(forPath: "3/Score").value as? NSNumber {
                    self.Score3.text = "\(s3)"
                }
            } else {
                self.Score3.text = " "
            }
            
            if DataSnapshot.hasChild("4") {
                if let s4 = DataSnapshot.childSnapshot(forPath: "4/Score").value as? NSNumber {
                    self.Score4.text = "\(s4)"
                }
            } else {
                self.Score4.text = " "
            }
            
            if DataSnapshot.hasChild("5") {
                if let s5 = DataSnapshot.childSnapshot(forPath: "5/Score").value as? NSNumber {
                    self.Score5.text = "\(s5)"
                }
            } else {
                self.Score5.text = " "
            }
            
            if DataSnapshot.hasChild("6") {
                if let s6 = DataSnapshot.childSnapshot(forPath: "6/Score").value as? NSNumber {
                    self.Score6.text = "\(s6)"
                }
            } else {
                self.Score6.text = " "
            }
            
            if DataSnapshot.hasChild("7") {
                if let s7 = DataSnapshot.childSnapshot(forPath: "7/Score").value as? NSNumber {
                    self.Score7.text = "\(s7)"
                }
            } else {
                self.Score7.text = " "
            }
            
            if DataSnapshot.hasChild("8") {
                if let s8 = DataSnapshot.childSnapshot(forPath: "8/Score").value as? NSNumber {
                    self.Score8.text = "\(s8)"
                }
            } else {
                self.Score8.text = " "
            }
            
            if DataSnapshot.hasChild("9") {
                if let s9 = DataSnapshot.childSnapshot(forPath: "9/Score").value as? NSNumber {
                    self.Score9.text = "\(s9)"
                }
            } else {
                self.Score9.text = " "
            }
        })
        
        // Dynamic Score
        var dynamicScore = 0
      
        // Dynamic Score Allocation
        let userRoundRef = ref.child("Users").child(uid!).child("Current Round")
        userRoundRef.observe(.childAdded, with: { (snapshot) in
            for child in snapshot.children {
                let tag = child as! DataSnapshot
                if tag.key == "Score" {
                    dynamicScore += tag.value as! Int
                }
            }
            print(dynamicScore)
            self.Front9Score.text = "\(dynamicScore)"
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
