//
//  profileBackground.swift
//  MyCaddie
//
//  Created by Weston Mauz on 7/25/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class profileBackground: UIView {
    
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

        let grey = UIColor.init(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        let black = UIColor.black.cgColor
        //let blue = UIColor.blue.cgColor
        gradLayer.colors = [black, grey]
        
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

