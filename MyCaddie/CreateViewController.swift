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


class CreateViewController: UIViewController, UIApplicationDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let ref = Database.database().reference()
    let tees = ["Championship", "Men", "Women", "Senior"]
    var pars = ["4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4", "4"]
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
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
    
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Par segmented control
    @IBAction func par1(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 0)
            pars.insert("3", at: 0)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 0)
            pars.insert("4", at: 0)
        } else {
            pars.remove(at: 0)
            pars.insert("5", at: 0)
        }
    }
    @IBAction func par2(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 1)
            pars.insert("3", at: 1)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 1)
            pars.insert("4", at: 1)
        } else {
            pars.remove(at: 1)
            pars.insert("5", at: 1)
        }
    }
    @IBAction func par3(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 2)
            pars.insert("3", at: 2)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 2)
            pars.insert("4", at: 2)
        } else {
            pars.remove(at: 2)
            pars.insert("5", at: 2)
        }
    }
    @IBAction func par4(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 3)
            pars.insert("3", at: 3)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 3)
            pars.insert("4", at: 3)
        } else {
            pars.remove(at: 3)
            pars.insert("5", at: 3)
        }
    }
    @IBAction func par5(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 4)
            pars.insert("3", at: 4)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 4)
            pars.insert("4", at: 4)
        } else {
            pars.remove(at: 4)
            pars.insert("5", at: 4)
        }
        print(pars)
    }
    
    @IBAction func par6(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 5)
            pars.insert("3", at: 5)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 5)
            pars.insert("4", at: 5)
        } else {
            pars.remove(at: 5)
            pars.insert("5", at: 5)
        }
    }
    
    @IBAction func par7(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 6)
            pars.insert("3", at: 6)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 6)
            pars.insert("4", at: 6)
        } else {
            pars.remove(at: 6)
            pars.insert("5", at: 6)
        }
    }
    
    @IBAction func par8(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 7)
            pars.insert("3", at: 7)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 7)
            pars.insert("4", at: 7)
        } else {
            pars.remove(at: 7)
            pars.insert("5", at: 7)
        }
    }
    
    @IBAction func par9(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 8)
            pars.insert("3", at: 8)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 8)
            pars.insert("4", at: 8)
        } else {
            pars.remove(at: 8)
            pars.insert("5", at: 8)
        }
    }
    
    @IBAction func par10(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 9)
            pars.insert("3", at: 9)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 9)
            pars.insert("4", at: 9)
        } else {
            pars.remove(at: 9)
            pars.insert("5", at: 9)
        }
    }
    
    @IBAction func par11(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 10)
            pars.insert("3", at: 10)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 10)
            pars.insert("4", at: 10)
        } else {
            pars.remove(at: 10)
            pars.insert("5", at: 10)
        }
    }
    
    @IBAction func par12(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 11)
            pars.insert("3", at: 11)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 11)
            pars.insert("4", at: 11)
        } else {
            pars.remove(at: 11)
            pars.insert("5", at: 11)
        }
    }
    @IBAction func par13(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 12)
            pars.insert("3", at: 12)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 12)
            pars.insert("4", at: 12)
        } else {
            pars.remove(at: 12)
            pars.insert("5", at: 12)
        }
    }
    
    @IBAction func par14(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 13)
            pars.insert("3", at: 13)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 13)
            pars.insert("4", at: 13)
        } else {
            pars.remove(at: 13)
            pars.insert("5", at: 13)
        }
    }
    
    @IBAction func par15(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 14)
            pars.insert("3", at: 14)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 14)
            pars.insert("4", at: 14)
        } else {
            pars.remove(at: 14)
            pars.insert("5", at: 14)
        }
    }
    
    @IBAction func par16(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 15)
            pars.insert("3", at: 15)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 15)
            pars.insert("4", at: 15)
        } else {
            pars.remove(at: 15)
            pars.insert("5", at: 15)
        }
    }
    
    @IBAction func par17(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 16)
            pars.insert("3", at: 16)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 16)
            pars.insert("4", at: 16)
        } else {
            pars.remove(at: 16)
            pars.insert("5", at: 16)
        }
    }
    
    @IBAction func par18(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pars.remove(at: 17)
            pars.insert("3", at: 17)
        } else if sender.selectedSegmentIndex == 1 {
            pars.remove(at: 17)
            pars.insert("4", at: 17)
        } else {
            pars.remove(at: 17)
            pars.insert("5", at: 17)
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
        navigationBar.barTintColor = UIColor(red: 66/255, green: 244/255, blue: 149/255, alpha: 1.0)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
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
        courseTextField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Drop Down Text Box Reference
    @IBOutlet weak var dropTextBox: UITextField!
    
    @IBOutlet weak var createCourseButton: UIButton!
    
    // Outlets to Database
    @IBOutlet weak var courseTextField: UITextField!
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var courseRating: UITextField!
    @IBOutlet weak var slope: UITextField!
    let teePicker = UIPickerView()
    
    // Uploading Course data to database
    @IBAction func createCourseAction(_ sender: Any) {
        
        let uid = Auth.auth().currentUser?.uid
        let userReference = self.ref.child("Users").child(uid!)
        let generalDataReference = self.ref.child("Golf Course Data")
        
        let ratingData : [String: AnyObject] = ["Rating": courseRating.text as AnyObject, "Slope": slope.text as AnyObject]
        userReference.child("Courses").child(courseName.text!).child("Tees").child(dropTextBox.text!).setValue(ratingData)
        generalDataReference.child(courseName.text!).child("Tees").child(dropTextBox.text!).setValue(ratingData)
        
        /*
        // Course Rating Upload
        self.ref.child("Golf Course Data").child(courseName.text!).child("Tees").child(dropTextBox.text!).setValue(["Rating": courseRating.text!])
        
        // Slope Upload
        self.ref.child("Golf Course Data").child(courseName.text!).child("Tees").child(dropTextBox.text!).setValue(["Slope": slope.text!])
        */
        
        // Hole Yardage Data Structure
        let holeData : [String: AnyObject] = ["1": y1.text as AnyObject, "2": y2.text as AnyObject, "3": y3.text as AnyObject, "4": y4.text as AnyObject,"5": y5.text as AnyObject, "6": y6.text as AnyObject, "7": y7.text as AnyObject, "8": y7.text as AnyObject,"9": y9.text as AnyObject, "10": y10.text as AnyObject, "11": y11.text as AnyObject, "12": y12.text as AnyObject,"13": y3.text as AnyObject, "14": y14.text as AnyObject, "15": y15.text as AnyObject, "16": y16.text as AnyObject, "17": y17.text as AnyObject, "18": y18.text as AnyObject]
        
        // Yardage Upload
        userReference.child("Courses").child(courseName.text!).child("Tees").child(dropTextBox.text!).child("Holes").setValue(holeData)
        generalDataReference.child(courseName.text!).child("Tees").child(dropTextBox.text!).child("Holes").setValue(holeData)
        
        // Par Data Structure
        let parData : [String: AnyObject] = ["1": pars[0] as AnyObject, "2": pars[1] as AnyObject, "3": pars[2] as AnyObject, "4": pars[3] as AnyObject,"5": pars[4] as AnyObject, "6": pars[5] as AnyObject, "7": pars[6] as AnyObject, "8": pars[7] as AnyObject,"9": pars[8] as AnyObject, "10": pars[9] as AnyObject, "11": pars[10] as AnyObject, "12": pars[11] as AnyObject,"13": pars[12] as AnyObject, "14": pars[13] as AnyObject, "15": pars[14] as AnyObject, "16": pars[15] as AnyObject, "17": pars[16] as AnyObject, "18": pars[17] as AnyObject]
        
        // Par Upload
        userReference.child("Courses").child(courseName.text!).child("Tees").child(dropTextBox.text!).child("Pars").setValue(parData)
        generalDataReference.child(courseName.text!).child("Tees").child(dropTextBox.text!).child("Pars").setValue(parData)
        
        dismiss(animated: true, completion: nil)
    }
    
    func displayAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please Enter All Information", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
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
