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
    
    var courses = [Course]()
    
    // Reference to database
    var databaseRef: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
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
