//
//  CirclePath2.swift
//  MyCaddie
//
//  Created by Weston Mauz on 7/25/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class CirclePath2: UIView {
    
    let shapeLayer = CAShapeLayer()
    let gradLayer = CAGradientLayer()
    let label1 = UILabel()
    let gradLayer2 = CAGradientLayer()
    let lab = CATextLayer()
    
    init(frame: CGRect, stat: String) {
        super.init(frame: frame)
        
        // Blurry Fix
        lab.contentsScale = UIScreen.main.scale
        
        layer.addSublayer(gradLayer)
        gradLayer.frame = bounds
        let purple = UIColor.purple.cgColor
        let orange = UIColor.orange.cgColor
        gradLayer.colors = [orange, purple]
        gradLayer.startPoint = CGPoint(x: 0, y: 0)
        gradLayer.endPoint = CGPoint(x: 1, y: 1)
        
        layer.addSublayer(gradLayer2)
        gradLayer2.frame = bounds
        gradLayer2.colors = [orange, purple]
        gradLayer2.startPoint = CGPoint(x: 0, y: 0)
        gradLayer2.endPoint = CGPoint(x: 1, y: 1)
        
        layer.addSublayer(shapeLayer)
        
        //let path = UIBezierPath(ovalIn: bounds)
        let path = UIBezierPath()
        
        let cx = bounds.width / 2
        let cy = bounds.height / 2
        let c = CGPoint(x: cx, y: cy)
        
        let pi2 = CGFloat(Double.pi * 2)
        let start = pi2 * 3/8
        let end = pi2 * 9/8
        
        path.addArc(withCenter: c, radius: cx - 5, startAngle: start, endAngle: end, clockwise: true)
        
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.blue.cgColor
        //shapeLayer.strokeColor = UIColor.init(red: 0, green: 230/255, blue: 64/255, alpha: 1).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        //shapeLayer.strokeEnd = CGFloat(value)
        //shapeLayer.lineDashPattern = [1,2]
        
        // Create Mask
        gradLayer.mask = shapeLayer
        
        let anime = CABasicAnimation(keyPath: "strokeEnd")
        anime.fromValue = 0
        anime.toValue = 1
        anime.duration = 1.5
        
        shapeLayer.add(anime, forKey: nil)
        
        // Second Label Try
        lab.string = stat
        let insetX = bounds.width / 4
        let insetY = bounds.height / 3
        lab.frame = bounds.insetBy(dx: insetX, dy: insetY)
        lab.fontSize = 22
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
