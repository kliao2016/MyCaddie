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


class CreateViewController: UIViewController, UIPickerViewDelegate {
    
    let ref = Database.database().reference()
    let Tees = ["Championship", "Men", "Women", "Senior"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Drop Down Text Box Reference
    @IBOutlet weak var DropTextBox: UITextField!
    @IBOutlet weak var DropDown: UIPickerView!
    
    // Outlets to Database
    @IBOutlet weak var CourseName: UITextField!
    
    @IBOutlet weak var CourseRating: UITextField!
    
    @IBOutlet weak var Hole1: UITextField!
    
    @IBOutlet weak var Hole2: UITextField!
    
    @IBOutlet weak var Hole3: UITextField!
    
    
    // Push Button To Upload to Database
    @IBAction func createCourse(_ sender: Any) {
        self.ref.child("Golf Course Data").child(CourseName.text!).child("Tees").child("Championship").setValue(["Rating": CourseRating.text!])
        
        let prev = previousViewController()
        if !(prev is FirstViewController) {
            self.performSegue(withIdentifier: "selectBackSegue", sender: self)
        }
    }
    
    func displayAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please Enter All Information", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    ///Get previous view controller of the navigation stack
    func previousViewController() -> UIViewController? {
        
        let length = self.childViewControllers.count
        
        let previousViewController: UIViewController? = length >= 2 ? self.childViewControllers[length - 2] : nil
        
        return previousViewController
    }
    
    // UI Picker Constructors
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Tees.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Tees[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.DropTextBox.text = self.Tees[row]
        self.DropDown.isHidden = true
    }
}
