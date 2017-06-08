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
    
    @IBOutlet weak var startRoundButton: UIButton!
    
    @IBAction func signOut(_ sender: Any) {
        handleLogout()
    }

    @IBOutlet weak var courseTable: UITableView!
    
    // Reference to database
    var databaseRef: DatabaseReference?
    
    var courses = [Course]()
    
    @IBOutlet weak var welcomeTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        courseTable.delegate = self
        courseTable.dataSource = self
        
        // Set Firebase Database
        databaseRef = Database.database().reference()
        
//        // Retrieve data and listen for changes
//        databaseHandle = databaseRef?.child("Golf Course Data").observe(.childAdded, with: { (snapshot) in
//            
//            // Code that executes when a child is added under Users
//            let courseCheck = snapshot.key
//            self.tableData.append(courseCheck)
//            
//            // Reload tableview
//            self.courseTable.reloadData()
//            
//        })
        
        // Button customizations
        startRoundButton.backgroundColor = UIColor(red: 66/255, green: 244/255, blue: 149/255, alpha: 1.0)
        
        checkIfUserIsLoggedIn()
        fetchCourses()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            performSelector(onMainThread: #selector(handleLogout), with: nil, waitUntilDone: true)
        } else {
            let uid = Auth.auth().currentUser?.uid
            
            var provider = ""
            var providerName = ""
            var providerEmail = ""
            Auth.auth().currentUser?.providerData.forEach({ (profile) in
                provider = profile.providerID
                providerName = profile.displayName!
                providerEmail = profile.email!
            })
            if provider != "google.com" {
                self.databaseRef?.child("Users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let name = dictionary["Name"] as? String
                        self.welcomeTitle.title = "\(name!)'s Courses"
                    }
                }, withCancel: nil)
            } else {
                self.databaseRef?.child("Users").child(uid!).child("Name").setValue(providerName)
                self.databaseRef?.child("Users").child(uid!).child("Email").setValue(providerEmail)
                self.databaseRef?.child("Users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let name = dictionary["Name"] as? String
                        self.welcomeTitle.title = "\(name!)'s Courses"
                    }
                }, withCancel: nil)
            }

        }
    }

    func handleLogout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        GIDSignIn.sharedInstance().signOut()
        
        self.performSegue(withIdentifier: "UnwindToLogin", sender: self)
    }
    
    func fetchCourses() {
        let uid = Auth.auth().currentUser?.uid
        let userReference = self.databaseRef?.child("Users").child(uid!)
        userReference?.child("Courses").observe(.childAdded, with: { (snapshot) in
            let course = Course()
            let courseName = snapshot.key
            course.setName(name: courseName)
            
            self.courses.append(course)
            
            self.courseTable.reloadData()
            
        }, withCancel: nil)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = courseTable.dequeueReusableCell(withIdentifier: "CourseCell")
        cell?.textLabel?.text = courses[indexPath.row].getName()
        cell?.detailTextLabel?.text = "Tees: "
        
        return cell!
    }
    
}

