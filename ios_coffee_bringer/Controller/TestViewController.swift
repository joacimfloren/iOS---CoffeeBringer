//
//  TestViewController.swift
//  ios_coffee_bringer
//
//  Created by Joacim Florén on 2016-12-02.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

//    var game = Game()
//    var playerChoices = GlobalData.PlayerChoices
//    var Jocke = Player(id: "Jocke", position: 0, name: "Jocke")
//    var David = Player(id: "David", position: 0, name: "David")
//    var KukMusen = Player(id: "Kuken", position: 0, name: "Kuken")
//    var JockeChoice = PlayersChoice()
//    var DavidChoice = PlayersChoice()
//    var KukMusenChoice = PlayersChoice()
//    var started = false
//
//
//    @IBOutlet weak var player1_score: UILabel!
//    @IBOutlet weak var player2_score: UILabel!
//    @IBOutlet weak var player3_score: UILabel!
//    @IBOutlet weak var player1_choice: UITextField!
//    @IBOutlet weak var player2_choice: UITextField!
//    @IBOutlet weak var player3_choice: UITextField!
//    @IBOutlet weak var player1_state: UILabel!
//    @IBOutlet weak var player2_state: UILabel!
//    @IBOutlet weak var player3_state: UILabel!
//    @IBOutlet weak var player1_name: UILabel!
//    @IBOutlet weak var player2_name: UILabel!
//    @IBOutlet weak var player3_name: UILabel!
//    
//    @IBAction func runRound(_ sender: Any) {
//    
//        view.endEditing(true)
//        
//        let p1_choice = Int(player1_choice.text!)
//        let p2_choice = Int(player2_choice.text!)
//        let p3_choice = Int(player3_choice.text!)
//        
//        let p1_score = Int(player1_score.text!)
//        let p2_score = Int(player2_score.text!)
//        let p3_score = Int(player3_score.text!)
//        
//        print(player1_choice.text!)
//        print(player2_choice.text!)
//        print(player3_choice.text!)
//        
//        
//        
//        if !started {
//            
//            startNewGame(rounds: 3, numbrOfCoffebringers: 1)
//            addPlayerToGame(id: Jocke.id, name: Jocke.name)
//            addPlayerToGame(id: KukMusen.id, name: KukMusen.name)
//            
//            started = true
//            
//        }
//        
//        newRound()
//        
//        playerChoices.removeAll()
//        
//        JockeChoice.id = "Jocke"
//        JockeChoice.choice = p1_choice!
//        addPlayerChoices(playerChoice: JockeChoice)
//        DavidChoice.id = "David"
//        DavidChoice.choice = p2_choice!
//        addPlayerChoices(playerChoice: DavidChoice)
//        KukMusenChoice.id = "Kuken"
//        KukMusenChoice.choice = p3_choice!
//        addPlayerChoices(playerChoice: KukMusenChoice)
//        
//        let result = playRound()
//        
//        var index = 1
//        for p in result.playersChoice {
//            if (index == 1) {
//                player1_name.text = p.id
//                player1_score.text = String(p.points)
//                
//                if p.roundLost {
//                    player1_state.text = "SAFE"
//                }
//                else {
//                    player1_state.text = "LEVER"
//                }
//                if p.gameWon {
//                    player1_state.text = "HÄMTA"
//                }
//            }
//            else if (index == 2) {
//                player2_name.text = p.id
//                player2_score.text = String(p.points)
//                
//                if p.roundLost {
//                    player2_state.text = "SAFE"
//                }
//                else {
//                    player2_state.text = "LEVER"
//                }
//                if p.gameWon {
//                    player2_state.text = "HÄMTA"
//                }
//            }
//            else {
//                player3_name.text = p.id
//                player3_score.text = String(p.points)
//                
//                if p.roundLost {
//                    player3_state.text = "SAFE"
//                }
//                else {
//                    player3_state.text = "LEVER"
//                }
//                if p.gameWon {
//                    player3_state.text = "HÄMTA"
//                }
//            }
//            
//            index = index + 1
//        }
//        
//        print("tjena")
//    }
//
//    
//    func startNewGame(rounds: Int, numbrOfCoffebringers: Int) -> Void {
//        let id = "Host"
//        let player = Player(id: id, position: 0, name: id)
//        //lägger till host
//        game.players[0] = David
//    }
//    
//    func addPlayerToGame(id: String, name: String ) -> Void {
//        
//        let position = game.players.count
//        let player = Player(id: id, position: position, name: name)
//        game.players.append(player)
//    }
//    
//    
//    func newRound() -> Void {
//        for p in playerChoices{
//            p.roundLost = false
//            p.choice = 3
//        }
//    }
//    
//    func addPlayerChoices(playerChoice: PlayersChoice) -> Void {
//        playerChoices.append(playerChoice)
//    }
//    
//    func playRound() -> RoundResult{
//        
//        return GameLogic.calculateResult(playersChoice: playerChoices, game: game)
//    }
//    func getPlayerChoice() {
//        //Hämta val från vyn
//        GlobalData.MyChoice.choice = -1;
//        
//    }
    
}
