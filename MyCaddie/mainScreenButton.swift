//
//  mainScreenButton.swift
//  MyCaddie
//
//  Created by Weston Mauz on 7/25/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class mainScreenButton: UIView {
    
    let shapeLayer = CAShapeLayer()
    let gradLayer2 = CAGradientLayer()
    let welcomeLabel = CATextLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Gradient Layer for Circle
        //let white = UIColor.white.cgColor
        //let green = UIColor.green.cgColor
        let black = UIColor.black.cgColor
        //let clear = UIColor.clear.cgColor
        //let green = UIColor.init(red: 0, green: 188/255, blue: 40/255, alpha: 1)
        
        // Text Label
        welcomeLabel.string = "Get Started"
        welcomeLabel.frame = bounds
        welcomeLabel.fontSize = 14
        welcomeLabel.alignmentMode = kCAAlignmentCenter
        welcomeLabel.foregroundColor = UIColor.white.cgColor
        welcomeLabel.alignmentMode = kCAAlignmentCenter
        layer.addSublayer(welcomeLabel)
        
        // Gradient Layer for Text
        gradLayer2.frame = bounds
        gradLayer2.colors = [black, black]
        gradLayer2.startPoint = CGPoint(x: 0, y: 0)
        gradLayer2.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradLayer2)
        
        
        // Text Mask
        gradLayer2.mask = welcomeLabel
        
        /*
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
            self.gradLayer2.opacity = 1
        })
        */
        
        
        
        
        
            // Fade in Animation on Center Text
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 3
            self.gradLayer2.add(animation, forKey: nil)
            print("finish")
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

