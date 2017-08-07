//
//  CourseInfoViewController.swift
//  MyCaddie
//
//  Created by Kevin Liao on 7/31/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth

class CourseInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var roundParentCourseName = ""
    var rounds = [String]()
    
    @IBOutlet weak var courseInfoTable: UITableView!
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var numRounds: UILabel!
    
    var databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.courseImage.contentMode = .scaleAspectFill
        self.courseImage.layer.cornerRadius = self.courseImage.frame.size.width / 2
        self.courseImage.clipsToBounds = true
        
        self.courseInfoTable.delegate = self
        self.courseInfoTable.dataSource = self

        self.courseName.text = roundParentCourseName
        self.navigationItem.rightBarButtonItem = editButtonItem
        self.navigationItem.title = "Course Info"
        
        fetchRounds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.numRounds.text = "\(self.rounds.count) Rounds Played"
        return rounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = courseInfoTable.dequeueReusableCell(withIdentifier: "courseInfoCell") as! CourseInfoTableViewCell
        cell.roundNumber.text = rounds[indexPath.row]
        let uid = Auth.auth().currentUser?.uid
        let courseReference = databaseRef.child("Users").child(uid!).child("Courses").child(self.roundParentCourseName).child(rounds[indexPath.row])
        courseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                cell.roundTees.text = (dictionary["Tees"] as? String)! + " Tees"
            }
        }, withCancel: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "userStatsSegue", sender: rounds[indexPath.row])
    }
    
    func fetchRounds() {
        
        let uid = Auth.auth().currentUser?.uid
        let userRef = self.databaseRef.child("Users").child(uid!)
        userRef.child("Courses").child(roundParentCourseName).observe(.childAdded, with: { (snapshot) in
            
            let round = snapshot.key
            if round != "Rounds Played" {
                self.rounds.append(round)
                self.courseInfoTable.reloadData()
            }
            
        }, withCancel: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userStatsSegue" {
            // Create a variable that you want to send
            
            let uid = Auth.auth().currentUser?.uid
            let indexPath = self.courseInfoTable.indexPathForSelectedRow
            let destinationVC = segue.destination as! StatsViewController
            
            let userRoundRef = databaseRef.child("Users").child(uid!).child("Courses").child(self.roundParentCourseName).child(rounds[(indexPath?.row)!])
            
            userRoundRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let fbunkers = dictionary["Fairway Bunkers"] as! Int
                    let fairways = dictionary["Fairways"] as! Int
                    let fringes = dictionary["Fringes"] as! Int
                    let greens = dictionary["Greens"] as! Int
                    let gbunkers = dictionary["Greenside Bunkers"] as! Int
                    let hazards = dictionary["Hazards"] as! Int
                    let lefts = dictionary["Lefts"] as! Int
                    let obs = dictionary["OBs"] as! Int
                    let putts = dictionary["Putts"] as! Int
                    let rights = dictionary["Rights"] as! Int
                    let score = dictionary["Score"] as! Int
                    destinationVC.Score = String(score)
                    destinationVC.Fairways = String(fairways)
                    destinationVC.Greens = String(greens)
                    destinationVC.Putts = String(putts)
                    destinationVC.Fringes = String(fringes)
                    destinationVC.Hazards = String(hazards)
                    destinationVC.Lefts = String(lefts)
                    destinationVC.Rights = String(rights)
                    destinationVC.FBunkers = String(fbunkers)
                    destinationVC.GBunkers = String(gbunkers)
                    destinationVC.OBs = String(obs)
                }
            }, withCancel: nil)
            
        }
    }
    
}
