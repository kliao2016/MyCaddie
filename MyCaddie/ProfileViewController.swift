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
import GoogleSignIn

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    var databaseRef = Database.database().reference()

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBAction func updatePicture(_ sender: Any) {
        handleSelectProfileImage()
    }
    @IBOutlet weak var profileTableView: UITableView!
    
    
    let welcomeLabel = CATextLayer()
    let welcomeLabel2 = CATextLayer()
    let welcomeLabel3 = CATextLayer()
    let welcomeLabel4 = CATextLayer()
    
    // Lifetime Stats
    var lifetimePutts = 0
    var lifetimeScore = 0
    var handicap = "N-A"
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileTableView.rowHeight = self.profileTableView.frame.size.height / 5
        
        sideMenus()
        customizeNavBar()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        let uid = Auth.auth().currentUser?.uid
        let lifetimeRef = self.ref.child("Users").child(uid!).child("Lifetime Stats")
        
        retrieveStats(lifetimeRef: lifetimeRef)
        
        // Background
        let back = CGRect(x: 0, y: 0, width: 500, height: 800)
        let ground = profileBackground(frame: back)
        //view.addSubview(ground)
        view.insertSubview(ground, at: 0)
        ground.layer.shouldRasterize = false
        
        drawStatLabels()
        
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
                    self.userName.textColor = UIColor.white
                }
            }, withCancel: nil)
        }
    }
    
    func retrieveStats(lifetimeRef: DatabaseReference) {
        lifetimeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.lifetimeScore = dictionary["Score"] as! Int
                self.lifetimePutts = dictionary["Putts"] as! Int
                
                // Drawing Circles and Stats
                
                // Low Left Stat
                let rect0 = CGRect(x: 30, y: 350, width: 75, height: 75)
                let cp0 = TextOnProfile(frame: rect0, stat: String(self.lifetimeScore))
                self.view.addSubview(cp0)
                
                // Low Right Stat
                let rect2 = CGRect(x: 278, y: 350, width: 75, height: 75)
                let cp2 = TextOnProfile(frame: rect2, stat: String(self.lifetimePutts))
                self.view.addSubview(cp2)
                
                self.drawStatLabels()
            }
        }, withCancel: nil)
        let uid = Auth.auth().currentUser?.uid
        let profileRef = self.ref.child("Users").child(uid!)
        profileRef.observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let dictionary2 = DataSnapshot.value as? [String: AnyObject] {
                self.handicap = dictionary2["Handicap"] as! String
                // Low Middle Stat
                let rect1 = CGRect(x: 145, y: 350, width: 85, height: 75)
                let cp1 = TextOnProfile(frame: rect1, stat: String(self.handicap))
                self.view.addSubview(cp1)
            }
        })
    }
    
    // Table View functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var profileCell = profileTableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileTableViewCell
        if indexPath.row == 1 {
            profileCell.profileCellLabel.text = "My Stats"
            profileCell.profileCellImage.image = UIImage(named: "icons8-Statistics-50 (2)")
            profileCell.contentView.backgroundColor = UIColor(colorLiteralRed: 51/255, green: 51/255, blue: 51/255, alpha: 1)
            profileCell.backgroundColor = UIColor(colorLiteralRed: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        }
        if indexPath.row == 2 {
            profileCell.profileCellLabel.text = "My Rounds"
            profileCell.profileCellImage.image = UIImage(named: "icons8-Golf Bag-50 (1)")
        }
        if indexPath.row == 3 {
            profileCell.profileCellLabel.text = "Settings"
            profileCell.profileCellImage.image = UIImage(named: "icons8-Vertical Settings Mixer-50 (2)")
            profileCell.contentView.backgroundColor = UIColor(colorLiteralRed: 51/255, green: 51/255, blue: 51/255, alpha: 1)
            profileCell.backgroundColor = UIColor(colorLiteralRed: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        }
        if indexPath.row == 4 {
            profileCell.profileCellLabel.text = "Log Out"
            profileCell.profileCellImage.image = UIImage(named: "icons8-Trekking-50 (2)")
        }
        return profileCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "profileToNewRoundSegue", sender: self)
        } else if indexPath.row == 1 {
            self.performSegue(withIdentifier: "profileToStatsSegue", sender: self)
        } else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "profileToMyCoursesSegue", sender: self)
        } else if indexPath.row == 3 {
            self.performSegue(withIdentifier: "profileToSettingsSegue", sender: self)
        } else {
            handleLogout()
        }
    }
    
    func handleLogout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        GIDSignIn.sharedInstance().signOut()
        
        self.performSegue(withIdentifier: "unwindToLoginFromProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToNewRoundSegue" {
            let destinationVC = segue.destination as! CourseDatabaseViewController
            destinationVC.navigationItem.title = "Choose a Course"
        }
    }
    
    func drawStats(){
//        //Low Left Stat
//        let rect0 = CGRect(x: 30, y: 350, width: 75, height: 75)
//        let cp0 = TextOnProfile(frame: rect0, stat: self.s)
//        self.view.addSubview(cp0)
//        
//        // Low Middle Stat
//        let rect1 = CGRect(x: 150, y: 350, width: 75, height: 75)
//        //let cp0 = TextOnProfile(frame: rect0, stat: "\(self.lifetimeScore)")
//        let cp1 = TextOnProfile(frame: rect1, stat: self.s2)
//        self.view.addSubview(cp1)
//        
//        // Low Right Stat
//        let rect2 = CGRect(x: 278, y: 350, width: 75, height: 75)
//        //let cp0 = TextOnProfile(frame: rect0, stat: "\(self.lifetimeScore)")
//        let cp2 = TextOnProfile(frame: rect2, stat: self.s3)
//        self.view.addSubview(cp2)
    }
    
    func drawStatLabels(){
        //Welcome Label
        welcomeLabel.contentsScale = UIScreen.main.scale
        welcomeLabel2.contentsScale = UIScreen.main.scale
        welcomeLabel3.contentsScale = UIScreen.main.scale
        
        // Low Left Text
        
        let lowLeft = CGRect(x: 20, y: 410, width: 140, height: 20)
        let place1 = UIView(frame: lowLeft)
        view.addSubview(place1)
        
        welcomeLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 20)
        welcomeLabel.fontSize = 14
        welcomeLabel.alignmentMode = kCAAlignmentCenter
        welcomeLabel.foregroundColor = UIColor.white.cgColor
        welcomeLabel.alignmentMode = kCAAlignmentLeft
        welcomeLabel.contentsScale = UIScreen.main.scale
        place1.layer.shouldRasterize = false
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        welcomeLabel.add(animation, forKey: nil)
        
        // Low Middle Text
        
        let lowMiddle = CGRect(x: 156, y: 410, width: 140, height: 20)
        let place2 = UIView(frame: lowMiddle)
        view.addSubview(place2)
        
        welcomeLabel2.frame = CGRect(x: 0, y: 0, width: 140, height: 20)
        welcomeLabel2.fontSize = 14
        welcomeLabel2.alignmentMode = kCAAlignmentCenter
        welcomeLabel2.foregroundColor = UIColor.white.cgColor
        welcomeLabel2.alignmentMode = kCAAlignmentLeft
        welcomeLabel2.add(animation, forKey: nil)
        // Blurriness Fix
        welcomeLabel2.contentsScale = UIScreen.main.scale
        place2.layer.shouldRasterize = false
        
        //Low Right Text
        
        let lowRight = CGRect(x: 275, y: 410, width: 140, height: 20)
        let place3 = UIView(frame: lowRight)
        view.addSubview(place3)
        
        welcomeLabel3.frame = CGRect(x: 0, y: 0, width: 140, height: 20)
        welcomeLabel3.fontSize = 14
        welcomeLabel3.alignmentMode = kCAAlignmentCenter
        welcomeLabel3.foregroundColor = UIColor.white.cgColor
        welcomeLabel3.alignmentMode = kCAAlignmentLeft
        welcomeLabel3.add(animation, forKey: nil)
        
        welcomeLabel.string = "All-time Score"
        welcomeLabel2.string = "Handicap"
        welcomeLabel3.string = "Lifetime Putts"
        
        place1.layer.addSublayer(welcomeLabel)
        place2.layer.addSublayer(welcomeLabel2)
        place3.layer.addSublayer(welcomeLabel3)
    }
    
}
