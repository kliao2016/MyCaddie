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
    
    let main = Main()
    
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
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            
            var provider = ""
            var providerName = ""
            var providerEmail = ""
            Auth.auth().currentUser?.providerData.forEach({ (profile) in
                provider = profile.providerID
                providerName = profile.displayName! ?? self.main.appUser.name!
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
                let lifetimeRef = self.databaseRef?.child("Users").child(uid!).child("Lifetime Stats")
                lifetimeRef?.child("Fairways").setValue(0)
                lifetimeRef?.child("Fairway Bunkers").setValue(0)
                lifetimeRef?.child("Fringes").setValue(0)
                lifetimeRef?.child("Greens").setValue(0)
                lifetimeRef?.child("Greenside Bunkers").setValue(0)
                lifetimeRef?.child("Hazards").setValue(0)
                lifetimeRef?.child("Lefts").setValue(0)
                lifetimeRef?.child("Rights").setValue(0)
                lifetimeRef?.child("OBs").setValue(0)
                lifetimeRef?.child("Putts").setValue(0)
                lifetimeRef?.child("Score").setValue(0)
                
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "userRoundsSegue", sender: courses[indexPath.row])
    }
    
    func checkCurrentRound() {
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let userRef = ref.child("Users").child(uid!)
        userRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            
            if DataSnapshot.hasChild("Current Round") {
                self.promptReturn()
            }
        })

    }
    
    func promptReturn(){
            let promptPopUp = UIAlertController(title: "Would you like to continue your previous round?", message: nil, preferredStyle: .alert)
            
            promptPopUp.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [promptPopUp] (_) in
                promptPopUp.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "mainToLoadSegue", sender: self)
            }))
            promptPopUp.addAction(UIAlertAction(title: "No", style: .default, handler: { [promptPopUp] (_) in
                promptPopUp.dismiss(animated: true, completion: nil)
                self.deleteCurrentRound()
            }))
            
            self.present(promptPopUp, animated: true, completion: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToLoadSegue" {
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
                let newProgramVar = Program(cName: c1, tName: t1, currentHoleNumber: currentHole)
                // Create a new variable to store the instance of PlayerTableViewController
                let destinationVC = segue.destination as! LoadingScreen
                destinationVC.programVar = newProgramVar
                
            })
        }
        
        if segue.identifier == "userRoundsSegue" {
            let roundsView = segue.destination as! RoundSelector
            
            let indexPath = self.courseTable.indexPathForSelectedRow
            
            roundsView.roundParentCourseName = courses[(indexPath?.row)!]
        }
    }

    
}
