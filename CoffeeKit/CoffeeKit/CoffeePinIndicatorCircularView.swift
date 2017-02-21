//
//  CoffeePinIndicatorCircularView.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2016-11-25.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

@IBDesignable
public class CoffeePinIndicatorCircularView: CoffeeCircularView {

    @IBInspectable public var number: Int = 0 {
        didSet {
            if self.indicator != nil {
                self.indicator.text = "\(number)"
            }
        }
    }
    
    var indicator : UILabel!
    
    override public func layoutSubviews() {
        if !isInit {
            isInit = true
            
            super.layoutSubviews()
            
            self.indicator = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
            self.indicator.text = "\(self.number)"
            self.indicator.textColor = UIColor.white
            self.indicator.textAlignment = .center
            
            self.addSubview(self.indicator)
        }
    }
    
    public func increaseNumber() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        }, completion: { done in
            self.number += 1
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
    }

}
