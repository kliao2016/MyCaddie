//
//  MyStatsViewController.swift
//  MyCaddie
//
//  Created by Weston Mauz on 7/19/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth

class MyStatsViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var alertButton: UIBarButtonItem!
    
    // Lifetime Stats
    var lifetimeFairwayBunkers = 0
    var lifetimeGreenBunkers = 0
    var lifetimeHazards = 0
    var lifetimeOBs = 0
    var lifetimeRights = 0
    var lifetimeLefts = 0
    var lifetimeFringes = 0
    var lifetimeFairways = 0
    var lifetimeGreensInReg = 0
    var lifetimePutts = 0
    var lifetimeScore = 0
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()
        customizeNavBar()
        
        let uid = Auth.auth().currentUser?.uid
        let lifetimeRef = self.ref.child("Users").child(uid!).child("Lifetime Stats")
        
        retrieveStats(lifetimeRef: lifetimeRef)
        
        // Background
        let back = CGRect(x: 0, y: 0, width: 500, height: 800)
        let ground = backgroundGradient(frame: back)
        view.addSubview(ground)
        
        let when = DispatchTime.now() + 0.2 // change 2 to desired number of seconds
        
        DispatchQueue.main.asyncAfter(deadline: when) {
        
        
        // Top Top Left
        let rect0 = CGRect(x: 75, y: 75, width: 100, height: 100)
        let cp0 = CirclePath5(frame: rect0, stat: "\(self.lifetimeScore)")
        self.view.addSubview(cp0)
        
        let label0 = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 21))
        label0.center = CGPoint(x: 127, y: 175)
        label0.textAlignment = .center
        label0.text = "Strokes"
        label0.textColor = UIColor.white
        self.view.addSubview(label0)
        
        // Top Top Right
        let rect00 = CGRect(x: 205, y: 75, width: 100, height: 100)
        let cp00 = CirclePath5(frame: rect00, stat: "\(self.lifetimePutts)")
        self.view.addSubview(cp00)
        
        let label00 = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 21))
        label00.center = CGPoint(x: 254, y: 175)
        label00.textAlignment = .center
        label00.text = "Putts"
        label00.textColor = UIColor.white
        self.view.addSubview(label00)
        
        // Top Left
        let rect = CGRect(x: 25, y: 200, width: 80, height: 80)
            let cp = CirclePath(frame: rect, stat: "\(self.lifetimeOBs)")
        self.view.addSubview(cp)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
        label.center = CGPoint(x: 63, y: 285)
        label.textAlignment = .center
        label.text = "OBs"
        label.textColor = UIColor.white
        self.view.addSubview(label)
        
        // Top Middle
        let rect2 = CGRect(x: 150, y: 200, width: 80, height: 80)
        let cp2 = CirclePath(frame: rect2, stat: "\(self.lifetimeFairways)")
        self.view.addSubview(cp2)
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
        label2.center = CGPoint(x: 192, y: 285)
        label2.textAlignment = .center
        label2.text = "FIR"
        label2.textColor = UIColor.white
        self.view.addSubview(label2)
        
        // Top Right
        let rect3 = CGRect(x: 275, y: 200, width: 80, height: 80)
        let cp3 = CirclePath(frame: rect3, stat: "\(self.lifetimeGreensInReg)")
        self.view.addSubview(cp3)
        
        let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
        label3.center = CGPoint(x: 315, y: 285)
        label3.textAlignment = .center
        label3.text = "GIR"
        label3.textColor = UIColor.white
        self.view.addSubview(label3)
        
        // Middle Left
        let rect4 = CGRect(x: 25, y: 315, width: 80, height: 80)
        let cp4 = CirclePath2(frame: rect4, stat: "\(self.lifetimeLefts)")
        self.view.addSubview(cp4)
        
        let label4 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label4.center = CGPoint(x: 63, y: 400)
        label4.textAlignment = .center
        label4.text = "Lefts"
        label4.textColor = UIColor.white
        self.view.addSubview(label4)
        
        // Middle Middle
        let rect5 = CGRect(x: 150, y: 315, width: 80, height: 80)
        let cp5 = CirclePath2(frame: rect5, stat: "\(self.lifetimeRights)")
        self.view.addSubview(cp5)
        
        let label5 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label5.center = CGPoint(x: 192, y: 400)
        label5.textAlignment = .center
        label5.text = "Rights"
        label5.textColor = UIColor.white
        self.view.addSubview(label5)
        
        // Middle Right
        let rect6 = CGRect(x: 275, y: 315, width: 80, height: 80)
        let cp6 = CirclePath2(frame: rect6, stat: "\(self.lifetimeFringes)")
        self.view.addSubview(cp6)
        
        let label6 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label6.center = CGPoint(x: 315, y: 400)
        label6.textAlignment = .center
        label6.text = "Fringes"
        label6.textColor = UIColor.white
        self.view.addSubview(label6)
        
        // Botom Left
        let rect7 = CGRect(x: 25, y: 430, width: 80, height: 80)
        let cp7 = CirclePath3(frame: rect7, stat: "\(self.lifetimeFairwayBunkers)")
        self.view.addSubview(cp7)
        
        let label7 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label7.center = CGPoint(x: 63, y: 515)
        label7.textAlignment = .center
        label7.text = "FBunkers"
        label7.textColor = UIColor.white
        self.view.addSubview(label7)
        
        // Bottom Middle
        let rect8 = CGRect(x: 150, y: 430, width: 80, height: 80)
        let cp8 = CirclePath3(frame: rect8, stat: "\(self.lifetimeGreenBunkers)")
        self.view.addSubview(cp8)
        
        let label8 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label8.center = CGPoint(x: 192, y: 515)
        label8.textAlignment = .center
        label8.text = "GBunkers"
        label8.textColor = UIColor.white
        self.view.addSubview(label8)
        
        // Bottom Right
        let rect9 = CGRect(x: 275, y: 430, width: 80, height: 80)
        let cp9 = CirclePath3(frame: rect9, stat: "\(self.lifetimeGreensInReg)")
        self.view.addSubview(cp9)
        
        let label9 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label9.center = CGPoint(x: 315, y: 515)
        label9.textAlignment = .center
        label9.text = "GIR2"
        label9.textColor = UIColor.white
        self.view.addSubview(label9)
        
        // Super Botom Left
        let rect10 = CGRect(x: 25, y: 545, width: 80, height: 80)
        let cp10 = CirclePath4(frame: rect10)
        self.view.addSubview(cp10)
        
        let label10 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label10.center = CGPoint(x: 63, y: 630)
        label10.textAlignment = .center
        label10.text = "Bogeys"
        label10.textColor = UIColor.white
        self.view.addSubview(label10)
        
        // Super Bottom Middle
        let rect11 = CGRect(x: 150, y: 545, width: 80, height: 80)
        let cp11 = CirclePath4(frame: rect11)
        self.view.addSubview(cp11)
        
        let label11 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label11.center = CGPoint(x: 192, y: 630)
        label11.textAlignment = .center
        label11.text = "Doubles"
        label11.textColor = UIColor.white
        self.view.addSubview(label11)
        
        // Super Bottom Right
        let rect12 = CGRect(x: 275, y: 545, width: 80, height: 80)
        let cp12 = CirclePath4(frame: rect12)
        self.view.addSubview(cp12)
        
        let label12 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label12.center = CGPoint(x: 315, y: 630)
        label12.textAlignment = .center
        label12.text = "Triples +"
        label12.textColor = UIColor.white
        self.view.addSubview(label12)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenus(){
        
        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            
            //alertButton.target = revealViewController()
            //alertButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            //view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func customizeNavBar(){
        navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0/255, green: 128/255, blue: 64/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func retrieveStats(lifetimeRef: DatabaseReference) {
        lifetimeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.lifetimeFairways = dictionary["Fairways"] as! Int
                self.lifetimeScore = dictionary["Score"] as! Int
                self.lifetimePutts = dictionary["Putts"] as! Int
                self.lifetimeGreensInReg = dictionary["Greens"] as! Int
                self.lifetimeFringes = dictionary["Fringes"] as! Int
                self.lifetimeLefts = dictionary["Lefts"] as! Int
                self.lifetimeRights = dictionary["Rights"] as! Int
                self.lifetimeHazards = dictionary["Hazards"] as! Int
                self.lifetimeOBs = dictionary["OBs"] as! Int
                self.lifetimeGreenBunkers = dictionary["Greenside Bunkers"] as! Int
                self.lifetimeFairwayBunkers = dictionary["Fairway Bunkers"] as! Int
            }
        }, withCancel: nil)
    }

}
