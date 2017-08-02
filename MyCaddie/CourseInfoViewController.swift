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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
