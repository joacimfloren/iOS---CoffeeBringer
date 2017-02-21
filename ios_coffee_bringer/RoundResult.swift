//
//  RoundResult.swift
//  ios_coffee_bringer
//
//  Created by David Nilsson on 18/11/16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import ObjectMapper
import UIKit

public class RoundResult : ImmutableMappable {
    var playersChoice = [PlayersChoice]()
    var roundEnd = false
    var gameEnd = false
    var coffeBringers = [String]()
    
    init() { }
    
    init(playersChoice: [PlayersChoice]) {
        self.playersChoice = playersChoice
    }
    
    required public init(map: Map) throws {
        self.playersChoice = try map.value("playersChoice")
        self.roundEnd = try map.value("roundEnd")
        self.gameEnd = try map.value("gameEnd")
        self.coffeBringers = try map.value("coffeBringers")
    }
    
    public func mapping(map: Map) {
        self.playersChoice >>> map["playersChoice"]
        self.roundEnd >>> map["roundEnd"]
        self.gameEnd >>> map["gameEnd"]
        self.coffeBringers >>> map["coffeBringers"]
    }
}
