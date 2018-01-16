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
        champOption.buttonColor = UIColor(colorLiteralRed: 218/255, green: 165/255, blue: 32/255, alpha: 1)
        champOption.title = "Championship Tees"
        champOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChampCreateCourse)))
        
        let mensOption = FloatyItem()
        mensOption.buttonColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 205/255, alpha: 1)
        mensOption.title = "Men's Tees"
        mensOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMensCreateCourse)))
        
        let womensOption = FloatyItem()
        womensOption.buttonColor = UIColor(colorLiteralRed: 220/255, green: 20/255, blue: 60/255, alpha: 1)
        womensOption.title = "Women's Tees"
        womensOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showWomensCreateCourse)))
        
        let seniorOption = FloatyItem()
        seniorOption.buttonColor = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 240/255, alpha: 1)
        seniorOption.title = "Senior Tees"
        seniorOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showSeniorCreateCourse)))
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func showChampCreateCourse() {
        self.performSegue(withIdentifier: "teeToChampCreateSegue", sender: self)
    }
    
    func showMensCreateCourse() {
        self.performSegue(withIdentifier: "teeToMensCreateSegue", sender: self)
    }
    
    func showWomensCreateCourse() {
        self.performSegue(withIdentifier: "teeToWomensCreateSegue", sender: self)
    }
    
    func showSeniorCreateCourse() {
        self.performSegue(withIdentifier: "teeToSeniorCreateSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "statsSegue" {
            let statsView = segue.destination as! NewRound
            statsView.courseName = self.teeParentCourseName
            
            let indexPath = self.teeTable.indexPathForSelectedRow
            statsView.tees = tees[(indexPath?.row)!]
        }
        if segue.identifier == "teeToChampCreateSegue" {
            let destinationVC = segue.destination as! CreateViewController2
            destinationVC.parentCourseName = self.teeParentCourseName
            destinationVC.teeName = "Championship"
        }
        if segue.identifier == "teeToMensCreateSegue" {
            let destinationVC = segue.destination as! CreateViewController2
            destinationVC.parentCourseName = self.teeParentCourseName
            destinationVC.teeName = "Men's"
        }
        if segue.identifier == "teeToWomensCreateSegue" {
            let destinationVC = segue.destination as! CreateViewController2
            destinationVC.parentCourseName = self.teeParentCourseName
            destinationVC.teeName = "Women's"
        }
        if segue.identifier == "teeToSeniorCreateSegue" {
            let destinationVC = segue.destination as! CreateViewController2
            destinationVC.parentCourseName = self.teeParentCourseName
            destinationVC.teeName = "Senior"
        }
    }
    
    @IBAction func unwindToTeesFromNewRound(segue: UIStoryboardSegue) {}

}
