//
//  CircularView.swift
//  ios_coffee_bringer
//
//  Created by Rikard Olsson on 2016-11-21.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

@IBDesignable
public class CoffeeCircularView: UIView {
    
    @IBInspectable public var borderWidth : CGFloat = 0 {
        didSet {
            self.shapeLayer.lineWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColor : UIColor = UIColor(red: 1, green: 218/255, blue: 67/255, alpha: 1) {
        didSet {
            self.shapeLayer.strokeColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var fillColor: UIColor = UIColor.clear {
        didSet {
            self.shapeLayer.fillColor = fillColor.cgColor
        }
    }
    
    internal var shapeLayer : CAShapeLayer = CAShapeLayer()
    
    var isInit = false
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    
        let r = self.bounds.width/2
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: r,y: r), radius: r, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        shapeLayer.path = circlePath.cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}
