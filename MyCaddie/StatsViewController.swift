//
//  StatsViewController.swift
//  
//
//  Created by Weston Mauz on 6/17/17.
//
//

import UIKit

class StatsViewController: UIViewController {
    
    var roundData : roundStatData?
    
    
    var courseName = ""
    var tees = ""
    var scoreInt = -1
    
    // Lifetime Stats
    var FBunkers = ""
    var GBunkers = ""
    var Hazards = ""
    var OBs = ""
    var Rights = ""
    var Lefts = ""
    var Fringes = ""
    var Fairways = ""
    var Greens = ""
    var Putts = ""
    var Score = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (roundData?.cName != nil) {
            Score = String((roundData?.score)!)
            Fairways = String((roundData?.fairways)!)
            Greens = String((roundData?.greens)!)
            Putts = String((roundData?.putts)!)
            Fringes = String((roundData?.fringes)!)
            Hazards = String((roundData?.hazards)!)
            Lefts = String((roundData?.left)!)
            Rights = String((roundData?.right)!)
            FBunkers = String((roundData?.fbunkers)!)
            GBunkers = String((roundData?.gbunkers)!)
            OBs = String((roundData?.obs)!)
        }
        
        let when = DispatchTime.now() + 0.2 // change 2 to desired number of seconds
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            
        // Row Labels
            
        let label00 = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 21))
        label00.center = CGPoint(x: 190, y: 215)
        label00.textAlignment = .center
        label00.text = "Penalties"
        label00.textColor = UIColor.green
        self.view.addSubview(label00)
            
        let labelX = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 21))
        labelX.center = CGPoint(x: 190, y: 355)
        labelX.textAlignment = .center
        labelX.text = "Scoring"
        labelX.textColor = UIColor.green
        self.view.addSubview(labelX)
            
        let labelY = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 21))
        labelY.center = CGPoint(x: 190, y: 495)
        labelY.textAlignment = .center
        labelY.text = "Driving"
        labelY.textColor = UIColor.green
        self.view.addSubview(labelY)
            
        // Top Top Left
        let rect0 = CGRect(x: 134, y: 75, width: 110, height: 110)
        let cp0 = CirclePath5(frame: rect0, stat: self.Score)
        self.view.addSubview(cp0)
        
        let label0 = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 21))
        label0.center = CGPoint(x: 190, y: 182)
        label0.textAlignment = .center
        label0.text = "Score"
        label0.textColor = UIColor.white
        self.view.addSubview(label0)
        
        // Top Left
        let rect = CGRect(x: 25, y: 235, width: 80, height: 80)
        let cp = CirclePath(frame: rect, stat: self.OBs)
        self.view.addSubview(cp)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
        label.center = CGPoint(x: 63, y: 315)
        label.textAlignment = .center
        label.text = "OBs"
        label.textColor = UIColor.white
        self.view.addSubview(label)
        
        // Top Middle
        let rect2 = CGRect(x: 150, y: 235, width: 80, height: 80)
        let cp2 = CirclePath(frame: rect2, stat: self.Fairways)
        self.view.addSubview(cp2)
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
        label2.center = CGPoint(x: 192, y: 315)
        label2.textAlignment = .center
        label2.text = "FIR"
        label2.textColor = UIColor.white
        self.view.addSubview(label2)
        
        // Top Right
        let rect3 = CGRect(x: 275, y: 235, width: 80, height: 80)
        let cp3 = CirclePath(frame: rect3, stat: self.Greens)
        self.view.addSubview(cp3)
        
        let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
        label3.center = CGPoint(x: 315, y: 315)
        label3.textAlignment = .center
        label3.text = "GIR"
        label3.textColor = UIColor.white
        self.view.addSubview(label3)
        
        // Middle Left
        let rect4 = CGRect(x: 25, y: 375, width: 80, height: 80)
        let cp4 = CirclePath2(frame: rect4, stat: self.Lefts)
        self.view.addSubview(cp4)
        
        let label4 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label4.center = CGPoint(x: 63, y: 460)
        label4.textAlignment = .center
        label4.text = "Lefts"
        label4.textColor = UIColor.white
        self.view.addSubview(label4)
        
        // Middle Middle
        let rect5 = CGRect(x: 150, y: 375, width: 80, height: 80)
        let cp5 = CirclePath2(frame: rect5, stat: self.Rights)
        self.view.addSubview(cp5)
        
        let label5 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label5.center = CGPoint(x: 192, y: 460)
        label5.textAlignment = .center
        label5.text = "Rights"
        label5.textColor = UIColor.white
        self.view.addSubview(label5)
        
        // Middle Right
        let rect6 = CGRect(x: 275, y: 375, width: 80, height: 80)
        let cp6 = CirclePath2(frame: rect6, stat: self.Fringes)
        self.view.addSubview(cp6)
        
        let label6 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label6.center = CGPoint(x: 315, y: 460)
        label6.textAlignment = .center
        label6.text = "Fringes"
        label6.textColor = UIColor.white
        self.view.addSubview(label6)
        
        // Botom Left
        let rect7 = CGRect(x: 25, y: 515, width: 80, height: 80)
        let cp7 = CirclePath3(frame: rect7, stat: self.FBunkers)
        self.view.addSubview(cp7)
        
        let label7 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label7.center = CGPoint(x: 63, y: 600)
        label7.textAlignment = .center
        label7.text = "FBunkers"
        label7.textColor = UIColor.white
        self.view.addSubview(label7)
        
        // Bottom Middle
        let rect8 = CGRect(x: 150, y: 515, width: 80, height: 80)
        let cp8 = CirclePath3(frame: rect8, stat: self.GBunkers)
        self.view.addSubview(cp8)
        
        let label8 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label8.center = CGPoint(x: 192, y: 600)
        label8.textAlignment = .center
        label8.text = "GBunkers"
        label8.textColor = UIColor.white
        self.view.addSubview(label8)
        
        // Bottom Right
        let rect9 = CGRect(x: 275, y: 515, width: 80, height: 80)
        let cp9 = CirclePath3(frame: rect9, stat: "44")
        self.view.addSubview(cp9)
        
        let label9 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label9.center = CGPoint(x: 315, y: 600)
        label9.textAlignment = .center
        label9.text = "GIR2"
        label9.textColor = UIColor.white
        self.view.addSubview(label9)
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
