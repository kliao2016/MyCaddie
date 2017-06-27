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
            

            userRoundRef?.observeSingleEvent(of: .value, with: { (snapshot) in
                
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
                    statsView.fbunkers.text = String(fbunkers)
                    statsView.fairways.text = String(fairways)
                    statsView.fringes.text = String(fringes)
                    statsView.greens.text = String(greens)
                    statsView.gbunkers.text = String(gbunkers)
                    statsView.hazards.text = String(hazards)
                    statsView.left.text = String(lefts)
                    statsView.obs.text = String(obs)
                    statsView.putts.text = String(putts)
                    statsView.right.text = String(rights)
                    statsView.score.text = String(score)
                }
            }, withCancel: nil)
            
        }
    }
    
}


