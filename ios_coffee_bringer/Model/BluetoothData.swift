//
//  BluetoothData.swift
//  ios_coffee_bringer
//
//  Created by Joacim Florén on 2016-12-05.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import ObjectMapper
import Foundation

//enum GAMESTATE : Int {
//    case accepted = 0
//    case start = 1
//}

//class BluetoothData : ImmutableMappable {
//
//    var state : Int
//    
//    var game : Game
//    var roundResult : RoundResult
//    var playersChoice : PlayersChoice
//    
//    init(state: Int, game: Game, roundResult: RoundResult, playersChoice: PlayersChoice) {
//        self.state = state
//        
//        self.game = game
//        self.roundResult = roundResult
//        self.playersChoice = playersChoice
//    }
//    
//    required init(map: Map) throws {
//        self.state = try map.value("state")
//        self.room = try map.value("room")
//        self.game = try map.value("game")
//        self.roundResult = try map.value("roundResult")
//        self.playersChoice = try map.value("playersChoice")
//    }
//    
//    func mapping(map: Map) {
//        self.state >>> map["state"]
//        self.room >>> map["room"]
//        self.game >>> map["game"]
//        self.roundResult >>> map["roundResult"]
//        self.playersChoice >>> map["playersChoice"]
//    }
//    
//}
