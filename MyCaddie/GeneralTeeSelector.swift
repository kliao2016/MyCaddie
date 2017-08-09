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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.title = "Select Tees"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "statsSegue", sender: self.tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "statsSegue" {
            let statsView = segue.destination as! NewRound
            statsView.courseName = self.teeParentCourseName
            
            let indexPath = self.tableView.indexPathForSelectedRow
            statsView.tees = (tableView.cellForRow(at: indexPath!)?.textLabel?.text)!
        }
    }
    
}
