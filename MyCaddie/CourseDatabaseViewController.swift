//
//  CourseDatabaseViewController.swift
//  MyCaddie
//
//  Created by Weston Mauz on 7/31/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CourseDatabaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var databaseRef = Database.database().reference()
    
    var courses = [String]()

    @IBOutlet weak var numCourses: UILabel!
    @IBOutlet weak var courseDatabaseTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.courseDatabaseTable.delegate = self
        self.courseDatabaseTable.dataSource = self
        
        fetchCourses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.numCourses.text = "\(courses.count) Total Courses"
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = courseDatabaseTable.dequeueReusableCell(withIdentifier: "courseDatabaseCell")
        cell?.textLabel?.text = courses[indexPath.row]
        return cell!
    }
    
    func fetchCourses() {
        databaseRef.child("Golf Course Data").observe(.childAdded, with: { (snapshot) in
            let courseName = snapshot.key
            
            self.courses.append(courseName)
            
            self.courseDatabaseTable.reloadData()
            
        }, withCancel: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "teeSegue" {
            let teeView = segue.destination as! GeneralTeeSelector
            
            let indexPath = self.courseDatabaseTable.indexPathForSelectedRow
            teeView.teeParentCourseName = courses[(indexPath?.row)!]
        }
    }


}
