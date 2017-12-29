//
//  SettingsTableViewController.swift
//  MyCaddie
//
//  Created by Weston Mauz on 8/4/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase
import GoogleSignIn

class SettingsTableViewController: UITableViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var settingsView: UIView!
    
    var databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()
        customizeNavBar()
        
        loadEmail()
        
        self.settingsView.frame.size.height = self.tableView.frame.size.height / 4
        
        loadProfileImage()
    }
    
    override func viewDidLayoutSubviews() {
        self.profileImage.contentMode = .scaleAspectFill
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            updateName()
        }
        if indexPath.row == 2 && indexPath.section != 1 {
            updatePassword()
        }
        if indexPath.row == 3 {
            updateHandicap()
        }
    }
    
    func updateName() {
        
        let uid = Auth.auth().currentUser?.uid
        let userReference = Database.database().reference().child("Users").child(uid!).child("Name")
        
        let promptPopUp = UIAlertController(title: "Update Name", message: nil, preferredStyle: .alert)
        
        promptPopUp.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [promptPopUp] (_) in
            
            promptPopUp.dismiss(animated: true, completion: nil)
            let textField = promptPopUp.textFields?[0]
            let actualText = String((textField?.text)!)
            userReference.setValue(actualText)

        }))
        promptPopUp.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [promptPopUp] (_) in
            promptPopUp.dismiss(animated: true, completion: nil)
            print("Not updating name Bro")
        }))
        
        promptPopUp.addTextField { (textField) in
            textField.keyboardType = UIKeyboardType.alphabet
            textField.text = nil
        }
        
        self.present(promptPopUp, animated: true, completion: nil)
    }
    
    func updatePassword(){
        
        let uid = Auth.auth().currentUser?.uid
        let userReference = Database.database().reference().child("Users").child(uid!).child("Password")
        
        let promptPopUp = UIAlertController(title: "Update Password", message: nil, preferredStyle: .alert)
        
        promptPopUp.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [promptPopUp] (_) in
            
            promptPopUp.dismiss(animated: true, completion: nil)
            let textField = promptPopUp.textFields?[0]
            let actualText = String((textField?.text)!)
            userReference.setValue(actualText)
            
        }))
        promptPopUp.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [promptPopUp] (_) in
            promptPopUp.dismiss(animated: true, completion: nil)
        }))
        
        promptPopUp.addTextField { (textField) in
            textField.keyboardType = UIKeyboardType.alphabet
            textField.text = nil
        }
        
        self.present(promptPopUp, animated: true, completion: nil)
    }
    
    func updateHandicap() {
        
        let uid = Auth.auth().currentUser?.uid
        let userReference = Database.database().reference().child("Users").child(uid!).child("Handicap")
        
        let promptPopUp = UIAlertController(title: "Update Handicap", message: nil, preferredStyle: .alert)
        
        promptPopUp.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [promptPopUp] (_) in
            
            promptPopUp.dismiss(animated: true, completion: nil)
            promptPopUp.dismiss(animated: true, completion: nil)
            let textField = promptPopUp.textFields?[0]
            let actualText = String((textField?.text)!)
            userReference.setValue(actualText)
            
        }))
        promptPopUp.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [promptPopUp] (_) in
            promptPopUp.dismiss(animated: true, completion: nil)
        }))
        
        promptPopUp.addTextField { (textField) in
            textField.keyboardType = UIKeyboardType.alphabet
            textField.text = nil
        }
        
        self.present(promptPopUp, animated: true, completion: nil)
    }
    
    func loadEmail() {
        let uid = Auth.auth().currentUser?.uid
        let user = databaseRef.child("Users").child(uid!)
        user.observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String: AnyObject]
                self.userEmail.text = dictionary?["Email"] as? String
            }, withCancel: nil)
    }
    
    func sideMenus(){
        
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
    
    func customizeNavBar(){
        navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0/255, green: 128/255, blue: 64/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func loadProfileImage() {
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
