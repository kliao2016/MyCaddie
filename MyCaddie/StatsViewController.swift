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
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var fairways: UILabel!
    @IBOutlet weak var greens: UILabel!
    @IBOutlet weak var putts: UILabel!
    @IBOutlet weak var fringes: UILabel!
    @IBOutlet weak var hazards: UILabel!
    @IBOutlet weak var left: UILabel!
    @IBOutlet weak var right: UILabel!
    @IBOutlet weak var fbunkers: UILabel!
    @IBOutlet weak var gbunkers: UILabel!
    @IBOutlet weak var obs: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (roundData?.cName != nil) {
            score.text = String((roundData?.score)!)
            fairways.text = String((roundData?.fairways)!)
            greens.text = String((roundData?.greens)!)
            putts.text = String((roundData?.putts)!)
            fringes.text = String((roundData?.fringes)!)
            hazards.text = String((roundData?.hazards)!)
            left.text = String((roundData?.left)!)
            right.text = String((roundData?.right)!)
            fbunkers.text = String((roundData?.fbunkers)!)
            gbunkers.text = String((roundData?.gbunkers)!)
            obs.text = String((roundData?.obs)!)
        }
        else {
            print("OH NOOO")
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
