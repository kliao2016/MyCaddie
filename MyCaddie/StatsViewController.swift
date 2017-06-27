//
//  StatsViewController.swift
//  
//
//  Created by Weston Mauz on 6/17/17.
//
//

import UIKit

class StatsViewController: UIViewController {
    
    var scoreStr = ""
    var fairwaysStr = ""
    var greensStr = ""
    var puttsStr = ""
    var fringesStr = ""
    var hazardsStr = ""
    var leftStr = ""
    var rightStr = ""
    var fbunkersStr = ""
    var gbunkersStr = ""
    var obsStr = ""
    
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
        // Do any additional setup after loading the view, typically from a nib.
        
        score.text = scoreStr
        fairways.text = fairwaysStr
        greens.text = greensStr
        putts.text = puttsStr
        fringes.text = fringesStr
        hazards.text = hazardsStr
        left.text = leftStr
        right.text = rightStr
        fbunkers.text = fbunkersStr
        gbunkers.text = gbunkersStr
        obs.text = obsStr
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
