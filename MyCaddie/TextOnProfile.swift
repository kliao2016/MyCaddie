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
        
        let green = UIColor.init(red: 0, green: 128/255, blue: 64/255, alpha: 1).cgColor
        let white = UIColor.white.cgColor
        
        layer.addSublayer(gradLayer2)
        gradLayer2.frame = bounds
        gradLayer2.colors = [green, white]
        gradLayer2.startPoint = CGPoint(x: 0, y: 0)
        gradLayer2.endPoint = CGPoint(x: 1, y: 1)
        
        lab.contentsScale = UIScreen.main.scale
        
        // Second Label
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
    
}
