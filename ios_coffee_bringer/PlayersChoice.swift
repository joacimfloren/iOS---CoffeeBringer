//
//  PlayersChoice.swift
//  ios_coffee_bringer
//
//  Created by David Nilsson on 18/11/16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import ObjectMapper
import UIKit

public class PlayersChoice : ImmutableMappable {
    var id: String
    var points = 0
    var choice: Int
    var roundLost = false
    var gameWon = false
    
    init(){
        self.id = ""
        self.choice = 3
    }
    init(id: String, choice: Int) {
        self.id = id
        self.choice = choice
    }
    
    required public init(map: Map) throws {
        self.id = try map.value("id")
        self.points = try map.value("points")
        self.choice = try map.value("choice")
        self.roundLost = try map.value("roundLost")
        self.gameWon = try map.value("gameWon")
    }
    
    public func mapping(map: Map) {
        self.id >>> map["id"]
        self.points >>> map["points"]
        self.choice >>> map["choice"]
        self.roundLost >>> map["roundLost"]
        self.gameWon >>> map["gameWon"]
    }
}
