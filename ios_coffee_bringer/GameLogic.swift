//
//  GameLogic.swift
//  ios_coffee_bringer
//
//  Created by David Nilsson on 18/11/16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import Foundation
import UIKit

public class GameLogic{
    
    
    public struct Hand{
        var scissors: Bool
        var rock: Bool
        var paper: Bool
        
        init (){
            self.scissors = false
            self.rock = false
            self.paper = false
        }
    }
    
    public struct Round{
        var rocks = [PlayersChoice]()
        var scissors = [PlayersChoice]()
        var papers = [PlayersChoice]()
        var winningHand = 10
        var hand = Hand()
        
        init(){}
    }
    
    static var lastRoundResult: RoundResult!
    static var coffeeBringerCounter: Int = 0
    
    /*public static func newGame(players: [Player], rounds: Int, numberOfCoffeBringers: Int) -> Game {
     return Game(players: players, rounds: rounds, numberOfCoffeBringers: numberOfCoffeBringers)
     }*/
    
    //0 = Rocks,  1 = Papers, 2 = Scissors
    public static func calculateResult(playersChoice: [PlayersChoice], game: Game)-> RoundResult {
        var result = RoundResult()
        var mutatedPlayerChoices = [PlayersChoice]()
        var excludedPlayerChoices = [PlayersChoice]()
        
        if let lastRoundResult = self.lastRoundResult {
            if !lastRoundResult.roundEnd {
                for thisPC in playersChoice {
                    if thisPC.id != "9" {
                        let lastPC = self.lastRoundResult.playersChoice.first(where: { (choice) -> Bool in
                            return choice.id == thisPC.id
                        })!
                        
                        lastPC.choice = thisPC.choice
                        
                        if !lastPC.roundLost && !lastPC.gameWon {
                            mutatedPlayerChoices.append(lastPC)
                        } else {
                            excludedPlayerChoices.append(lastPC)
                        }
                    }
                }
            } else {
                for thisPC in playersChoice {
                    if thisPC.id != "9" {
                        let lastPC = self.lastRoundResult.playersChoice.first(where: { (choice) -> Bool in
                            return choice.id == thisPC.id
                        })!
                        
                        lastPC.choice = thisPC.choice
                        
                        if !lastPC.gameWon {
                            mutatedPlayerChoices.append(lastPC)
                        } else {
                            excludedPlayerChoices.append(lastPC)
                        }
                    }
                }
            }
        } else {
            mutatedPlayerChoices.append(contentsOf: playersChoice)
        }
        
        var round = checkChosenHands(playersChoice: mutatedPlayerChoices)
        round.winningHand = winningHand(round: round)
        
        if singleWinnerOfRound(round: round){
            //Updates with points
            //result = updateStatsGame(round: round, game: game)
            result = updateStats(round: round, game: game, updateGamePoints: true)
        }
        else{
            //uppdates the round, no single winner
            //result = updateStatsRound(round: round, game: game)
            result = updateStats(round: round, game: game, updateGamePoints: false)
        }
        
        result.playersChoice.append(contentsOf: excludedPlayerChoices)
        GameLogic.lastRoundResult = result
        
        
        return result
    }
    //0 = Rocks,  1 = Papers, 2 = Scissors
    static func singleWinnerOfRound(round: Round) -> Bool {
        
        switch ((round.winningHand)){
        case 0:
            if round.rocks.count == 1{
                return true
            }
            break
            
        case 1:
            if round.papers.count == 1{
                return true
            }
            break
            
        case 2:
            if round.scissors.count == 1{
                return true
            }
            break
            
        case 3:
            break
            
        default:
            break
            
        }
        
        return false
    }
    
    //MARK: Sorterar ut vilka händer som är med i omgången
    //0 = Rocks,  1 = Papers, 2 = Scissors
    static func checkChosenHands(playersChoice: [PlayersChoice]) -> Round {
        
        var round = Round()
        
        for p in playersChoice {
            if p.choice == 0{
                round.hand.rock = true
                round.rocks.append(p)
            }
            if p.choice == 1{
                round.hand.paper = true
                round.papers.append(p)
            }
            if p.choice == 2{
                round.hand.scissors = true
                round.scissors.append(p)
            }
        }
        return round
    }
    
