//
//  Developer Information.swift
//  MyCaddie
//
//  Created by Weston Mauz on 8/6/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class DeveloperInformation: UIViewController {
    
    @IBOutlet weak var kevPic: UIImageView!
    @IBOutlet weak var wesPic: UIImageView!
    
    
    @IBAction func skyGear(_ sender: Any) {
        let url = URL(string: "https://goo.gl/iVQFLk")
        UIApplication.shared.open(url!, options: [:])
    }
    
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
    
    @IBAction func webFonts(_ sender: Any) {
        let url3 = URL(string: "https://goo.gl/CKytv2")
        UIApplication.shared.open(url3!, options: [:])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DeveloperInformation.imageTapped(gesture:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(DeveloperInformation.imageTapped2(gesture:)))
        
        self.kevPic.contentMode = .scaleAspectFill
        self.kevPic.layer.cornerRadius = self.kevPic.frame.size.width / 2
        self.kevPic.clipsToBounds = true
        
        self.wesPic.contentMode = .scaleAspectFill
        self.wesPic.layer.cornerRadius = self.wesPic.frame.size.width / 2
        self.wesPic.clipsToBounds = true
        
        kevPic.addGestureRecognizer(tapGesture)
        kevPic.isUserInteractionEnabled = true
        wesPic.addGestureRecognizer(tapGesture2)
        wesPic.isUserInteractionEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            let url = URL(string: "https://kliao2016.github.io")
            UIApplication.shared.open(url!, options: [:])
            //Here you can initiate your new ViewController
        }
    }
    
    func imageTapped2(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            let url = URL(string: "https://wmauz677.github.io")
            UIApplication.shared.open(url!, options: [:])
            //Here you can initiate your new ViewController
        }
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
