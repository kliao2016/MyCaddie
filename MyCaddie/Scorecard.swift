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
    @IBOutlet weak var PlayerName: UILabel!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set Firebase Database
        ref = Database.database().reference()
        
        // Par Branch Reference
        let parRef = ref.child("Golf Course Data").child(CourseName.text!).child("Tees").child(tees).child("Pars")
        // Yardage Branch Reference
        let yardageRef = ref.child("Golf Course Data").child(CourseName.text!).child("Tees").child(tees).child("Holes")
        
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
            print(self.parData)
            self.Par1.text = self.parData[0]
            self.Par2.text = self.parData[1]
            self.Par3.text = self.parData[2]
            self.Par4.text = self.parData[3]
            self.Par5.text = self.parData[4]
            self.Par6.text = self.parData[6]
            self.Par7.text = self.parData[7]
            self.Par8.text = self.parData[7]
            self.Par9.text = self.parData[8]
            
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
            print(self.yardageData)
            self.Yardage1.text = self.yardageData[0]
            self.Yardage2.text = self.yardageData[1]
            self.Yardage3.text = self.yardageData[2]
            self.Yardage4.text = self.yardageData[3]
            self.Yardage5.text = self.yardageData[4]
            self.Yardage6.text = self.yardageData[5]
            self.Yardage7.text = self.yardageData[6]
            self.Yardage8.text = self.yardageData[7]
            self.Yardage9.text = self.yardageData[8]
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
