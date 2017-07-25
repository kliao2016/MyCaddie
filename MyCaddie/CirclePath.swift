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
        
        let path = UIBezierPath(ovalIn: bounds)
        
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 10
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        let anime = CABasicAnimation(keyPath: "strokeEnd")
        anime.fromValue = 0
        anime.toValue = 1
        anime.duration = 4
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
