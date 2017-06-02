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
    
    // Overall Database Reference
    var ref = Database.database().reference()
    var databaseHandle: DatabaseHandle?
    
    // Yardage and Par Arrays
    var yardageData = [String]()
    var parData = [String]()
    
    // Label References
    // Pars
    @IBOutlet weak var Par1: UILabel!
    @IBOutlet weak var Par2: UILabel!
    @IBOutlet weak var Par3: UILabel!
    @IBOutlet weak var Par4: UILabel!
    // Yardages
    @IBOutlet weak var Yardage1: UILabel!
    @IBOutlet weak var Yardage2: UILabel!
    @IBOutlet weak var Yardage3: UILabel!
    @IBOutlet weak var Yardage4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Set Firebase Database
        ref = Database.database().reference()
        
        // Par Branch Reference
        let ParRef = Database.database().reference().child("Golf Course Data").child("www").child("Tees").child("Championship").child("Pars")
        // Yardage Branch Reference
        let YardageRef = Database.database().reference().child("Golf Course Data").child("www").child("Tees").child("Championship").child("Holes")
        
        // Reading Par Data from Course
        ParRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            
            //
            let p1 = DataSnapshot.childSnapshot(forPath: "1").value as! String
            let p2 = DataSnapshot.childSnapshot(forPath: "2").value as! String
            let p3 = DataSnapshot.childSnapshot(forPath: "3").value as! String
            let p4 = DataSnapshot.childSnapshot(forPath: "4").value as! String
            self.parData.append(p1)
            self.parData.append(p2)
            self.parData.append(p3)
            self.parData.append(p4)
            print(self.parData)
            self.Par1.text = self.parData[0]
            self.Par2.text = self.parData[1]
            self.Par3.text = self.parData[2]
            self.Par4.text = self.parData[3]
            
        })
        
        // Reading Yardage Data from Course
        YardageRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            
            //
            let y1 = DataSnapshot.childSnapshot(forPath: "1").value as! String
            let y2 = DataSnapshot.childSnapshot(forPath: "2").value as! String
            let y3 = DataSnapshot.childSnapshot(forPath: "3").value as! String
            let y4 = DataSnapshot.childSnapshot(forPath: "4").value as! String
            self.yardageData.append(y1)
            self.yardageData.append(y2)
            self.yardageData.append(y3)
            self.yardageData.append(y4)
            print(self.yardageData)
            self.Yardage1.text = self.yardageData[0]
            self.Yardage2.text = self.yardageData[1]
            self.Yardage3.text = self.yardageData[2]
            self.Yardage4.text = self.yardageData[3]
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
