//
//  RoundSelector.swift
//  MyCaddie
//
//  Created by Kevin Liao on 6/9/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class RoundSelector: UITableViewController {
    
    var roundParentCourseName = ""
    var rounds = [String]()
    
    // Database reference variable
    var databaseRef: DatabaseReference?
    
    @IBOutlet var roundTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        roundTable.delegate = self
        roundTable.dataSource = self
        
        self.navigationItem.title = "Select Round for \(roundParentCourseName)"
        
        // Reference Firebase Database
        databaseRef = Database.database().reference()
        
        // Load table view cells
        fetchRounds()
    }
    
    func fetchRounds() {
        
        let uid = Auth.auth().currentUser?.uid
        let userRef = self.databaseRef?.child("Users").child(uid!)
        userRef?.child("Courses").child(roundParentCourseName).observe(.childAdded, with: { (snapshot) in
            
            let round = snapshot.key
            self.rounds.append(round)
            self.roundTable.reloadData()
            
        }, withCancel: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rounds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = roundTable.dequeueReusableCell(withIdentifier: "RoundCell")
        cell?.textLabel?.text = rounds[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "userStatsSegue", sender: rounds[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userStatsSegue" {
            
            let indexPath = self.roundTable.indexPathForSelectedRow
            
            let uid = Auth.auth().currentUser?.uid
            let userRoundRef = databaseRef?.child("Users").child(uid!).child("Courses").child(self.roundParentCourseName).child(rounds[(indexPath?.row)!])
            
            let statsView = segue.destination as! StatsViewController
            
            statsView.scoreStr = userRoundRef?.value(forKey: "Score") as! String
            statsView.fairwaysStr = userRoundRef?.value(forKey: "Fairways") as! String
            statsView.greensStr = userRoundRef?.value(forKey: "Greens") as! String
            statsView.puttsStr = userRoundRef?.value(forKey: "Putts") as! String
            statsView.fringesStr = userRoundRef?.value(forKey: "Fringes") as! String
            statsView.hazardsStr = userRoundRef?.value(forKey: "Hazards") as! String
            statsView.leftStr = userRoundRef?.value(forKey: "Lefts") as! String
            statsView.rightStr = userRoundRef?.value(forKey: "Rights") as! String
            statsView.fbunkersStr = userRoundRef?.value(forKey: "Fairway Bunkers") as! String
            statsView.gbunkersStr = userRoundRef?.value(forKey: "Greenside Bunkers") as! String
            statsView.obsStr = userRoundRef?.value(forKey: "OBs") as! String
        }
    }
    
}
