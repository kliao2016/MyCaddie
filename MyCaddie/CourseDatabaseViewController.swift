//
//  CourseDatabaseViewController.swift
//  MyCaddie
//
//  Created by Weston Mauz on 7/31/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import GooglePlacePicker
import GoogleMaps
import GooglePlaces

class CourseDatabaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, GMSPlacePickerViewControllerDelegate {
    
    // Search Bar Outlet
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearching = false

    var databaseRef = Database.database().reference()
    
    var courses = [String]()
    var filteredCourses = [String]()
    var mapView: GMSMapView!

    @IBOutlet weak var numCourses: UILabel!
    @IBOutlet weak var courseDatabaseTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.courseDatabaseTable.delegate = self
        self.courseDatabaseTable.dataSource = self
        
        self.searchBar.delegate = self
        self.searchBar.returnKeyType = UIReturnKeyType.done
        
        fetchCourses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.numCourses.text = "\(courses.count) Total Courses"
        
        if isSearching {
            return filteredCourses.count
        }
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = courseDatabaseTable.dequeueReusableCell(withIdentifier: "courseDatabaseCell")
        
        if isSearching {
            cell?.textLabel?.text = filteredCourses[indexPath.row]
        }
        else {
            cell?.textLabel?.text = courses[indexPath.row]
        }
        
        return cell!
    }
    
    func fetchCourses() {
        databaseRef.child("Golf Course Data").observe(.childAdded, with: { (snapshot) in
            let courseName = snapshot.key
            
            self.courses.append(courseName)
            
            self.courseDatabaseTable.reloadData()
            
        }, withCancel: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "teeSegue" {
            let teeView = segue.destination as! GeneralTeeSelector
            
            let indexPath = self.courseDatabaseTable.indexPathForSelectedRow
            teeView.teeParentCourseName = courses[(indexPath?.row)!]
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            
            isSearching = false
            view.endEditing(true)
            courseDatabaseTable.reloadData()
            
        }
        else {
            isSearching = true
            //filteredCourses = courses.filter({$0 == searchBar.text})
            filteredCourses = courses.filter({$0.contains(searchBar.text!)})
            courseDatabaseTable.reloadData()
        }
    }
    
    // Initialize Google Place Picker
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func pickPlace(_ sender: UIButton) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        
        self.present(placePicker, animated: true, completion: nil)
    }
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("Place name \(place.name)")
        print("Place address \(String(describing: place.formattedAddress))")
        print("Place attributions \(String(describing: place.attributions))")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
}


