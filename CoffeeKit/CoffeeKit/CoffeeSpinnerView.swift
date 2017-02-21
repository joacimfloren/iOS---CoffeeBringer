//
//  CoffeeUserField.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2016-12-02.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

class CoffeeSpinnerItem : UIView {
    public var image : UIImage
    
    init(image: UIImage, rect: CGRect) {
        self.image = image
        
        super.init(frame: rect)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.image = CoffeeResource.getImage(name: "scissor_left", type: "png")!
        
        super.init(coder: aDecoder)
    }
}

@IBDesignable
public class CoffeeSpinnerView : UIView {
    
    var images = [
        CoffeeResource.getImage(name: "scissor_left", type: "png")!,
        CoffeeResource.getImage(name: "rock_left", type: "png")!,
        CoffeeResource.getImage(name: "paper_left", type: "png")!
        ]
    
    var middleCircle = CoffeeCircularView()
    
    let size : CGFloat = 140
    
    var isInit = false
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Add circular view
        if !isInit{
            isInit = true
            self.addCircularView()
            
            self.backgroundColor = CoffeeColors.MainYellow()
        }
    }
    
    func addCircularView() {
        let center = CGPoint(x: self.bounds.width/2-size/2, y: self.bounds.height/2-size/2)
        self.middleCircle.frame = CGRect(x: center.x, y: center.y, width: size, height: size)
        self.middleCircle.fillColor = CoffeeColors.StatusBarOrange()
        self.addSubview(self.middleCircle)
    }
    
}
