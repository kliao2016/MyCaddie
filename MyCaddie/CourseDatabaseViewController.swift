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

class CourseDatabaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, GMSAutocompleteViewControllerDelegate {
    
    // Search Bar Outlet
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearching = false
    var selectedCourseName = ""

    var databaseRef = Database.database().reference()
    
    var courses = [String]()
    var filteredCourses = [String]()
    var mapView: GMSMapView!

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
            let teeView = segue.destination as! CourseTeeSelector
            
            let indexPath = self.courseDatabaseTable.indexPathForSelectedRow
            
            if filteredCourses.count == 0 {
                teeView.teeParentCourseName = courses[(indexPath?.row)!]
            }
            else {
                teeView.teeParentCourseName = filteredCourses[(indexPath?.row)!]
            }
        }
        
        
        
        
        
        // For GPS function coming in the future
        
        /*
        if segue.identifier == "findCourseToTeeSegue" {
            let teeView = segue.destination as! GeneralTeeSelector
            
            teeView.teeParentCourseName = self.selectedCourseName
        }
        */
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            
            isSearching = false
            view.endEditing(true)
            courseDatabaseTable.reloadData()
            
            // Reseting Filtered Courses to empty array to avoid crash
            filteredCourses = [String]()
            
        }
        else {
            isSearching = true
            filteredCourses = courses.filter({$0.contains(searchBar.text!)})
            courseDatabaseTable.reloadData()
        }
    }
    
    // Initialize Google Place Picker
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension CourseDatabaseViewController: GMSPlacePickerViewControllerDelegate {
    
    // Create Place Picker
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        
        // Dismiss the place picker, as it cannot dismiss itself.
        self.selectedCourseName = place.name
        viewController.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "findCourseToTeeSegue", sender: self)
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func presentPlacePicker(coordinate: CLLocationCoordinate2D) {
        let center = coordinate
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001,
                                               longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001,
                                               longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        presentPlacePicker(coordinate: place.coordinate)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


