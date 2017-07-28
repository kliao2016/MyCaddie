//
//  backgroundGradient.swift
//  MyCaddie
//
//  Created by Weston Mauz on 7/25/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class backgroundGradient: UIView {
    
    let shapeLayer = CAShapeLayer()
    let gradLayer = CAGradientLayer()
    let lab = CATextLayer()
    let indicationLabel = CATextLayer()
    //let label1 = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Gradient Layer for Circle
        
        layer.addSublayer(gradLayer)
        gradLayer.frame = bounds
        let green = UIColor.init(red: 0, green: 128/255, blue: 64/255, alpha: 0.05).cgColor
        let black = UIColor.black.cgColor
        gradLayer.colors = [green, black]
        
        // Fade in Animation on Center Text
        gradLayer.opacity = 0
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        gradLayer.add(animation, forKey: nil)
        gradLayer.opacity = 1
        
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
