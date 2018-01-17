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
    
    weak var line1: CAShapeLayer?

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var defaultText: UILabel!
    
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
        
        // Side Bar Functionality
        sideMenus()
        customizeNavBar()
        
        // Database References
        let uid = Auth.auth().currentUser?.uid
        let lifetimeRef = self.ref.child("Users").child(uid!).child("Lifetime Stats")
        
        // Retrieve Stats
        retrieveStats(lifetimeRef: lifetimeRef)
        
        let xcoord = self.view.frame.size.width
        let ycoord = self.view.frame.size.height
        
        // Background
        let back = CGRect(x: 0, y: 0, width: xcoord, height: ycoord)
        let ground = backgroundGradient(frame: back)
        view.addSubview(ground)
        
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
            
            //alertButton.target = revealViewController()
            //alertButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func customizeNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 128/255, blue: 64/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func retrieveStats(lifetimeRef: DatabaseReference) {
        lifetimeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.defaultText.text = ""
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
                
                // Section Lines and Labels
                self.drawLine()
                self.drawSectionLabels()

                let when = DispatchTime.now() + 0.5
                
                DispatchQueue.main.asyncAfter(deadline: when) {
                    // Stat Circles
                    self.drawStats()
                }
            }
        }, withCancel: nil)
    }
    
    func drawLine() {
        //self.line1?.removeFromSuperlayer()
        
        // create whatever path you want
        
        let xcoord = self.view.frame.size.width
        let ycoord = self.view.frame.size.height
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: (xcoord / 2) - 50, y: ycoord - (ycoord * 5 / 8)))
        path.addLine(to: CGPoint(x: 0, y: ycoord - (ycoord * 5 / 8)))
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: (xcoord / 2) + 50, y: ycoord - (ycoord * 5 / 8)))
        path2.addLine(to: CGPoint(x: xcoord, y: ycoord - (ycoord * 5 / 8)))
        
        // Second Set of Paths
        
        let path3 = UIBezierPath()
        path3.move(to: CGPoint(x: (xcoord / 2) - 50, y: ycoord - (ycoord * 5 / 12)))
        path3.addLine(to: CGPoint(x: 0, y: ycoord - (ycoord * 5 / 12)))
        
        let path4 = UIBezierPath()
        path4.move(to: CGPoint(x: (xcoord / 2) + 50, y: ycoord - (ycoord * 5 / 12)))
        path4.addLine(to: CGPoint(x: xcoord, y: ycoord - (ycoord * 5 / 12)))
        
        // Third Set
        
        let path5 = UIBezierPath()
        path5.move(to: CGPoint(x: (xcoord / 2) - 50, y: ycoord - (ycoord * 5 / 24)))
        path5.addLine(to: CGPoint(x: 0, y: ycoord - (ycoord * 5 / 24)))
        
        let path6 = UIBezierPath()
        path6.move(to: CGPoint(x: (xcoord / 2) + 50, y: ycoord - (ycoord * 5 / 24)))
        path6.addLine(to: CGPoint(x: xcoord, y: ycoord - (ycoord * 5 / 24)))
        
        // create shape layer for that path
        
        let line1 = CAShapeLayer()
        line1.fillColor = UIColor.clear.cgColor
        line1.strokeColor = UIColor.init(red: 30/255, green: 150/255, blue: 100/255, alpha: 1).cgColor
        line1.lineWidth = 4
        line1.path = path.cgPath
        
        let line2 = CAShapeLayer()
        line2.fillColor = UIColor.clear.cgColor
        line2.strokeColor = UIColor.init(red: 30/255, green: 150/255, blue: 100/255, alpha: 1).cgColor
        line2.lineWidth = 4
        line2.path = path2.cgPath
        
        // Second Set of Lines
        
        let line3 = CAShapeLayer()
        line3.fillColor = UIColor.clear.cgColor
        line3.strokeColor = UIColor.init(red: 30/255, green: 150/255, blue: 100/255, alpha: 1).cgColor
        line3.lineWidth = 4
        line3.path = path3.cgPath
        
        let line4 = CAShapeLayer()
        line4.fillColor = UIColor.clear.cgColor
        line4.strokeColor = UIColor.init(red: 30/255, green: 150/255, blue: 100/255, alpha: 1).cgColor
        line4.lineWidth = 4
        line4.path = path4.cgPath
        
        // Third Set
        
        let line5 = CAShapeLayer()
        line5.fillColor = UIColor.clear.cgColor
        line5.strokeColor = UIColor.init(red: 30/255, green: 150/255, blue: 100/255, alpha: 1).cgColor
        line5.lineWidth = 4
        line5.path = path5.cgPath
        
        let line6 = CAShapeLayer()
        line6.fillColor = UIColor.clear.cgColor
        line6.strokeColor = UIColor.init(red: 30/255, green: 150/255, blue: 100/255, alpha: 1).cgColor
        line6.lineWidth = 4
        line6.path = path6.cgPath
        
        // animate it
        
        view.layer.addSublayer(line1)
        view.layer.addSublayer(line2)
        view.layer.addSublayer(line3)
        view.layer.addSublayer(line4)
        view.layer.addSublayer(line5)
        view.layer.addSublayer(line6)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 1
        line1.add(animation, forKey: "MyAnimation")
        line2.add(animation, forKey: nil)
        line3.add(animation, forKey: nil)
        line4.add(animation, forKey: nil)
        line5.add(animation, forKey: nil)
        line6.add(animation, forKey: nil)
        
        
        // save shape layer
        
        self.line1 = line1
    }
    
    func drawSectionLabels() {
        let xcoord = self.view.frame.size.width
        let ycoord = self.view.frame.size.height
        
        let label00 = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 21))
        label00.center = CGPoint(x: xcoord / 2, y: ycoord - (ycoord * 5 / 8))
        label00.textAlignment = .center
        label00.text = "Scoring"
        label00.textColor = UIColor.init(red: 50/255, green: 150/255, blue: 100/255, alpha: 1)
        self.view.addSubview(label00)
        
        let labelX = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 21))
        labelX.center = CGPoint(x: xcoord / 2, y: ycoord - (ycoord * 5 / 12))
        labelX.textAlignment = .center
        labelX.text = "Driving"
        labelX.textColor = UIColor.init(red: 50/255, green: 150/255, blue: 100/255, alpha: 1)
        self.view.addSubview(labelX)
        
        let labelY = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 21))
        labelY.center = CGPoint(x: xcoord / 2, y: ycoord - (ycoord * 5 / 24))
        labelY.textAlignment = .center
        labelY.text = "Penalties"
        labelY.textColor = UIColor.init(red: 50/255, green: 150/255, blue: 100/255, alpha: 1)
        self.view.addSubview(labelY)
    }
    
    func drawStats() {
        let xcoord = self.view.frame.size.width
        let ycoord = self.view.frame.size.height
        //        let topheight = self.navigationController?.navigationBar.frame.size.height + [UIApplication .]
        let topheight = (self.navigationController?.navigationBar.frame.size.height)! + 20
        
        
        // Top Top
        let rect0 = CGRect(x: (xcoord / 2) - 55, y: (ycoord - (ycoord * 5 / 8) - topheight) / 2, width: 110, height: 110)
        let cp0 = CirclePath2(frame: rect0, stat: "\(self.lifetimeScore)")
        self.view.addSubview(cp0)
        
        let label0 = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 21))
        label0.center = CGPoint(x: (xcoord / 2), y: (ycoord - (ycoord * 5 / 8) - topheight) / 2 + 110)
        label0.textAlignment = .center
        label0.text = "Strokes"
        label0.textColor = UIColor.white
        self.view.addSubview(label0)
        
        // Top Left
        let rect = CGRect(x: xcoord / 6 - 40, y: ycoord - (ycoord * 25 / 48) - 40, width: 80, height: 80)
        let cp = CirclePath2(frame: rect, stat: "\(self.lifetimePutts)")
        self.view.addSubview(cp)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
        label.center = CGPoint(x: xcoord / 6, y: ycoord - (ycoord * 25 / 48) - 40 + 80)
        label.textAlignment = .center
        label.text = "Putts"
        label.textColor = UIColor.white
        self.view.addSubview(label)
        
        // Top Middle
        let rect2 = CGRect(x: xcoord / 2 - 40, y: ycoord - (ycoord * 25 / 48) - 40, width: 80, height: 80)
        let cp2 = CirclePath2(frame: rect2, stat: "\(self.lifetimeFairways)")
        self.view.addSubview(cp2)
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
        label2.center = CGPoint(x: xcoord / 2, y: ycoord - (ycoord * 25 / 48) - 40 + 80)
        label2.textAlignment = .center
        label2.text = "FIR"
        label2.textColor = UIColor.white
        self.view.addSubview(label2)
        
        // Top Right
        let rect3 = CGRect(x: xcoord * 5 / 6 - 40, y: ycoord - (ycoord * 25 / 48) - 40, width: 80, height: 80)
        let cp3 = CirclePath2(frame: rect3, stat: "\(self.lifetimeGreensInReg)")
        self.view.addSubview(cp3)
        
        let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
        label3.center = CGPoint(x: xcoord * 5 / 6, y: ycoord - (ycoord * 25 / 48) - 40 + 80)
        label3.textAlignment = .center
        label3.text = "GIR"
        label3.textColor = UIColor.white
        self.view.addSubview(label3)
        
        // Middle Left
        let rect4 = CGRect(x: xcoord / 6 - 40, y: ycoord - (ycoord * 15 / 48) - 40, width: 80, height: 80)
        let cp4 = CirclePath2(frame: rect4, stat: "\(self.lifetimeLefts)")
        self.view.addSubview(cp4)
        
        let label4 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label4.center = CGPoint(x: xcoord / 6, y: ycoord - (ycoord * 15 / 48) - 40 + 80)
        label4.textAlignment = .center
        label4.text = "Lefts"
        label4.textColor = UIColor.white
        self.view.addSubview(label4)
        
        // Middle Middle
        let rect5 = CGRect(x: xcoord / 2 - 40, y: ycoord - (ycoord * 15 / 48) - 40, width: 80, height: 80)
        let cp5 = CirclePath2(frame: rect5, stat: "\(self.lifetimeRights)")
        self.view.addSubview(cp5)
        
        let label5 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label5.center = CGPoint(x: xcoord / 2, y: ycoord - (ycoord * 15 / 48) - 40 + 80)
        label5.textAlignment = .center
        label5.text = "Rights"
        label5.textColor = UIColor.white
        self.view.addSubview(label5)
        
        // Middle Right
        let rect6 = CGRect(x: xcoord * 5 / 6 - 40, y: ycoord - (ycoord * 15 / 48) - 40, width: 80, height: 80)
        let cp6 = CirclePath2(frame: rect6, stat: "\(self.lifetimeFairwayBunkers)")
        self.view.addSubview(cp6)
        
        let label6 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label6.center = CGPoint(x: xcoord * 5 / 6, y: ycoord - (ycoord * 15 / 48) - 40 + 80)
        label6.textAlignment = .center
        label6.text = "FBunkers"
        label6.textColor = UIColor.white
        self.view.addSubview(label6)
        
        // Botom Left
        let rect7 = CGRect(x: xcoord / 6 - 40, y: ycoord - (ycoord * 5 / 48) - 40, width: 80, height: 80)
        let cp7 = CirclePath2(frame: rect7, stat: "\(self.lifetimeGreenBunkers)")
        self.view.addSubview(cp7)
        
        let label7 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label7.center = CGPoint(x: xcoord / 6, y: ycoord - (ycoord * 5 / 48) - 40 + 80)
        label7.textAlignment = .center
        label7.text = "GBunkers"
        label7.textColor = UIColor.white
        self.view.addSubview(label7)
        
        // Bottom Middle
        let rect8 = CGRect(x: xcoord / 2 - 40, y: ycoord - (ycoord * 5 / 48) - 40, width: 80, height: 80)
        let cp8 = CirclePath2(frame: rect8, stat: "\(self.lifetimeOBs)")
        self.view.addSubview(cp8)
        
        let label8 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label8.center = CGPoint(x: xcoord / 2, y: ycoord - (ycoord * 5 / 48) - 40 + 80)
        label8.textAlignment = .center
        label8.text = "OBs"
        label8.textColor = UIColor.white
        self.view.addSubview(label8)
        
        // Bottom Right
        let rect9 = CGRect(x: xcoord * 5 / 6 - 40, y: ycoord - (ycoord * 5 / 48) - 40, width: 80, height: 80)
        let cp9 = CirclePath2(frame: rect9, stat: "\(self.lifetimeHazards)")
        self.view.addSubview(cp9)
        
        let label9 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label9.center = CGPoint(x: xcoord * 5 / 6, y: ycoord - (ycoord * 5 / 48) - 40 + 80)
        label9.textAlignment = .center
        label9.text = "Hazards"
        label9.textColor = UIColor.white
        self.view.addSubview(label9)
    }

}
