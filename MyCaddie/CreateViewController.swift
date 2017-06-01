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


class CreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let ref = Database.database().reference()
    let tees = ["Championship", "Men", "Women", "Senior"]
    var pars = ["4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4"]
    
    // Yardage textfields
    @IBOutlet weak var y1: UITextField!
    @IBOutlet weak var y2: UITextField!
    @IBOutlet weak var y3: UITextField!
    @IBOutlet weak var y4: UITextField!
    @IBOutlet weak var y5: UITextField!
    @IBOutlet weak var y6: UITextField!
    @IBOutlet weak var y7: UITextField!
    @IBOutlet weak var y8: UITextField!
    @IBOutlet weak var y9: UITextField!
    @IBOutlet weak var y10: UITextField!
    @IBOutlet weak var y11: UITextField!
    @IBOutlet weak var y12: UITextField!
    @IBOutlet weak var y13: UITextField!
    @IBOutlet weak var y14: UITextField!
    @IBOutlet weak var y15: UITextField!
    @IBOutlet weak var y16: UITextField!
    @IBOutlet weak var y17: UITextField!
    @IBOutlet weak var y18: UITextField!
    
    // Par segmented control
    @IBAction func par1(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 3)
            pars.insert("3", at: 2)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 3)
            pars.insert("4", at: 2)
        } else {
            pars.remove(at: 3)
            pars.insert("5", at: 2)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        teePicker.delegate = self
        teePicker.dataSource = self
        teePicker.backgroundColor = UIColor.white
        
        // Bind textfield to picker
        dropTextBox.inputView = teePicker
        
        createCourseButton.backgroundColor = UIColor(red: 66/255, green: 244/255, blue: 149/255, alpha: 1.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Dismiss keyboard when view is tapped on
        y1.resignFirstResponder()
        y2.resignFirstResponder()
        y3.resignFirstResponder()
        y4.resignFirstResponder()
        y5.resignFirstResponder()
        y6.resignFirstResponder()
        y7.resignFirstResponder()
        y8.resignFirstResponder()
        y9.resignFirstResponder()
        y10.resignFirstResponder()
        y11.resignFirstResponder()
        y12.resignFirstResponder()
        y13.resignFirstResponder()
        y14.resignFirstResponder()
        y15.resignFirstResponder()
        y16.resignFirstResponder()
        y17.resignFirstResponder()
        y18.resignFirstResponder()
        courseName.resignFirstResponder()
        courseRating.resignFirstResponder()
        dropTextBox.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Drop Down Text Box Reference
    @IBOutlet weak var dropTextBox: UITextField!
    
    @IBOutlet weak var createCourseButton: UIButton!
    
    // Outlets to Database
    @IBOutlet weak var courseName: UITextField!
    
    @IBOutlet weak var courseRating: UITextField!
    let teePicker = UIPickerView()
    
    
    // Push Button To Upload to Database
    @IBAction func createCourse(_ sender: Any) {
        self.ref.child("Golf Course Data").child(courseName.text!).child("Tees").child("Championship").setValue(["Rating": courseRating.text!])
        
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
        return tees.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tees[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = tees[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!, NSForegroundColorAttributeName:UIColor.blue])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.dropTextBox.text = self.tees[row]
        self.view.endEditing(false)
    }
    
}
