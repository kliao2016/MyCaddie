//
//  loadingCircle.swift
//  MyCaddie
//
//  Created by Weston Mauz on 7/25/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class loadingCircle: UIView {
    
    let shapeLayer = CAShapeLayer()
    let gradLayer = CAGradientLayer()
    let gradLayer2 = CAGradientLayer()
    let lab = CATextLayer()
    let indicationLabel = CATextLayer()
    //let label1 = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Blurry Fix
        lab.contentsScale = UIScreen.main.scale
        
        // Gradient Layer for Circle
        
        layer.addSublayer(gradLayer)
        gradLayer.frame = bounds
        let purple = UIColor.purple.cgColor
        let blue = UIColor.blue.cgColor
        gradLayer.colors = [blue, purple]
        gradLayer.startPoint = CGPoint(x: 0, y: 0)
        gradLayer.endPoint = CGPoint(x: 1, y: 1)
        
        // Gradient Layer for Text
        layer.addSublayer(gradLayer2)
        gradLayer2.frame = bounds
        gradLayer2.colors = [blue, purple]
        gradLayer2.startPoint = CGPoint(x: 0, y: 0)
        gradLayer2.endPoint = CGPoint(x: 1, y: 1)
        
        // Adding Cirlce Shape Layer
        
        layer.addSublayer(shapeLayer)
        
        // Creating Drawing Path of Circle
        let path = UIBezierPath()
        
        let cx = bounds.width / 2
        let cy = bounds.height / 2
        let c = CGPoint(x: cx, y: cy)
        
        // Setting Circle Bounds
        let pi2 = CGFloat(Double.pi * 2)
        let start = pi2*0
        let end = pi2
        
        // Creating the Circle
        path.addArc(withCenter: c, radius: cx - 5, startAngle: start, endAngle: end, clockwise: true)
        
        // Draing Path Specifications
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        //shapeLayer.strokeEnd = CGFloat(value)
        //shapeLayer.lineDashPattern = [1,1]
        
        // Create Mask for Circle
        gradLayer.mask = shapeLayer
        
        // Circle Animation
        let anime = CABasicAnimation(keyPath: "strokeEnd")
        anime.fromValue = 0
        anime.toValue = 1
        anime.duration = 1
        shapeLayer.add(anime, forKey: nil)
        
        // Text Label
        lab.string = "Loading"
        let insetX = bounds.width / 4
        let insetY = bounds.height / 3
        lab.frame = bounds.insetBy(dx: insetX, dy: insetY)
        lab.fontSize = 10
        lab.alignmentMode = kCAAlignmentCenter
        lab.foregroundColor = UIColor.blue.cgColor
        
        // Text Mask
        gradLayer2.mask = lab
        
        let when = DispatchTime.now() + 1
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.shapeLayer.opacity = 0
            self.gradLayer2.opacity = 0
        }
        
        // Label
        /*
         addSubview(label1)
         let insetX = bounds.width / 4
         let insetY = bounds.height / 4
         label1.frame = bounds.insetBy(dx: insetX, dy: insetY)
         label1.font = UIFont.systemFont(ofSize: 22)
         //label1.textColor = UIColor(colorLiteralRed: 0/255, green: 128/255, blue: 64/255, alpha: 1)
         label1.textColor = UIColor.blue
         label1.textAlignment = .center
         label1.text = "39"
         */
        
        // Fade in Animation on Center Text
//        gradLayer2.opacity = 0
//        let animation = CABasicAnimation(keyPath: "opacity")
//        animation.fromValue = 0
//        animation.toValue = 1
//        animation.duration = 2
//        gradLayer2.add(animation, forKey: nil)
//        gradLayer2.opacity = 1
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}

}
