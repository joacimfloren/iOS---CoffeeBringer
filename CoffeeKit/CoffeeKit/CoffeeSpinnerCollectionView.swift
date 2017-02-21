//
//  CoffeeSpinnerCollectionView.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2016-12-03.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

struct RPSImage {
    var value: Int
    var image: UIImage
}

public class CoffeeSpinnerCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    var numOfImages = 3
    var intMax = 1000
    public var selectedRPS = 1
    var index = 0
    var position = 0
    
    var images = [
        RPSImage(value: 1, image: CoffeeResource.getImage(name: "paper_left", type: "png")!),
        RPSImage(value: 2, image: CoffeeResource.getImage(name: "scissor_left", type: "png")!),
        RPSImage(value: 0, image: CoffeeResource.getImage(name: "rock_left", type: "png")!)
    ]
    
    func setDelegates() {
        self.delegate = self
        self.dataSource = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setDelegates()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // Set colors
        self.backgroundColor = CoffeeColors.SecondOrange()
        
        // Set round rect
        self.layer.cornerRadius = self.bounds.width/2
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.intMax
    }
    
    func intToRPSString(index: Int) -> String {
        switch (index) {
        case 0:
            return "ROCK"
        case 1:
            return "PAPER"
        case 2:
            return "SCISSOR"
        default:
            return ""
        }
    }
    
    func calculateRPSIndex() -> Int {
        let visableRect = CGRect(origin: self.contentOffset, size: self.bounds.size)
        let visablePoint = CGPoint(x: visableRect.midX, y: visableRect.midY)
        var visableIndexPath = self.indexPathForItem(at: visablePoint)
        
        self.index = visableIndexPath!.row
        self.selectedRPS = index % 3
        
        return self.selectedRPS
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "SpinnerCollectionViewCell", for: indexPath) as! CoffeeSpinnerCollectionViewCell
        let data = self.images[indexPath.row % self.numOfImages]
        
        cell.image.image = data.image
        self.selectedRPS = self.calculateRPSIndex()
        
        return cell
    }
    
    public func set(position: Int) {
        self.position = position
    }
    
    public func stopScrolling() {
        // TODO: Do something about this
    }
    
    public func hide(animation: Bool) {
        if !isHidden {
            if animation {
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                }, completion: { done in
                    self.isHidden = true
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            } else {
                self.isHidden = true
            }
        }
    }
}
