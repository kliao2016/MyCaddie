//
//  GeneralTeeSelector.swift
//  MyCaddie
//
//  Created by Kevin Liao on 6/9/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class GeneralTeeSelector: UITableViewController {
    
    var teeParentCourseName = ""
    var tees = [String]()
    
    // Database reference variable
    var databaseRef: DatabaseReference?
    
    @IBOutlet var teeTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        teeTable.delegate = self
        teeTable.dataSource = self
        
        self.navigationItem.title = "Select Tees for \(teeParentCourseName)"
        
        // Reference Firebase Database
        databaseRef = Database.database().reference()
        
        // Load table view cells
        fetchTees()
    }
    
    func fetchTees() {
        databaseRef?.child("Golf Course Data").child(teeParentCourseName).observe(.childAdded, with: { (snapshot) in
            
            for child in snapshot.children {
                let tee = child as! DataSnapshot
                self.tees.append(tee.key)
                self.teeTable.reloadData()
            }
            
        }, withCancel: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = teeTable.dequeueReusableCell(withIdentifier: "TeeCell")
        cell?.textLabel?.text = tees[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "statsSegue", sender: tees[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "statsSegue" {
            let statsView = segue.destination as! Stats2
            
            statsView.courseName = self.teeParentCourseName
            
            let indexPath = self.teeTable.indexPathForSelectedRow
            statsView.tees = tees[(indexPath?.row)!]
        }
    }
    
}
