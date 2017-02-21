//
//  SpinnerCollectionViewCell.swift
//  ios_coffee_bringer
//
//  Created by Rikard Olsson on 2016-12-02.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

class CoffeeSpinnerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CoffeeCircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5)*self.bounds.height
    }
}
