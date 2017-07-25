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
        
        // Top Top Left
        let rect0 = CGRect(x: 70, y: 75, width: 110, height: 110)
        let cp0 = CirclePath(frame: rect0)
        view.addSubview(cp0)
        
        // Top Top Right
        let rect00 = CGRect(x: 195, y: 75, width: 110, height: 110)
        let cp00 = CirclePath(frame: rect00)
        view.addSubview(cp00)
        
        // Top Left
        let rect = CGRect(x: 25, y: 200, width: 80, height: 80)
        let cp = CirclePath(frame: rect)
        view.addSubview(cp)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
        label.center = CGPoint(x: 63, y: 285)
        label.textAlignment = .center
        label.text = "Putts"
        label.textColor = UIColor.white
        self.view.addSubview(label)
        
        // Top Middle
        let rect2 = CGRect(x: 150, y: 200, width: 80, height: 80)
        let cp2 = CirclePath(frame: rect2)
        view.addSubview(cp2)
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
        label2.center = CGPoint(x: 192, y: 285)
        label2.textAlignment = .center
        label2.text = "FIR"
        label2.textColor = UIColor.white
        self.view.addSubview(label2)
        
        // Top Right
        let rect3 = CGRect(x: 275, y: 200, width: 80, height: 80)
        let cp3 = CirclePath(frame: rect3)
        view.addSubview(cp3)
        
        let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
        label3.center = CGPoint(x: 315, y: 285)
        label3.textAlignment = .center
        label3.text = "GIR"
        label3.textColor = UIColor.white
        self.view.addSubview(label3)
        
        // Middle Left
        let rect4 = CGRect(x: 25, y: 325, width: 80, height: 80)
        let cp4 = CirclePath(frame: rect4)
        view.addSubview(cp4)
        
        let label4 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label4.center = CGPoint(x: 63, y: 410)
        label4.textAlignment = .center
        label4.text = "Par 3 Ave."
        label4.textColor = UIColor.white
        self.view.addSubview(label4)
        
        // Middle Middle
        let rect5 = CGRect(x: 150, y: 325, width: 80, height: 80)
        let cp5 = CirclePath(frame: rect5)
        view.addSubview(cp5)
        
        let label5 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label5.center = CGPoint(x: 192, y: 410)
        label5.textAlignment = .center
        label5.text = "Par 4 Ave."
        label5.textColor = UIColor.white
        self.view.addSubview(label5)
        
        // Middle Right
        let rect6 = CGRect(x: 275, y: 325, width: 80, height: 80)
        let cp6 = CirclePath(frame: rect6)
        view.addSubview(cp6)
        
        let label6 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        label6.center = CGPoint(x: 315, y: 410)
        label6.textAlignment = .center
        label6.text = "Par 5 Ave."
        label6.textColor = UIColor.white
        self.view.addSubview(label6)
        
        // Botom Left
        let rect7 = CGRect(x: 25, y: 450, width: 80, height: 80)
        let cp7 = CirclePath(frame: rect7)
        view.addSubview(cp7)
        
        // Bottom Middle
        let rect8 = CGRect(x: 150, y: 450, width: 80, height: 80)
        let cp8 = CirclePath(frame: rect8)
        view.addSubview(cp8)
        
        // Bottom Right
        let rect9 = CGRect(x: 275, y: 450, width: 80, height: 80)
        let cp9 = CirclePath(frame: rect9)
        view.addSubview(cp9)
        
        // Super Botom Left
        let rect10 = CGRect(x: 25, y: 575, width: 80, height: 80)
        let cp10 = CirclePath(frame: rect10)
        view.addSubview(cp10)
        
        // Super Bottom Middle
        let rect11 = CGRect(x: 150, y: 575, width: 80, height: 80)
        let cp11 = CirclePath(frame: rect11)
        view.addSubview(cp11)
        
        // Super Bottom Right
        let rect12 = CGRect(x: 275, y: 575, width: 80, height: 80)
        let cp12 = CirclePath(frame: rect12)
        view.addSubview(cp12)
        
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
