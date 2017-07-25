//
//  MyStatsViewController.swift
//  MyCaddie
//
//  Created by Weston Mauz on 7/19/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class MyStatsViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var alertButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()
        customizeNavBar()
        
        let rect = CGRect(x: 115, y: 100, width: 120, height: 120)
        let rect2 = CGRect(x: 115, y: 200, width: 120, height: 120)
        let cp = CirclePath(frame: rect)
        let cp2 = CirclePath(frame: rect2)
        view.addSubview(cp)
        view.addSubview(cp2)
        
        
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
            
            alertButton.target = revealViewController()
            alertButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func customizeNavBar(){
        navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0/255, green: 128/255, blue: 64/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }

}
