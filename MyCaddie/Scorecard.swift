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
    
    var ref = Database.database().reference()
    var databaseHandle: DatabaseHandle?
    var yardageData = [String]()
    var parData = [String]()
    
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
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
