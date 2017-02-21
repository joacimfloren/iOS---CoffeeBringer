//
//  CurrentUser.swift
//  ios_coffee_bringer
//
//  Created by Rikard Olsson on 2016-12-09.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import Foundation

struct UserPropertyKey {
    static let nameKey = "name"
}

class Current  {
    static var user: User?
}

class User : NSObject, NSCoding {
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = documentsDirectory.appendingPathComponent("user")
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: UserPropertyKey.nameKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: UserPropertyKey.nameKey) as! String
        
        self.init(name: name)
    }
}
