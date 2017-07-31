//
//  ProfileViewController.swift
//  MyCaddie
//
//  Created by Weston Mauz on 7/19/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var databaseRef = Database.database().reference()

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var alertButton: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    let welcomeLabel = CATextLayer()
    let welcomeLabel2 = CATextLayer()
    let welcomeLabel3 = CATextLayer()
    let welcomeLabel4 = CATextLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()
        customizeNavBar()
        
        // Background
        let back = CGRect(x: 0, y: 0, width: 500, height: 800)
        let ground = profileBackground(frame: back)
        //view.addSubview(ground)
        view.insertSubview(ground, at: 0)
 
        // Lower Left
        let lowLeft = CGRect(x: 10, y: 410, width: 120, height: 20)
        let place1 = UIView(frame: lowLeft)
        view.addSubview(place1)
        
        place1.layer.addSublayer(welcomeLabel)
        //place1.addSubview(welcomeLabel)
        // Text Label
        welcomeLabel.string = "Hola"
        welcomeLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 20)
        welcomeLabel.fontSize = 18
        welcomeLabel.alignmentMode = kCAAlignmentCenter
        welcomeLabel.foregroundColor = UIColor.white.cgColor
        welcomeLabel.alignmentMode = kCAAlignmentLeft
        
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        welcomeLabel.add(animation, forKey: nil)
 
        // Lower Right
        let lowRight = CGRect(x: 250, y: 410, width: 120, height: 20)
        let place2 = UIView(frame: lowRight)
        view.addSubview(place2)
        
        place2.layer.addSublayer(welcomeLabel2)
        //place1.addSubview(welcomeLabel)
        // Text Label
        welcomeLabel2.string = "Hello"
        welcomeLabel2.frame = CGRect(x: 0, y: 0, width: 120, height: 20)
        welcomeLabel2.fontSize = 18
        welcomeLabel2.alignmentMode = kCAAlignmentCenter
        welcomeLabel2.foregroundColor = UIColor.white.cgColor
        welcomeLabel2.alignmentMode = kCAAlignmentRight


        let animation2 = CABasicAnimation(keyPath: "opacity")
        animation2.fromValue = 0
        animation2.toValue = 1
        animation2.duration = 1
        welcomeLabel2.add(animation2, forKey: nil)
 
        // Upper Left
        let upperLeft = CGRect(x: 10, y: 70, width: 120, height: 20)
        let place3 = UIView(frame: upperLeft)
        view.addSubview(place3)
        
        place3.layer.addSublayer(welcomeLabel3)
        //place1.addSubview(welcomeLabel)
        // Text Label
        welcomeLabel3.string = "Wassup"
        welcomeLabel3.frame = CGRect(x: 0, y: 0, width: 120, height: 20)
        welcomeLabel3.fontSize = 18
        welcomeLabel3.alignmentMode = kCAAlignmentCenter
        welcomeLabel3.foregroundColor = UIColor.white.cgColor
        welcomeLabel3.alignmentMode = kCAAlignmentLeft
        
         let animation3 = CABasicAnimation(keyPath: "opacity")
         animation3.fromValue = 0
         animation3.toValue = 1
         animation3.duration = 1
         welcomeLabel3.add(animation3, forKey: nil)
        

        // Upper Right
        let upperRight = CGRect(x: 250, y: 70, width: 120, height: 20)
        let place4 = UIView(frame: upperRight)
        view.addSubview(place4)
        
        place4.layer.addSublayer(welcomeLabel4)
        //place1.addSubview(welcomeLabel)
        // Text Label
        welcomeLabel4.string = "YOOOOO"
        welcomeLabel4.frame = CGRect(x: 0, y: 0, width: 120, height: 20)

        welcomeLabel4.fontSize = 18
        welcomeLabel4.alignmentMode = kCAAlignmentCenter
        welcomeLabel4.foregroundColor = UIColor.white.cgColor
        welcomeLabel4.alignmentMode = kCAAlignmentRight
        
        
         let animation4 = CABasicAnimation(keyPath: "opacity")
         animation4.fromValue = 0
         animation4.toValue = 1
         animation4.duration = 1
         welcomeLabel4.add(animation4, forKey: nil)
        

        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        profileImage.isUserInteractionEnabled = true
        
        pullImageFromDatabase()
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
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func customizeNavBar(){
        navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0/255, green: 128/255, blue: 64/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func handleSelectProfileImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            selectedImageFromPicker = editedImage as? UIImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.profileImage.image = selectedImage
            self.uploadProfileImageToDataBase(selectedImage: selectedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadProfileImageToDataBase(selectedImage: UIImage) {
        if let uid = Auth.auth().currentUser?.uid {
            let storageRef = Storage.storage().reference().child("profile_images").child("\(uid).jpg")
            if let imageUpload = UIImageJPEGRepresentation(selectedImage, 0.1) {
                storageRef.putData(imageUpload, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        self.registerUserImageToDatabaseWithUID(uid: uid, profileImageURL: profileImageURL)
                    }
                })
            }
        }
    }
    
    private func registerUserImageToDatabaseWithUID(uid: String, profileImageURL: String) {
        let userRef = databaseRef.child("Users").child(uid)
        userRef.child("ProfileImageURL").setValue(profileImageURL)
    }
    
    func pullImageFromDatabase() {
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

}
