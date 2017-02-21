//
//  CoffeeRPSView.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2016-11-26.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

class ImagePair {
    public var left : UIImage
    public var right : UIImage
    
    init(left: UIImage, right: UIImage) {
        self.left = left
        self.right = right
    }
}

public enum RPSType {
    case ROCK
    case PAPER
    case SCISSOR
}

@IBDesignable
public class CoffeeRPS: UIImageView {

    var scissorImagePair : ImagePair!
    var rockImagePair : ImagePair!
    var paperImagePair : ImagePair!
    var coffeeImage: UIImage!
    
    var orientation : CoffeeIndicatorOrientation = CoffeeIndicatorOrientation.LEFT
    var currentImagePair: ImagePair!
    
    var is_images_init: Bool = false
    
    
    @IBInspectable public var leftOrientation: Bool = true {
        didSet {
            if leftOrientation {
                self.setOrientation(orientation: .LEFT)
            } else {
                self.setOrientation(orientation: .RIGHT)
            }
        }
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        self.initImages()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initImages()
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        
        self.initImages()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initImages()
    }
    
    func initImages() {
        if self.is_images_init {
            return
        }
        
        // Init images
        self.scissorImagePair = ImagePair(
            left: CoffeeResource.getImage(name: "scissor_left", type: "png")!,
            right: CoffeeResource.getImage(name: "scissor_right", type: "png")!
        )
        
        self.rockImagePair = ImagePair(
            left: CoffeeResource.getImage(name: "rock_left", type: "png")!,
            right: CoffeeResource.getImage(name: "rock_right", type: "png")!
        )
        
        self.paperImagePair = ImagePair(
            left: CoffeeResource.getImage(name: "paper_left", type: "png")!,
            right: CoffeeResource.getImage(name: "paper_right", type: "png")!
        )
        
        self.coffeeImage = CoffeeResource.getImage(name: "coffee", type: "png")!
        
        self.currentImagePair = self.scissorImagePair
        self.is_images_init = true
    }
        
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update view
        self.updateView()
    }
    
    public func setImage(rps: RPSType) {
        switch rps {
        case .PAPER:
            self.currentImagePair = self.paperImagePair
            break
            
        case .ROCK:
            self.currentImagePair = self.rockImagePair
            break
            
        case .SCISSOR:
            self.currentImagePair = self.scissorImagePair
            break
        }
        
        self.updateView()
    }
    
    public func setImage(number: Int) {
        switch number {
        case 0:
            self.setImage(rps: .ROCK)
            break
            
        case 1:
            self.setImage(rps: .PAPER)
            break
            
        case 2:
            self.setImage(rps: .SCISSOR)
            break
            
        default:
            self.setImage(rps: .SCISSOR)
        }
    }
    
    public func setOrientation(orientation: CoffeeIndicatorOrientation) {
        self.orientation = orientation
        self.updateView()
    }
    
    func updateView() {
        if self.currentImagePair != nil {
            
            if self.orientation == .LEFT {
                self.image = self.currentImagePair.left
            } else {
                self.image = self.currentImagePair.right
            }
            self.layoutIfNeeded()
        }
    }
    
    public func hide(animation: Bool) {
        if animation {
            UIView.animate(withDuration: 1, animations: {
                self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }, completion: { done in
                self.isHidden = true
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            
        } else {
            self.isHidden = true
        }
    }
    
    public func setCoffeeImage() {
        self.image = self.coffeeImage
    }
    
    public func unsetCoffeeImage() {
        self.setImage(rps: .SCISSOR)
    }
}
