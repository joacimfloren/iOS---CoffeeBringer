//
//  CoffeePlayerAtGame.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2016-11-25.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

public enum CoffeeIndicatorOrientation {
    case LEFT
    case RIGHT
}

@IBDesignable
public class CoffeeCircularRPSView: CoffeeCircularView {

    public var indicator : CoffeePinIndicatorCircularView = CoffeePinIndicatorCircularView()
    
    override public var borderColor : UIColor {
        didSet {
            self.shapeLayer.strokeColor = borderColor.cgColor
            self.indicator.shapeLayer.fillColor = borderColor.cgColor
        }
    }
    
    public var leftOrientation : Bool = true {
        didSet {
            if leftOrientation {
                self.updateCircularView(orientation: .LEFT)
            } else {
                self.updateCircularView(orientation: .RIGHT)
            }
        }
    }
    
    let size : CGFloat = 25
    
    override public func layoutSubviews() {
        if !isInit {
            isInit = true
            
            super.layoutSubviews()
            
            self.setCircularView()
            self.updateCircularView(orientation: .LEFT)
        }
    }
    
    func setCircularView() {
        self.indicator.frame = CGRect(x: 0, y: 0, width: size, height: size)
        self.indicator.borderWidth = 0
        
        self.addSubview(self.indicator)
    }
    
    func updateCircularView(orientation: CoffeeIndicatorOrientation) {
        let r = self.bounds.width / 2
        let pi4 = CGFloat(M_PI/4)
        let c = (r-size/2)
        let m = self.borderWidth / 2
        
        var x: CGFloat!
        let y = c - r*sin(pi4) + m
        
        switch orientation {
        case .LEFT:
            x = c - r*cos(pi4) + m
            break
            
        case .RIGHT:
            x = c + r*cos(pi4) + m
            break
        }
        
        self.indicator.frame = CGRect(x: x, y: y, width: size, height: size)
        self.layoutIfNeeded()
    }
}
