//
//  FirstViewController.swift
//  MyCaddie
//
//  Created by Kevin Liao on 5/27/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import GoogleSignIn

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        GIDSignIn.sharedInstance().signOut()
        
        self.performSegue(withIdentifier: "BackSegue", sender: self)
    }

    @IBOutlet weak var courseTable: UITableView!
    
    // Reference to database
    var ref: DatabaseReference?
    
    var tableData = [String]()
    var databaseHandle: DatabaseHandle?
    
    @IBOutlet weak var welcomTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        courseTable.delegate = self
        courseTable.dataSource = self
        
        // Set Firebase Database
        ref = Database.database().reference()
        
        // Retrieve data and listen for changes
        databaseHandle = ref?.child("Users/User").observe(.childAdded, with: { (snapshot) in
            
            // Code that executes when a child is added under Users
            let nameCheck = snapshot.value as? String
            
            // Change navigation bar title based on inputed user
            if let name = nameCheck {
                self.welcomTitle.title = "Welcome " + name + "!"
            }
            
            // Reload tableview
            self.courseTable.reloadData()
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = courseTable.dequeueReusableCell(withIdentifier: "CourseCell")
        cell?.textLabel?.text = tableData[indexPath.row]
        return cell!
    }
}

