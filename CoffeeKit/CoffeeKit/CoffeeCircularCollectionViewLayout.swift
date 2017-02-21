//
//  CircularCollectionViewLayout.swift
//  CircularCollectionView
//
//  Created by Rounak Jain on 27/05/15.
//  Copyright (c) 2015 Rounak Jain. All rights reserved.
//

import UIKit

struct AngleItem {
    var startIndex: Int
    var endIndex: Int
    var centerX: CGFloat
    var anchorPointY: CGFloat
}

public class CoffeeCircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    var angle: CGFloat = 0 {
        didSet {
            zIndex = Int(angle*1000000)
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    override public func copy(with zone: NSZone?) -> Any {
        let copiedAttributes: CoffeeCircularCollectionViewLayoutAttributes = super.copy(with: zone) as! CoffeeCircularCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        
        return copiedAttributes
    }
    
}

public class CoffeeCircularCollectionViewLayout: UICollectionViewLayout {
    
    var is_init = false
    let itemSize = CGSize(width: 100, height: 100)
    
    var angleAtExtreme: CGFloat {
        return collectionView!.numberOfItems(inSection: 0) > 0 ? -CGFloat(collectionView!.numberOfItems(inSection: 0)-1)*anglePerItem : 0
    }
    
    var angle: CGFloat {
        return angleAtExtreme*collectionView!.contentOffset.x/(collectionViewContentSize.width - collectionView!.bounds.width)
    }
    
    var radius: CGFloat = 170 {
        didSet {
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat {
        let a = atan(120*(M_PI / 180))
        return CGFloat(a)
    }
    
    var attributesList = [CoffeeCircularCollectionViewLayoutAttributes]()
    
    override public var collectionViewContentSize : CGSize {
        return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0))*itemSize.width,
                      height: collectionView!.bounds.height)
    }
    
    override public class var layoutAttributesClass : AnyClass {
        return CoffeeCircularCollectionViewLayoutAttributes.self
    }
    
    override public func prepare() {
        super.prepare()
        
        self.prepLayout()
    }
    
    func prepLayout() {
        if !is_init {
            is_init = true
            collectionView!.contentOffset.x = CGFloat(itemSize.width*500-15)
        }
        
        let angleItem = calculateAngleItem()
        self.updateAttributeList(angleItem: angleItem)
    }
    
    func calculateAngleItem() -> AngleItem {
        let offset = collectionView!.contentOffset.x
        let halfBounds = (collectionView!.bounds.width/2.0)
        let centerX = offset + halfBounds
        let anchorPointY = ((itemSize.height/2.0) + radius)/itemSize.height
        
        let theta = atan2(collectionView!.bounds.width/2.0, radius + (itemSize.height/2.0) - (collectionView!.bounds.height/2.0))
        
        var startIndex = 0
        var endIndex = collectionView!.numberOfItems(inSection: 0) - 1
        
        let a = angle
        if (a < -theta) {
            startIndex = Int(floor((-theta - a)/anglePerItem))
        }
        
        endIndex = min(endIndex, Int(ceil((theta - angle)/anglePerItem)))
        
        if (endIndex < startIndex) {
            endIndex = 0
            startIndex = 0
        }
        
        return AngleItem(startIndex: startIndex, endIndex: endIndex, centerX: centerX, anchorPointY: anchorPointY)
    }
    
    func updateAttributeList(angleItem: AngleItem) {
        self.attributesList = (angleItem.startIndex...angleItem.endIndex).map { (i) -> CoffeeCircularCollectionViewLayoutAttributes in
            let attributes = CoffeeCircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            attributes.size = self.itemSize
            attributes.center = CGPoint(x: angleItem.centerX, y: self.collectionView!.bounds.midY)
            attributes.angle = self.angle + (self.anglePerItem*CGFloat(i))
            attributes.anchorPoint = CGPoint(x: 0.5, y: angleItem.anchorPointY)
            return attributes
        }
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            return attributesList[indexPath.row%3]
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var finalContentOffset = proposedContentOffset
        let factor = -angleAtExtreme/(collectionViewContentSize.width - collectionView!.bounds.width)
        let proposedAngle = proposedContentOffset.x*factor
        let ratio = proposedAngle/anglePerItem
        var multiplier: CGFloat
        if (velocity.x > 0) {
            multiplier = ceil(ratio)
        } else if (velocity.x < 0) {
            multiplier = floor(ratio)
        } else {
            multiplier = round(ratio)
        }
        finalContentOffset.x = multiplier*anglePerItem/factor
        return finalContentOffset
    }
    
}
