//
//  CoffeePlayer.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2016-11-25.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

@IBDesignable
public class CoffeePlayer: UIView {
    
    var label : UILabel = UILabel()
    let animationLabel = UILabel()
    var circularRPSView: CoffeeCircularRPSView = CoffeeCircularRPSView()
    
    public var rpsView: CoffeeRPS = CoffeeRPS()
    
    public var activeColorPair : ColorPair?
    public var unactiveColorPair : ColorPair?
    
    let margin : CGFloat = 40
    let imgSize : CGFloat = 70
    
    public var isConnected: Bool = false
    public var disabled: Bool = false
    public var isCoffeeBringer: Bool = false
    
    var isInit = false
    
    public var leftOrientation : Bool = true {
        didSet {
            circularRPSView.leftOrientation = leftOrientation
        }
    }
    
    public var score : Int = 0 {
        didSet {
            self.circularRPSView.indicator.number = score
        }
    }

    public var name : String = "" {
        didSet {
            self.label.text = self.name
        }
    }
    
    public var labelHeight : CGFloat = 20 {
        didSet {
            self.updateView()
        }
    }
    
    public var borderWidth : CGFloat = 10 {
        didSet {
            self.circularRPSView.borderWidth = borderWidth
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if !isInit {
            isInit = true
            
            // Set view
            self.setView()
            
            // Init animation
            self.initLoadingAnimation()
        }
    }
    
    func initLoadingAnimation() {
        // Get size for label
        let size = self.circularRPSView.bounds
        
        // Set position and size
        self.animationLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        // Set other
        self.animationLabel.text = "?"
        self.animationLabel.textAlignment = .center
        self.animationLabel.textColor = UIColor.white
        self.animationLabel.font = self.animationLabel.font.withSize(30)
        
        // Set default to hidden
        self.animationLabel.isHidden = true
        
        // Add as sub view
        self.addSubview(self.animationLabel)
        
        // Start to animate
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.animationLabel.alpha = 0
        }, completion: nil)
    }
    
    public func startLoadingAnimation() {
        if isConnected && !disabled && !isCoffeeBringer {
            // Hide the rps view
            self.rpsView.isHidden = true
            
            // Show the label
            self.animationLabel.isHidden = false
        }
    }
    
    public func stopLoadingAnimation() {
        if isConnected && !disabled && !isCoffeeBringer {
            // Show the rps view
            self.rpsView.isHidden = false
            
            // Hide the label
            self.animationLabel.isHidden = true
        }
    }
    
    func setView() {
        // Init circular RPS View
        self.circularRPSView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - self.labelHeight)
        
        // Set img distances
        let sMargin = min(self.circularRPSView.bounds.width, self.circularRPSView.bounds.height)/2
        let borderMargin = self.circularRPSView.borderWidth / 2
        
        let borderOffset: CGFloat = 2
        let position: CGFloat = (borderMargin+sMargin)-(self.imgSize/2)-borderOffset
        self.rpsView.frame = CGRect(x: position, y: position, width: self.imgSize, height: self.imgSize)
        
        // Init rps view as hidden
        self.rpsView.isHidden = true
        
        // Init label
        self.label.frame = CGRect(x: CGFloat(0), y: self.circularRPSView.frame.height, width: self.bounds.width, height: self.labelHeight)
        self.label.textAlignment = .center
        self.label.text = self.name
        
        // Add to view
        self.addSubview(self.label)
        self.addSubview(self.circularRPSView)
        self.addSubview(self.rpsView)
    }
    
    func updateView() {
        self.circularRPSView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - self.labelHeight)
        self.label.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
    
    public func connect(name: String) {
        self.name = name
        self.isConnected = true
    }
    
    func setColors(colorPair: ColorPair) {
        self.circularRPSView.borderColor = colorPair.border
        self.circularRPSView.indicator.fillColor = colorPair.border
        self.circularRPSView.fillColor = colorPair.fill
    }
    
    public func setActive() {
        if let colorPair = self.activeColorPair {
            self.setColors(colorPair: colorPair)
        }
        
        self.circularRPSView.indicator.isHidden = false
    }
    
    public func setUnactive() {
        if let colorPair = self.unactiveColorPair {
            self.setColors(colorPair: colorPair)
        }
        self.circularRPSView.indicator.isHidden = true
    }
    
    public func setImage(number: Int) {
        self.rpsView.setImage(number: number)
    }
    
    public func setAsCoffeeBringer() {
        self.isCoffeeBringer = true
        self.disabled = true
        self.setUnactive()
        self.rpsView.setCoffeeImage()
    }
}
