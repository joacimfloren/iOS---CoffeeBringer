//
//  BluetoothPlayerData.swift
//  ios_coffee_bringer
//
//  Created by Johan Rasmussen on 07/12/16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import Foundation

class BluetoothPlayerData{
    
    var state: Int!
    var players = [Player]()
    
    init(state: Int, players: [Player]) {
        self.state = state
        self.players = players
    }
    
    init(infoString: String){
        self.state = Int(String(infoString[(infoString.index(infoString.startIndex, offsetBy: 0))]))
        
        var isGettingName = false
        var player = Player()
        player.id = ""
        player.name = ""
        
        var hasSkippedState = false
        for character in infoString.characters {
            
            if !hasSkippedState {
                hasSkippedState = true
                continue
            }
            
            if character == ";"{
                self.players.append(player)
                player = Player()
                player.id = ""
                player.name = ""
                isGettingName = false
                continue
            }
            
            if !isGettingName {
                player.id = String(character)
                isGettingName = true
                continue
            } else{
                player.name += String(character)
            }
        }
    }
    
    func getWriteableString() -> String {
        var info = ""
        info += String(state)
        
        var index = 0
        for player in players{
            info += player.id
            info += player.name
            info += ";"
            index += 1
        }
        
        let rest = 5 - index
        for _ in 0..<rest {
            // To keep the same format of the string, put any empty places 9
            info += "9"
            info += "9"
            info += ";"
        }
        
        return info
    }
    
}
