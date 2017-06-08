//
//  TabBarController.swift
//  MyCaddie
//
//  Created by Kevin Liao on 6/7/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToTabMenu(segue: UIStoryboardSegue) {}
    
    
}
