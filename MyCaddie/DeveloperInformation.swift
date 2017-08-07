//
//  Developer Information.swift
//  MyCaddie
//
//  Created by Weston Mauz on 8/6/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class DeveloperInformation: UIViewController {
    
    @IBAction func suchar(_ sender: Any) {
        let url = URL(string: "https://goo.gl/Dxqntx")
        UIApplication.shared.open(url!, options: [:])
    }
    
    @IBAction func icons8(_ sender: Any) {
        let url2 = URL(string: "https://goo.gl/9aonRT")
        UIApplication.shared.open(url2!, options: [:])
    }
    
    @IBAction func mitchellHudson(_ sender: Any) {
        let url3 = URL(string: "https://goo.gl/EG2aay")
        UIApplication.shared.open(url3!, options: [:])
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
