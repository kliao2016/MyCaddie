//
//  GeneralCourseSelector.swift
//  MyCaddie
//
//  Created by Kevin Liao on 6/6/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class GeneralCourseSelector: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var courseTable: UITableView!
    
    var courses = [String]()
    
    // Reference to database
    var databaseRef: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        courseTable.delegate = self
        courseTable.dataSource = self
        
        // Set Firebase Database
        databaseRef = Database.database().reference()
        
        fetchCourses()

    }
    
    @IBAction func backToTabBar(_ sender: Any) {
        self.performSegue(withIdentifier: "UnwindToTabBar", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchCourses() {
        databaseRef?.child("Golf Course Data").observe(.childAdded, with: { (snapshot) in
            let courseName = snapshot.key
            
            self.courses.append(courseName)
            
            self.courseTable.reloadData()
            
        }, withCancel: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = courseTable.dequeueReusableCell(withIdentifier: "CourseCell")
        cell?.textLabel?.text = courses[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "teeSegue", sender: courses[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "teeSegue") {
            
            let teeTableView = segue.destination as! GeneralTeeSelector
            
            let indexPath = self.courseTable.indexPathForSelectedRow
            
            teeTableView.teeParentCourseName = courses[(indexPath?.row)!]
        }
    }
    
}
