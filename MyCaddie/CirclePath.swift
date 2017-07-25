//
//  CirclePath.swift
//  MyCaddie
//
//  Created by Weston Mauz on 7/25/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class CirclePath: UIView {

    let shapeLayer = CAShapeLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(shapeLayer)
        
        //let path = UIBezierPath(ovalIn: bounds)
        let path = UIBezierPath()
        
        let cx = bounds.width / 2
        let cy = bounds.height / 2
        let c = CGPoint(x: cx, y: cy)
        
        let pi2 = CGFloat(M_PI * 2)
        let start = pi2 * 3/8
        let end = pi2 * 9/8
        
        path.addArc(withCenter: c, radius: cx, startAngle: start, endAngle: end, clockwise: true)
        
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = UIColor.init(red: 0, green: 230/255, blue: 64/255, alpha: 1).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        //shapeLayer.strokeEnd = CGFloat(value)
        shapeLayer.lineDashPattern = [2,2]
        
        
        let anime = CABasicAnimation(keyPath: "strokeEnd")
        anime.fromValue = 0
        anime.toValue = 1
        anime.duration = 1

        shapeLayer.add(anime, forKey: nil)
        
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
