//
//  Player.swift
//  ios_coffee_bringer
//
//  Created by David Nilsson on 18/11/16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import ObjectMapper
import UIKit

public class Player : ImmutableMappable {
    public var id: String
    public var position: Int
    public var host = false
    public var name: String
    
    init(){
        self.id = ""
        self.position = 0
        self.name = "vakans"
        self.host = false
    }
    
    init(id: String, position: Int, name: String) {
        self.id = id
        self.position = position
        self.name = name        
    }
    
    required public init(map: Map) throws {
        self.id = try map.value("id")
        self.position = try map.value("position")
        self.host = try map.value("host")
        self.name = try map.value("name")
    }
    
    public func mapping(map: Map) {
        self.id >>> map["id"]
        self.position >>> map["position"]
        self.host >>> map["host"]
        self.name >>> map["name"]
    }
}
