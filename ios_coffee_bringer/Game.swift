//
//  Game.swift
//  ios_coffee_bringer
//
//  Created by David Nilsson on 18/11/16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import CoreBluetooth
import UIKit

public class Game {
    public var id: Int
    public var name : String
    private var players = [Player]()
    public var rounds: Int
    public var numberOfCoffeBringers: Int
    public var maxPlayers: Int
    public var currentPlayers: Int
    
    public var host : CBPeripheral!
    
    init (id: Int, name: String, rounds: Int, numberOfCoffeeBringers: Int, maxPlayers: Int){
        self.id = id
        self.name = name
        self.rounds = rounds
        self.numberOfCoffeBringers = numberOfCoffeeBringers
        self.maxPlayers = maxPlayers
        self.currentPlayers = 0
    }
    
    init (id: Int, name: String, rounds: Int, numberOfCoffeeBringers: Int, maxPlayers: Int, currentPlayers: Int){
        self.id = id
        self.name = name
        self.rounds = rounds
        self.numberOfCoffeBringers = numberOfCoffeeBringers
        self.maxPlayers = maxPlayers
        self.currentPlayers = currentPlayers
    }
    
    public func addPlayer(player: Player) {
        self.players.append(player)
        self.currentPlayers += 1
    }
    
    public func getPlayer(index: Int) -> Player {
        return self.players[index]
    }
    
    public func getAllPlayers() -> [Player] {
        return self.players
    }
}