    //MARK: winning hand
    //0 = Rocks,  1 = Papers, 2 = Scissors
    static func winningHand(round: Round) -> Int{
        if((round.hand.paper) && (round.hand.rock) && (round.hand.scissors)){
            return 3
        }
        else if((round.hand.paper) && (round.hand.rock)){
            //paper win
            print("paper win")
            return 1
        }
        else if((round.hand.rock) && (round.hand.scissors)){
            //rock win
            print("rock win")
            return 0
        }
        else if((round.hand.scissors) && (round.hand.paper)){
            //sissor win
            print("scissors win")
            return 2
        }
        return 3
    }
    
    //0 = Rocks,  1 = Papers, 2 = Scissors
    static func updateStatsRoundLost(pc: [PlayersChoice], game: Game, roundResult: RoundResult, roundLost: Bool) -> RoundResult {
        for p in pc {
            p.roundLost = roundLost
            roundResult.playersChoice.append(p)
        }
        
        return roundResult
    }
    
    //0 = Rocks,  1 = Papers, 2 = Scissors
    static func updateStatsGameHelperWinningHand (pc: [PlayersChoice], game: Game, roundResult: RoundResult) -> RoundResult {
        
        for p in pc {
            roundResult.roundEnd = true
            p.points = p.points + 1
            p.roundLost = false
            roundResult.playersChoice.append(p)
            
            if p.points >= game.rounds {
                coffeeBringerCounter += 1
                p.gameWon = true
                roundResult.coffeBringers.append(p.id)
                if coffeeBringerCounter >= game.numberOfCoffeBringers {
                    roundResult.gameEnd = true
                }
            }
        }
        return roundResult
    }
    
    //MARK: update stats Game
    //0 = Rocks,  1 = Papers, 2 = Scissors
    //static func updateStatsGame(round: Round, game: Game) -> RoundResult {
    static func updateStats(round: Round, game: Game, updateGamePoints: Bool) -> RoundResult {
        var res = RoundResult()
        
        switch ((round.winningHand)){
        case 0:
            if updateGamePoints {
                res = updateStatsGameHelperWinningHand(pc: round.rocks, game: game, roundResult: res)
                res = updateStatsRoundLost(pc: round.papers, game: game, roundResult: res, roundLost: true)
                res = updateStatsRoundLost(pc: round.scissors, game: game, roundResult: res, roundLost: true)
                break
            }else{
                res = updateStatsRoundLost(pc: round.papers, game: game, roundResult: res, roundLost: true)
                res = updateStatsRoundLost(pc: round.scissors, game: game, roundResult: res, roundLost: true)
                res = updateStatsRoundLost(pc: round.rocks, game: game, roundResult: res, roundLost: false)
                break
            }
            
            
        case 1:
            if updateGamePoints {
                res = updateStatsGameHelperWinningHand(pc: round.papers, game: game, roundResult: res)
                res = updateStatsRoundLost(pc: round.rocks, game: game, roundResult: res, roundLost: true)
                res = updateStatsRoundLost(pc: round.scissors, game: game, roundResult: res, roundLost: true)
                break
            }else{
                res = updateStatsRoundLost(pc: round.rocks, game: game, roundResult: res, roundLost: true)
                res = updateStatsRoundLost(pc: round.scissors, game: game, roundResult: res, roundLost: true)
                res = updateStatsRoundLost(pc: round.papers, game: game, roundResult: res, roundLost: false)
                break
            }
            
            
        case 2:
            if updateGamePoints {
                res = updateStatsGameHelperWinningHand(pc: round.scissors, game: game, roundResult: res)
                res = updateStatsRoundLost(pc: round.papers, game: game, roundResult: res, roundLost: true)
                res = updateStatsRoundLost(pc: round.rocks, game: game, roundResult: res, roundLost: true)
                break
            }else{
                res = updateStatsRoundLost(pc: round.papers, game: game, roundResult: res, roundLost: true)
                res = updateStatsRoundLost(pc: round.rocks, game: game, roundResult: res, roundLost: true)
                res = updateStatsRoundLost(pc: round.scissors, game: game, roundResult: res, roundLost: false)
                break
            }
            
            
        case 3:
            res = updateStatsRoundLost(pc: round.papers, game: game, roundResult: res, roundLost: false)
            res = updateStatsRoundLost(pc: round.rocks, game: game, roundResult: res, roundLost: false)
            res = updateStatsRoundLost(pc: round.scissors, game: game, roundResult: res, roundLost: false)
            
            break
            
        default:
            break
            
        }
        return res
    }
}
