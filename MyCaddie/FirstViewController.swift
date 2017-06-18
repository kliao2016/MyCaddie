//
//  FirstViewController.swift
//  MyCaddie
//
//  Created by Kevin Liao on 5/27/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase
import GoogleSignIn

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var startRoundButton: UIButton!
    
    @IBAction func signOut(_ sender: Any) {
        handleLogout()
    }

    @IBOutlet weak var courseTable: UITableView!
    
    // Reference to database
    var ref = Database.database().reference()
    var databaseRef: DatabaseReference?
    
    var courses = [String]()
    
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
        
        checkCurrentRound()
        
        
        // Button customizations
        startRoundButton.backgroundColor = UIColor(red: 66/255, green: 244/255, blue: 149/255, alpha: 1.0)
        startRoundButton.addTarget(self, action: #selector(deleteCurrentRound), for: UIControlEvents.touchUpInside)
        
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
            let courseName = snapshot.key
            
            self.courses.append(courseName)
            
            self.courseTable.reloadData()
            
        }, withCancel: nil)
        
    }
    
    func deleteCourse(courseName: String) {
        if Auth.auth().currentUser != nil {
            let uid = Auth.auth().currentUser?.uid
            let userReference = self.databaseRef?.child("Users").child(uid!)
            let userCourseDataRef = userReference?.child("Courses").child(courseName)
            userCourseDataRef?.removeValue()
        }
    }
    
    func deleteCurrentRound() {
        if Auth.auth().currentUser != nil {
            let uid = Auth.auth().currentUser?.uid
            let userReference = self.databaseRef?.child("Users").child(uid!)
            userReference?.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild("Current Round") {
                    userReference?.child("Current Round").removeValue()
                }
            })
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = courseTable.dequeueReusableCell(withIdentifier: "CourseCell")
        cell?.textLabel?.text = courses[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteCourse(courseName: courses[indexPath.row])
            self.courses.remove(at: indexPath.row)
            self.courseTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func checkCurrentRound() {
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let userRef = ref.child("Users").child(uid!)
        userRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            
            if DataSnapshot.hasChild("Current Round") {
                print("Happiness")
                self.promptReturn()
            } else {
                print("Sadness")
            }
            
        })

    }
    
    func promptReturn(){
            let promptPopUp = UIAlertController(title: "Would you like to continue your previous round?", message: nil, preferredStyle: .alert)
            
            promptPopUp.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [promptPopUp] (_) in
                promptPopUp.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "mainToStatsSegue", sender: self)
                print("yay")
            }))
            promptPopUp.addAction(UIAlertAction(title: "No", style: .default, handler: { [promptPopUp] (_) in
                promptPopUp.dismiss(animated: true, completion: nil)
                print("nay")
            }))
            
            self.present(promptPopUp, animated: true, completion: nil)

    }
 
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToStatsSegue" {
            // Create a variable that you want to send
            
            let uid = Auth.auth().currentUser?.uid
            let userReference = Database.database().reference().child("Users").child(uid!).child("Current Round")
            
            userReference.observeSingleEvent(of: .value, with: {DataSnapshot in
                // Return if no data exists
                //if !DataSnapshot.exists() { return }
                var c1 = ""
                c1 = DataSnapshot.childSnapshot(forPath: "Course Name").value as! String
                var t1 = ""
                t1 = DataSnapshot.childSnapshot(forPath: "Tees").value as! String
                var currentHole = 0
                currentHole = DataSnapshot.childSnapshot(forPath: "Current Hole").value as! Int
                //currentHole += 1
                print("I hate this app so much :)")
                print(c1)
                print(t1)
                print(currentHole)
                let newProgramVar = Program(cName: c1, tName: t1, currentHoleNumber: currentHole)
                // Create a new variable to store the instance of PlayerTableViewController
                let destinationVC = segue.destination as! LoadingScreen
                destinationVC.programVar = newProgramVar
                
            })
            
                
//            let newProgramVar = Program(cName: ccc, tName: "Championship", currentHoleNumber: 4)
//            // Create a new variable to store the instance of PlayerTableViewController
//            let destinationVC = segue.destination as! LoadingScreen
//            destinationVC.programVar = newProgramVar
//            print("Save This Spot")

            /*
            if (c1 != ""){
                let newProgramVar = Program(cName: c1, tName: "Championship", currentHoleNumber: 4)
                // Create a new variable to store the instance of PlayerTableViewController
                let destinationVC = segue.destination as! Stats2
                destinationVC.programVar = newProgramVar
                print("Save This Spot")
            }
            else {
                let newProgramVar = Program(cName: "Cherry Hills", tName: "Championship", currentHoleNumber: 3)
                // Create a new variable to store the instance of PlayerTableViewController
                let destinationVC = segue.destination as! Stats2
                destinationVC.programVar = newProgramVar
                print("Watwatwat")
            }
 */
        }
    }

    
}

struct Program {
    let cName: String
    let tName: String
    let currentHoleNumber: Int
}

/*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToStatsSegue" {
            
            
            let statsView = storyboard?.instantiateViewController(withIdentifier: "StatsView") as! Stats2
            
            ref = Database.database().reference()
            let uid = Auth.auth().currentUser?.uid
            let userRef = ref.child("Users").child(uid!).child("Current Round")
            
            //var courseName = ""
            //var tees = ""
            let destinationVC = segue.destination as! Stats2
            let newProgramVar = Program(cName: "Cherry Hills", tName: "Championship")
            destinationVC.programVar = newProgramVar
            
            print("Hellloooooo")
            statsView.courseName = "Cherry Hills"
            statsView.tees = "Championship"
            }
        }
}
 */
            
            /*
            userRef.observeSingleEvent(of: .value, with: {DataSnapshot in
                // Return if no data exists
                if !DataSnapshot.exists() { return }
                
                courseName = DataSnapshot.childSnapshot(forPath: "Course Name").value as! String
                tees = DataSnapshot.childSnapshot(forPath: "Tees").value as! String
                
            })
            


        }
    }
*/
