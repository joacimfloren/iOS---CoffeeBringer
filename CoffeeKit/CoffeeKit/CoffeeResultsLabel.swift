//
//  ResultGettersLabel.swift
//  ios_coffee_bringer
//
//  Created by Rikard Olsson on 2016-11-21.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

@IBDesignable
public class CoffeeResultsLabel: UILabel {
    
    public func setText(names: [String]) {
        let count = names.count
        var str = ""
        for i in 0..<count {
            if i == count-1 {
                str += names[i]
            } else {
                str += names[i] + ", "
            }
        }
        
        self.text = str
        self.layoutIfNeeded()
    }
}
