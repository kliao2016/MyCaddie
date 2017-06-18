//
//  StatsViewController.swift
//  
//
//  Created by Weston Mauz on 6/17/17.
//
//

import UIKit

class StatsViewController: UIViewController {
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
