//
//  CreateViewController.swift
//  
//
//  Created by Weston Mauz on 5/31/17.
//
//

import Foundation
import Firebase
import FirebaseDatabase
import UIKit


class CreateViewController: UIViewController {
    
    var ref: DatabaseReference!
    let ref2 = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func CreateCourse(_ sender: Any) {
        self.ref2.child("Golf Course Data").child("Meadows").child("Tees").child("Championship").setValue(["Rating": "68.7"])
    }
}
