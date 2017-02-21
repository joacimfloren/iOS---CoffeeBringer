//
//  CoffeeColors.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2016-12-02.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import Foundation

public class CoffeeColors {
    public static func StatusBarOrange() -> UIColor {
        return UIColor(netHex: 0xFD8B07)
    }
    
    public static func BarOrange() -> UIColor {
        return UIColor.init(red: 241/256, green: 196/256, blue: 15/256, alpha: 1.0)
    }
    
    public static func SecondOrange() -> UIColor {
        return UIColor(netHex: 0xED8912)
    }
    
    public static func MainYellow() -> UIColor {
        return UIColor(netHex: 0xF1C40F)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
