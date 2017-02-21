//
//  BluetoothGameData.swift
//  ios_coffee_bringer
//
//  Created by Johan Rasmussen on 07/12/16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import Foundation

class BluetoothGameData{
    var numberOfPlayers: Int!
    var maxPlayers: Int!
    var playerChoices = [PlayersChoice]()
    var state: Int!
    var numberOfCoffeeBringers: Int!
    var rounds: Int!
    
    init(numberOfPlayers: Int, maxPlayers: Int, pChoices: [PlayersChoice], state: Int, numberOfCoffeeBringers: Int, rounds: Int) {
        self.numberOfPlayers = numberOfPlayers
        self.maxPlayers = maxPlayers
        self.playerChoices = pChoices
        self.state = state
        self.numberOfCoffeeBringers = numberOfCoffeeBringers
        self.rounds = rounds
    }
    
    init(infoString: String){
        self.state = Int(String(infoString[(infoString.index(infoString.startIndex, offsetBy: 0))]))
        self.numberOfPlayers = Int(String(infoString[(infoString.index(infoString.startIndex, offsetBy: 1))]))
        self.maxPlayers = Int(String(infoString[(infoString.index(infoString.startIndex, offsetBy: 2))]))
        let choice1 = PlayersChoice()
        choice1.id = String(infoString[(infoString.index(infoString.startIndex, offsetBy: 3))])
        choice1.choice = Int(String(infoString[(infoString.index(infoString.startIndex, offsetBy: 4))]))!
        playerChoices.append(choice1)
        let choice2 = PlayersChoice()
        choice2.id = String(infoString[(infoString.index(infoString.startIndex, offsetBy: 5))])
        choice2.choice = Int(String(infoString[(infoString.index(infoString.startIndex, offsetBy: 6))]))!
        playerChoices.append(choice2)
        let choice3 = PlayersChoice()
        choice3.id = String(infoString[(infoString.index(infoString.startIndex, offsetBy: 7))])
        choice3.choice = Int(String(infoString[(infoString.index(infoString.startIndex, offsetBy: 8))]))!
        playerChoices.append(choice3)
        let choice4 = PlayersChoice()
        choice4.id = String(infoString[(infoString.index(infoString.startIndex, offsetBy: 9))])
        choice4.choice = Int(String(infoString[(infoString.index(infoString.startIndex, offsetBy: 10))]))!
        playerChoices.append(choice4)
        let choice5 = PlayersChoice()
        choice5.id = String(infoString[(infoString.index(infoString.startIndex, offsetBy: 11))])
        choice5.choice = Int(String(infoString[(infoString.index(infoString.startIndex, offsetBy: 12))]))!
        playerChoices.append(choice5)
        self.numberOfCoffeeBringers = Int(String(infoString[(infoString.index(infoString.startIndex, offsetBy: 13))]))
        self.rounds = Int(String(infoString[(infoString.index(infoString.startIndex, offsetBy: 14))]))
    }
    
    func getWriteableString() -> String {
        var info = ""
        info += String(state)
        info += String(numberOfPlayers)
        info += String(maxPlayers)
        var index = 0
        for _ in playerChoices {
            info += playerChoices[index].id + String(playerChoices[index].choice)
            index += 1
        }
       
        let rest = 5 - index
        for _ in 0..<rest {
            // To keep the same format of the string, put any empty places 9
            info += "9" + "9"
        }
        info += String(numberOfCoffeeBringers)
        info += String(rounds)
        return info
    }
}
