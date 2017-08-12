//
//
//  MyStatsViewController2.swift
//  MyCaddie
//
//  Created by Kevin Liao on 8/12/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth

class MyStatsViewController2: UIViewController {
    
    weak var line1: CAShapeLayer?
    
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
        
        drawLine()
        
        let uid = Auth.auth().currentUser?.uid
        let lifetimeRef = self.ref.child("Users").child(uid!).child("Lifetime Stats")
        
        retrieveStats(lifetimeRef: lifetimeRef)
        
        // Background
        let back = CGRect(x: 0, y: 0, width: 500, height: 800)
        let ground = backgroundGradient(frame: back)
        view.addSubview(ground)
        
        let when = DispatchTime.now() + 0.2 // change 2 to desired number of seconds
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            
            // Row Labels
            
            let label00 = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 21))
            label00.center = CGPoint(x: 190, y: 245)
            label00.textAlignment = .center
            label00.text = "Scoring"
            label00.textColor = UIColor.init(red: 50/255, green: 150/255, blue: 100/255, alpha: 1)
            self.view.addSubview(label00)
            
            let labelX = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 21))
            labelX.center = CGPoint(x: 190, y: 380)
            labelX.textAlignment = .center
            labelX.text = "Driving"
            labelX.textColor = UIColor.init(red: 50/255, green: 150/255, blue: 100/255, alpha: 1)
            self.view.addSubview(labelX)
            
            let labelY = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 21))
            labelY.center = CGPoint(x: 190, y: 525)
            labelY.textAlignment = .center
            labelY.text = "Penalties"
            labelY.textColor = UIColor.init(red: 50/255, green: 150/255, blue: 100/255, alpha: 1)
            self.view.addSubview(labelY)
            
            // Top Top
            let rect0 = CGRect(x: 134, y: 100, width: 110, height: 110)
            let cp0 = CirclePath2(frame: rect0, stat: "\(self.lifetimeScore)")
            self.view.addSubview(cp0)
            
            let label0 = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 21))
            label0.center = CGPoint(x: 190, y: 200)
            label0.textAlignment = .center
            label0.text = "Strokes"
            label0.textColor = UIColor.white
            self.view.addSubview(label0)
            
            // Top Left
            let rect = CGRect(x: 25, y: 265, width: 80, height: 80)
            let cp = CirclePath2(frame: rect, stat: "\(self.lifetimePutts)")
            self.view.addSubview(cp)
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
            label.center = CGPoint(x: 63, y: 345)
            label.textAlignment = .center
            label.text = "Putts"
            label.textColor = UIColor.white
            self.view.addSubview(label)
            
            // Top Middle
            let rect2 = CGRect(x: 150, y: 265, width: 80, height: 80)
            let cp2 = CirclePath2(frame: rect2, stat: "\(self.lifetimeFairways)")
            self.view.addSubview(cp2)
            
            let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
            label2.center = CGPoint(x: 192, y: 345)
            label2.textAlignment = .center
            label2.text = "FIR"
            label2.textColor = UIColor.white
            self.view.addSubview(label2)
            
            // Top Right
            let rect3 = CGRect(x: 275, y: 265, width: 80, height: 80)
            let cp3 = CirclePath2(frame: rect3, stat: "\(self.lifetimeGreensInReg)")
            self.view.addSubview(cp3)
            
            let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
            label3.center = CGPoint(x: 315, y: 345)
            label3.textAlignment = .center
            label3.text = "GIR"
            label3.textColor = UIColor.white
            self.view.addSubview(label3)
            
            // Middle Left
            let rect4 = CGRect(x: 25, y: 400, width: 80, height: 80)
            let cp4 = CirclePath2(frame: rect4, stat: "\(self.lifetimeLefts)")
            self.view.addSubview(cp4)
            
            let label4 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
            label4.center = CGPoint(x: 63, y: 485)
            label4.textAlignment = .center
            label4.text = "Lefts"
            label4.textColor = UIColor.white
            self.view.addSubview(label4)
            
            // Middle Middle
            let rect5 = CGRect(x: 150, y: 400, width: 80, height: 80)
            let cp5 = CirclePath2(frame: rect5, stat: "\(self.lifetimeRights)")
            self.view.addSubview(cp5)
            
            let label5 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
            label5.center = CGPoint(x: 192, y: 485)
            label5.textAlignment = .center
            label5.text = "Rights"
            label5.textColor = UIColor.white
            self.view.addSubview(label5)
            
            // Middle Right
            let rect6 = CGRect(x: 275, y: 400, width: 80, height: 80)
            let cp6 = CirclePath2(frame: rect6, stat: "\(self.lifetimeFairwayBunkers)")
            self.view.addSubview(cp6)
            
            let label6 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
            label6.center = CGPoint(x: 315, y: 485)
            label6.textAlignment = .center
            label6.text = "FBunkers"
            label6.textColor = UIColor.white
            self.view.addSubview(label6)
            
            // Botom Left
            let rect7 = CGRect(x: 25, y: 545, width: 80, height: 80)
            let cp7 = CirclePath2(frame: rect7, stat: "\(self.lifetimeGreenBunkers)")
            self.view.addSubview(cp7)
            
            let label7 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
            label7.center = CGPoint(x: 63, y: 630)
            label7.textAlignment = .center
            label7.text = "GBunkers"
            label7.textColor = UIColor.white
            self.view.addSubview(label7)
            
            // Bottom Middle
            let rect8 = CGRect(x: 150, y: 545, width: 80, height: 80)
            let cp8 = CirclePath2(frame: rect8, stat: "\(self.lifetimeOBs)")
            self.view.addSubview(cp8)
            
            let label8 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
            label8.center = CGPoint(x: 192, y: 630)
            label8.textAlignment = .center
            label8.text = "OBs"
            label8.textColor = UIColor.white
            self.view.addSubview(label8)
            
            // Bottom Right
            let rect9 = CGRect(x: 275, y: 545, width: 80, height: 80)
            let cp9 = CirclePath2(frame: rect9, stat: "\(self.lifetimeHazards)")
            self.view.addSubview(cp9)
            
            let label9 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
            label9.center = CGPoint(x: 315, y: 630)
            label9.textAlignment = .center
            label9.text = "Hazards"
            label9.textColor = UIColor.white
            self.view.addSubview(label9)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func drawLine(){
        //self.line1?.removeFromSuperlayer()
        
        // create whatever path you want
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 140, y: 245))
        path.addLine(to: CGPoint(x: 0, y: 245))
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 240, y: 245))
        path2.addLine(to: CGPoint(x: 380, y: 245))
        
        // Second Set of Paths
        
        let path3 = UIBezierPath()
        path3.move(to: CGPoint(x: 140, y: 380))
        path3.addLine(to: CGPoint(x: 0, y: 380))
        
        let path4 = UIBezierPath()
        path4.move(to: CGPoint(x: 240, y: 380))
        path4.addLine(to: CGPoint(x: 380, y: 380))
        
        // Third Set
        
        let path5 = UIBezierPath()
        path5.move(to: CGPoint(x: 140, y: 525))
        path5.addLine(to: CGPoint(x: 0, y: 525))
        
        let path6 = UIBezierPath()
        path6.move(to: CGPoint(x: 240, y: 525))
        path6.addLine(to: CGPoint(x: 380, y: 525))
        
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
    
}

