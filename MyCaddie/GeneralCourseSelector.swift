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
    
    var tableData = [String]()
    
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
        
        // Retrieve data and listen for changes
        databaseHandle = databaseRef?.child("Golf Course Data").observe(.childAdded, with: { (snapshot) in
            
            // Code that executes when a child is added under Users
            let courseCheck = snapshot.key
            self.tableData.append(courseCheck)
            
            // Change navigation bar title based on inputed user
            //if let course = courseCheck {
            //      self.tableData.append(course)
            //}
            
            // Reload tableview
            self.courseTable.reloadData()
            
        })

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
