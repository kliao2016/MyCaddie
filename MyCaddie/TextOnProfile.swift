//
//  CirclePath3.swift
//  MyCaddie
//
//  Created by Weston Mauz on 7/25/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class TextOnProfile: UIView {
    
    let gradLayer2 = CAGradientLayer()
    let lab = CATextLayer()
    
    init(frame: CGRect, stat: String) {
        super.init(frame: frame)
        
        let orange = UIColor.orange.cgColor
        let blue = UIColor.blue.cgColor
        let green = UIColor.green.cgColor
        
        layer.addSublayer(gradLayer2)
        gradLayer2.frame = bounds
        gradLayer2.colors = [green, blue]
        gradLayer2.startPoint = CGPoint(x: 0, y: 0)
        gradLayer2.endPoint = CGPoint(x: 1, y: 1)
        
        // Second Label Try
        lab.string = stat
        lab.frame = bounds
        lab.fontSize = 40
        lab.alignmentMode = kCAAlignmentCenter
        lab.foregroundColor = UIColor.blue.cgColor
        gradLayer2.mask = lab
        
        // Fade in Animation
        gradLayer2.opacity = 0
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        gradLayer2.add(animation, forKey: nil)
        gradLayer2.opacity = 1
        
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
