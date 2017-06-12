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
    
    var tees = ""
    
    // Overall Database Reference
    var ref = Database.database().reference()
    var databaseHandle: DatabaseHandle?
    
    // Yardage and Par Arrays
    var yardageData = [String]()
    var parData = [String]()
    var scoreData = [String]()
    
    // Label References
    
    // Titles
    @IBOutlet weak var CourseName: UILabel!
    @IBOutlet weak var Slope: UILabel!
    @IBOutlet weak var Rating: UILabel!
    @IBOutlet weak var PlayerName: UILabel!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set Firebase Database
        ref = Database.database().reference()
        
        // Par Branch Reference
        let parRef = ref.child("Golf Course Data").child(CourseName.text!).child("Tees").child(tees).child("Pars")
        // Yardage Branch Reference
        let yardageRef = ref.child("Golf Course Data").child(CourseName.text!).child("Tees").child(tees).child("Holes")
        let scoreRef = ref.child("Golf Course Data").child(CourseName.text!).child("Tees").child(tees).child("Scores")
        
        // Slope and Rating Reference and Output
        let slopeRef = ref.child("Golf Course Data").child(CourseName.text!).child("Tees").child(tees)
        
        slopeRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            if !DataSnapshot.exists() { return }
            
            let slopeHold = DataSnapshot.childSnapshot(forPath: "Slope").value as! String
            let ratingHold = DataSnapshot.childSnapshot(forPath: "Rating").value as! String
            self.Slope.text = slopeHold
            self.Rating.text = ratingHold
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
            print(self.parData)
            self.Par10.text = self.parData[0]
            self.Par11.text = self.parData[1]
            self.Par12.text = self.parData[2]
            self.Par13.text = self.parData[3]
            self.Par14.text = self.parData[4]
            self.Par15.text = self.parData[6]
            self.Par16.text = self.parData[7]
            self.Par17.text = self.parData[7]
            self.Par18.text = self.parData[8]
            
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
            print(self.yardageData)
            self.Yardage10.text = self.yardageData[0]
            self.Yardage11.text = self.yardageData[1]
            self.Yardage12.text = self.yardageData[2]
            self.Yardage13.text = self.yardageData[3]
            self.Yardage14.text = self.yardageData[4]
            self.Yardage15.text = self.yardageData[5]
            self.Yardage16.text = self.yardageData[6]
            self.Yardage17.text = self.yardageData[7]
            self.Yardage18.text = self.yardageData[8]
        })
      
        scoreRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            
            //
            if DataSnapshot.hasChild("10") {
                let s10 = DataSnapshot.childSnapshot(forPath: "10").value as! String
                self.scoreData.append(s10)
                self.Score10.text = self.scoreData[0]
            }
            if DataSnapshot.hasChild("11") {
                let s11 = DataSnapshot.childSnapshot(forPath: "11").value as! String
                self.scoreData.append(s11)
                self.Score11.text = self.scoreData[1]
            }
            
            if DataSnapshot.hasChild("12") {
                let s12 = DataSnapshot.childSnapshot(forPath: "12").value as! String
                self.scoreData.append(s12)
                self.Score12.text = self.scoreData[2]
            }
            if DataSnapshot.hasChild("13") {
                let s13 = DataSnapshot.childSnapshot(forPath: "13").value as! String
                self.scoreData.append(s13)
                self.Score13.text = self.scoreData[3]
            }
            if DataSnapshot.hasChild("14") {
                let s14 = DataSnapshot.childSnapshot(forPath: "14").value as! String
                self.scoreData.append(s14)
                self.Score14.text = self.scoreData[4]
            }
            if DataSnapshot.hasChild("15") {
                let s15 = DataSnapshot.childSnapshot(forPath: "15").value as! String
                self.scoreData.append(s15)
                self.Score15.text = self.scoreData[5]
            }
            if DataSnapshot.hasChild("16") {
                let s16 = DataSnapshot.childSnapshot(forPath: "16").value as! String
                self.scoreData.append(s16)
                self.Score16.text = self.scoreData[6]
            }
            if DataSnapshot.hasChild("17") {
                let s17 = DataSnapshot.childSnapshot(forPath: "17").value as! String
                self.scoreData.append(s17)
                self.Score17.text = self.scoreData[7]
            }
            if DataSnapshot.hasChild("18") {
                let s18 = DataSnapshot.childSnapshot(forPath: "18").value as! String
                self.scoreData.append(s18)
                self.Score18.text = self.scoreData[8]
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismissScorecard(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

