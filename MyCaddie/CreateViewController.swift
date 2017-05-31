//
//  CreateViewController.swift
//  
//
//  Created by Weston Mauz on 5/31/17.
//
//

import Foundation
import Firebase
import FirebaseDatabase
import UIKit


class CreateViewController: UIViewController {
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Outlets to Database
    @IBOutlet weak var CourseName: UITextField!
    
    @IBOutlet weak var CourseRating: UITextField!
    
    @IBOutlet weak var Hole1: UITextField!
    
    @IBOutlet weak var Hole2: UITextField!
    
    @IBOutlet weak var Hole3: UITextField!
    
    
    // Push Button To Upload to Database
    @IBAction func CreateCourse(_ sender: Any) {
        self.ref.child("Golf Course Data").child(CourseName.text!).child("Tees").child("Championship").setValue(["Rating": CourseRating.text!])
    }
    
    func displayAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please Enter All Information", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
