//
//  GameViewController.swift
//  ios_coffee_bringer
//
//  Created by Rikard Olsson on 2016-11-21.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoffeeKit

class GameViewController: UIViewController {

    @IBOutlet weak var playerField: CoffeePlayerField!
    @IBOutlet weak var spinnerRPS: CoffeeSpinnerCollectionView!
    @IBOutlet weak var currentIndicator: CoffeePinIndicatorCircularView!
    @IBOutlet weak var currentCoffeeImage: UIImageView!
    
    var game : Game!
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var startButton: UIBarButtonItem!
    var blePeripheral : BLEPeripheral!
    var viewLogic: ViewLogic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect to the view if nil, clients may have already set this
        if viewLogic == nil {
            self.connectView()
        }
        
        if BLEData.State == .Host{
            blePeripheral = BLEPeripheral()
            blePeripheral.setController(gameVC: self)
            let player = Player(id: "0", position: 0, name: Current.user!.name)
            BLEData.id = 0
            game.addPlayer(player: player)
            
            print("---VIEW DID LOAD---")
            print("GAME ID::: \(game.id)")
        }
        else {
            BLEData.peripheralDelegate.gameVC = self
        }
        
        startButton.isEnabled = false
        if BLEData.State == .Client {
            startButton.title = ""
            navigationItem.leftBarButtonItem?.isEnabled = false
            navigationItem.leftBarButtonItem?.title = ""
            navigationItem.leftBarButtonItem?.image = UIImage()
            navigationItem.title = game.host.name!
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewLogic.currentUserIndex = BLEData.id
        
        if BLEData.State == .Host {
            viewLogic!.currentUserIndex = Int(game.getPlayer(index: 0).id)
        }
    }
    
    func connectView() {
        // Set player view
        self.playerField.numberOfPlayers = game.maxPlayers-1
        
        // Set view logic
        self.viewLogic = ViewLogic(spinnerRPS: self.spinnerRPS,
                                   currentUserIndicator: self.currentIndicator,
                                   playerField: self.playerField,
                                   currentCoffeeImage: self.currentCoffeeImage
        )
    
    }
    
    func addPlayerToGame(id: String, name: String ) -> Void {
        if viewLogic == nil {
            connectView()
        }
        
        let position = game.currentPlayers
        let player = Player(id: id, position: position, name: name)
        
        game.addPlayer(player: player)
        
        print("----- PLAYER CONNECTED ----")
        print("ID::: \(player.id)")
        print("NAME::: \(player.name)")
        
        print("-HERE IS ALL PLAYERS-")
        for player in game.getAllPlayers() {
            print("NAME: \(player.name)")
        }
        
        if id != String(BLEData.id) {
            self.viewLogic.connectPlayer(index: Int(player.id)!, name: player.name)
        }
        
        self.viewLogic.currentUserIndex = BLEData.id
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultView" {
            let dc = segue.destination as! ResultViewController
            let roundResult = sender as! RoundResult

            for player in game!.getAllPlayers() {
                print(player.name)
            }
            
            print("---PREPARE TO RESULT VIEW---")
            print("GAME ID::: \(game.id)")

            var getters = [String]()
            var receivers = [String]()
            
            for pc in roundResult.playersChoice {
                let player = self.game.getAllPlayers().first(where: { (player) -> Bool in
                    return player.id == pc.id
                })
                
                if player != nil {
                    if pc.gameWon {
                        getters.append(player!.name)
                    } else {
                        receivers.append(player!.name)
                    }
                }
            }
            
            dc.getters = getters
            dc.receivers = receivers
        }
    }
    
    func preRoundView() {
        // Disable all buttons during round
        self.startButton.isEnabled = false
        self.closeButton.isEnabled = false
    }
    
    func postRoundView() {
        // Enable all buttons after round
        if BLEData.State == .Host {
            self.startButton.isEnabled = true
            self.closeButton.isEnabled = true
        }
    }
    
    @IBAction func startGameActionButton(_ sender: Any) {
        print("GAME ID::: \(self.game.id)")
        self.preRoundView()

        if BLEData.State == .Host{
        // Sending state 1 to start clients game
            
            blePeripheral.isPlaying = true
            
            let bleGameData = BluetoothGameData(
                numberOfPlayers: game.currentPlayers,
                maxPlayers: game.maxPlayers,
                pChoices: [PlayersChoice(id: "0", choice: 0)],
                state: 1,
                numberOfCoffeeBringers: game.numberOfCoffeBringers,
                rounds: game.rounds)
            
            blePeripheral.sendToClients(info: bleGameData.getWriteableString())
        }
        
        if let lastRoundResult = GameLogic.lastRoundResult {
            if !lastRoundResult.playersChoice.isEmpty {
                self.viewLogic!.preparePlayersForRound(preps: lastRoundResult.playersChoice, roundEnd: lastRoundResult.roundEnd)
            }
        }
        
        viewLogic!.beginNewRound { choicesCallback in
            if BLEData.State == .Client {
                //TODO: Take a litte look :)
                BLEData.peripheralDelegate.writeTo(
                    peripheral: BLEData.currentGame.host!,
                    info: BluetoothGameData(
                        numberOfPlayers: 0,
                        maxPlayers: 0,
                        pChoices: [
                            PlayersChoice(
                                id: String(BLEData.id),
                                choice: self.viewLogic!.spinnerRPS.selectedRPS
                            )
                        ],
                        state: 1,
                        numberOfCoffeeBringers: 0,
                        rounds: 0
                    ).getWriteableString())
            }
            
            BLEPeripheral.addToChoicesReceived(completion: { playerChoices in
                var choices = [Int:Int]()
                
                for pChoice in playerChoices {
                    choices[Int(pChoice.id)!] = pChoice.choice
                }

                let winnerCallback = choicesCallback(choices)
                let roundResult = GameLogic.calculateResult(playersChoice: playerChoices, game: self.game)
                
                if roundResult.gameEnd {
                    // After getting back from Result view, the values needs to be updated.
                    self.viewLogic!.preparePlayersForRound(preps: GameLogic.lastRoundResult.playersChoice, roundEnd: GameLogic.lastRoundResult.roundEnd)
                    
                    // Go to Result View
                    self.performSegue(withIdentifier: "showResultView", sender: roundResult)
                } else if roundResult.roundEnd {
                    for choice in roundResult.playersChoice {
                        if !choice.roundLost {
                            winnerCallback(Int(choice.id)!)
                        }
                    }
                }
                
                self.postRoundView()
            })

        }
    }
    
    @IBAction func unwindToGameView(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindFromResultView" {
            self.startButton.isEnabled = false
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }

    @IBAction func closeActionButton(_ sender: Any) {
        SweetAlert().showAlert("Close game?", subTitle: "You will not be able to come back.", style: .warning, buttonTitle: "Yes", buttonColor: UIColor.red, otherButtonTitle: "Cancel", otherButtonColor: UIColor.gray, action: { ok in
            
            if ok {
                if BLEData.State == .Host{
                    self.blePeripheral.sendToClients(info: "3")
                    
                    GlobalMethods.ResetFromPreviousGame()
                
                    if let m = self.blePeripheral.peripheralManager
                    {
                        m.stopAdvertising()
                        m.removeAllServices()
                        m.delegate = nil
                    }
                    self.blePeripheral.clients.removeAll()
                    self.blePeripheral = nil
                }
                _ = self.navigationController?.popViewController(animated: true)
            }
        })
    }
}
