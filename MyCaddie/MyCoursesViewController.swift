//
//  MyCoursesViewController.swift
//  MyCaddie
//
//  Created by Weston Mauz on 7/19/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth

class MyCoursesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var myCoursesNavigationView: UIView!
    @IBOutlet weak var myCoursesTable: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var numCourses: UILabel!
    
    var courses = [String]()
    
    var databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()
        customizeNavBar()
        
        self.myCoursesTable.delegate = self
        self.myCoursesTable.dataSource = self
        
        createFAB()
        loadProfileImage()
        fetchCourses()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenus() {
        
        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            
            /*
            alertButton.target = revealViewController()
            alertButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
 */
            
            //view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func customizeNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0/255, green: 128/255, blue: 64/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.numCourses.text = "\(self.courses.count) Courses Played"
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myCoursesTable.dequeueReusableCell(withIdentifier: "myCoursesCell") as! MyCoursesTableViewCell
        
        cell.courseName.text = courses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteCourse(courseName: courses[indexPath.row])
            self.courses.remove(at: indexPath.row)
            self.myCoursesTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func loadProfileImage() {
        self.profileImage.contentMode = .scaleAspectFill
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.clipsToBounds = true
        if let uid = Auth.auth().currentUser?.uid {
            let user = databaseRef.child("Users").child(uid)
            user.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let userProfileLink = dictionary["ProfileImageURL"]
                    if let profileImageUrl = userProfileLink {
                        self.profileImage.loadImagesUsingCacheWithUrlString(urlString: profileImageUrl as! String)
                    }
                    self.userName.text = dictionary["Name"] as? String
                }
            }, withCancel: nil)
        }
    }
    
    func createFAB() {
        let floatyNewOptionsButton = Floaty()
        floatyNewOptionsButton.buttonColor = UIColor(colorLiteralRed: 0/255, green: 128/255, blue: 64/255, alpha: 1)
        let newRoundOption = FloatyItem()
        newRoundOption.buttonColor = UIColor.green
        newRoundOption.title = "New Round"
        newRoundOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(displayNewRound)))
        let newCourseOption = FloatyItem()
        newCourseOption.buttonColor = UIColor.blue
        newCourseOption.title = "Add New Course"
        newCourseOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(displayAddNewCourse)))
        floatyNewOptionsButton.addItem(item: newRoundOption)
        floatyNewOptionsButton.addItem(item: newCourseOption)
        self.view.addSubview(floatyNewOptionsButton)
    }
    
    func displayNewRound() {
        let courseDatabaseView = storyboard?.instantiateViewController(withIdentifier: "courseDatabaseView")
        courseDatabaseView?.navigationItem.title = "Choose a Course"
        self.show(courseDatabaseView!, sender: self)
    }
    
    func displayAddNewCourse() {
        let newCourseView = storyboard?.instantiateViewController(withIdentifier: "CreateCourseView")
        newCourseView?.navigationItem.title = "Create a Course"
        self.show(newCourseView!, sender: self)
    }
    
    func fetchCourses() {
        let uid = Auth.auth().currentUser?.uid
        let userReference = self.databaseRef.child("Users").child(uid!)
        userReference.child("Courses").observe(.childAdded, with: { (snapshot) in
            let courseName = snapshot.key
            
            self.courses.append(courseName)
            
            self.myCoursesTable.reloadData()
            
        }, withCancel: nil)
    }
    
    func deleteCourse(courseName: String) {
        if Auth.auth().currentUser != nil {
            let uid = Auth.auth().currentUser?.uid
            let userReference = self.databaseRef.child("Users").child(uid!)
            let userCourseDataRef = userReference.child("Courses").child(courseName)
            userCourseDataRef.removeValue()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "courseInfoSegue" {
            let courseInfoView = segue.destination as! CourseInfoViewController
            
            let indexPath = self.myCoursesTable.indexPathForSelectedRow
            
            courseInfoView.roundParentCourseName = courses[(indexPath?.row)!]
        }
    }

}
