//
//  mainScreenAnimation.swift
//  MyCaddie
//
//  Created by Weston Mauz on 7/25/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class mainScreenAnimation: UIView {
    
    let shapeLayer = CAShapeLayer()
    let gradLayer2 = CAGradientLayer()
    let welcomeLabel = CATextLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Gradient Layer for Circle
        //let black = UIColor.black.cgColor
        //let blue = UIColor.blue.cgColor
        let green = UIColor.init(red: 0, green: 128/255, blue: 64/255, alpha: 1).cgColor
        
        // Gradient Layer for Text
        gradLayer2.frame = bounds
        gradLayer2.colors = [green, green]
        //gradLayer2.startPoint = CGPoint(x: 0.2, y: 0.2)
        //gradLayer2.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradLayer2)
        
        // Text Label
        welcomeLabel.contentsScale = UIScreen.main.scale
        welcomeLabel.string = "Welcome to MyCaddie!"
        welcomeLabel.frame = bounds
        welcomeLabel.fontSize = 24
        welcomeLabel.alignmentMode = kCAAlignmentCenter
        welcomeLabel.foregroundColor = UIColor.black.cgColor
        welcomeLabel.alignmentMode = kCAAlignmentCenter
        layer.addSublayer(welcomeLabel)
        
        // Text Mask
        gradLayer2.mask = welcomeLabel
        
        
        // Fade in Animation on Center Text
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        gradLayer2.add(animation, forKey: nil)
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

