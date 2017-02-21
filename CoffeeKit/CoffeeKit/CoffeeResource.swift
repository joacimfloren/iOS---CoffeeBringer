//
//  CoffeeResource.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2016-11-28.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import Foundation

class CoffeeResource {
    
    static let bundle = Bundle(identifier: "se.murva.CoffeeKit")!
    
    public static func getImage(name: String, type: String) -> UIImage? {
        let path = bundle.path(forResource: name, ofType: type)
        
        if path != nil {
            return UIImage(contentsOfFile: path!)
        } else {
            return nil
        }
        
    }
}
