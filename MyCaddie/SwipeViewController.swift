//
//  SwipeViewController.swift
//  MyCaddie
//
//  Created by Weston Mauz on 7/19/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase
import GoogleSignIn

class SwipeViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var ref = Database.database().reference()
    var databaseRef: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()
        customizeNavBar()
        
        checkCurrentRound()
        
        databaseRef = Database.database().reference()
    
        let xcoord = self.view.frame.size.width
        let ycoord = self.view.frame.size.height
        let rect0 = CGRect(x: (xcoord / 2) - 125, y: ycoord - (ycoord * 3 / 4), width: 250, height: 30)
        let cp0 = mainScreenAnimation(frame: rect0)
        view.addSubview(cp0)
        
        let blue = UIColor.blue.cgColor
        let green = UIColor.init(red: 0, green: 128/255, blue: 64/255, alpha: 1).cgColor
        
        // Start New Round Button
        let rect5 = CGRect(x: (xcoord / 2) - 50, y: ycoord - (ycoord * 7 / 24), width: 100, height: 100)
        let cp5 = mainScreenButton(frame: rect5, words: "New Round", color1: green, color2: blue)
        cp5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(segueToNewRound)))
        view.addSubview(cp5)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenus(){
        
        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            

            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func customizeNavBar(){
        navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 128/255, blue: 64/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func checkCurrentRound() {
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let userRef = ref.child("Users").child(uid!)
        userRef.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            if !DataSnapshot.exists() { return }
            
            if DataSnapshot.hasChild("Current Round") {
                self.promptReturn()
            }
        })
        
    }
    
    func promptReturn(){
        let promptPopUp = UIAlertController(title: "Would you like to continue your previous round?", message: nil, preferredStyle: .alert)
        
        promptPopUp.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [promptPopUp] (_) in
            promptPopUp.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "mainToLoadSegue", sender: self)
        }))
        promptPopUp.addAction(UIAlertAction(title: "No", style: .default, handler: { [promptPopUp] (_) in
            promptPopUp.dismiss(animated: true, completion: nil)
            self.deleteCurrentRound()
        }))
        
        self.present(promptPopUp, animated: true, completion: nil)
        
    }
    
    func deleteCurrentRound() {
        if Auth.auth().currentUser != nil {
            let uid = Auth.auth().currentUser?.uid
            let userReference = self.databaseRef?.child("Users").child(uid!)
            userReference?.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild("Current Round") {
                    userReference?.child("Current Round").removeValue()
                }
            })
        }
    }
    
    func fetchCurrentRound(segue: UIStoryboardSegue) {
        let uid = Auth.auth().currentUser?.uid
        let userReference = Database.database().reference().child("Users").child(uid!).child("Current Round")
        
        userReference.observeSingleEvent(of: .value, with: {DataSnapshot in
            // Return if no data exists
            //if !DataSnapshot.exists() { return }
            var c1 = ""
            c1 = DataSnapshot.childSnapshot(forPath: "Course Name").value as! String
            var t1 = ""
            t1 = DataSnapshot.childSnapshot(forPath: "Tees").value as! String
            var currentHole = 0
            currentHole = DataSnapshot.childSnapshot(forPath: "Current Hole").value as! Int
            let newProgramVar = Program(cName: c1, tName: t1, currentHoleNumber: currentHole)
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destination as! LoadingScreen
            destinationVC.programVar = newProgramVar
            
        })
    }
    
    @objc func segueToNewRound() {
        self.performSegue(withIdentifier: "homeToNewRoundSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToLoadSegue" {
            // Create a variable that you want to send
            
            fetchCurrentRound(segue: segue)
        }
        
        if segue.identifier == "homeToNewRoundSegue" {
            let destinationVC = segue.destination as! CourseDatabaseViewController
            destinationVC.navigationItem.title = "Choose a Course"
        }
        /*
        if segue.identifier == "userRoundsSegue" {
            let roundsView = segue.destination as! RoundSelector
            
            let indexPath = self.courseTable.indexPathForSelectedRow
            
            roundsView.roundParentCourseName = courses[(indexPath?.row)!]
        }
 */
        
    }
    
    
    
    

}

struct Program {
    let cName: String
    let tName: String
    let currentHoleNumber: Int
}

struct roundStatData {
    let cName: String
    let tName: String
    let score: Int
    let fairways: Int
    let greens: Int
    let putts: Int
    let fringes: Int
    let hazards: Int
    let left: Int
    let right: Int
    let fbunkers: Int
    let gbunkers: Int
    let obs: Int
    
}
