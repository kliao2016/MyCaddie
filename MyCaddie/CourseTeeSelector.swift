//
//  CourseTeeSelector.swift
//  MyCaddie
//
//  Created by Kevin Liao on 8/9/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Floaty

class CourseTeeSelector: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        self.teeTable.tableFooterView = UIView(frame: .zero)
        
        self.navigationItem.title = "Select Tees"
        
        // Reference Firebase Database
        databaseRef = Database.database().reference()
        
        // Load table view cells
        fetchTees()
        
        // Floating Action Button
        createFAB()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tees.count
    }
    
    func createFAB() {
        let floatyNewOptionsButton = Floaty()
        floatyNewOptionsButton.buttonColor = UIColor(colorLiteralRed: 0/255, green: 128/255, blue: 64/255, alpha: 1)
        let champOption = FloatyItem()
        champOption.buttonColor = UIColor.black
        champOption.title = "Championship Tees"
        champOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCreateCourse)))
        
        let mensOption = FloatyItem()
        mensOption.buttonColor = UIColor.blue
        mensOption.title = "Men's Tees"
        mensOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCreateCourse)))
        
        let womensOption = FloatyItem()
        womensOption.buttonColor = UIColor.red
        womensOption.title = "Women's Tees"
        womensOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCreateCourse)))
        
        let seniorOption = FloatyItem()
        seniorOption.buttonColor = UIColor.white
        seniorOption.title = "Senior Tees"
        seniorOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCreateCourse)))
        
        floatyNewOptionsButton.addItem(item: seniorOption)
        floatyNewOptionsButton.addItem(item: womensOption)
        floatyNewOptionsButton.addItem(item: mensOption)
        floatyNewOptionsButton.addItem(item: champOption)
        self.view.addSubview(floatyNewOptionsButton)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = teeTable.dequeueReusableCell(withIdentifier: "TeeCell")
        cell?.textLabel?.text = tees[indexPath.row]
        return cell!
    }
    
    func showCreateCourse() {
        let createCourseView = storyboard?.instantiateViewController(withIdentifier: "CreateCourseView")
        createCourseView?.navigationItem.title = "Create a Course"
        self.show(createCourseView!, sender: self)
    }
    
    func seniorCreateCourse() {
        let createCourseView = storyboard?.instantiateViewController(withIdentifier: "CreateCourseView") as! CreateViewController
        createCourseView.navigationItem.title = "Create a Course"
        createCourseView.dropTextBox?.text = "Senior"
        createCourseView.courseName?.text = self.teeParentCourseName
        self.show(createCourseView, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "statsSegue" {
            let statsView = segue.destination as! NewRound
            statsView.courseName = self.teeParentCourseName
            
            let indexPath = self.teeTable.indexPathForSelectedRow
            statsView.tees = tees[(indexPath?.row)!]
        }
    }

}
