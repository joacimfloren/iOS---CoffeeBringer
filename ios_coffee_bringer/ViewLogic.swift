//
//  ViewLogic.swift
//  ios_coffee_bringer
//
//  Created by Rikard Olsson on 2016-12-09.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import CoffeeKit

class PlayerPrepare {
    var id: Int
    var inGame: Bool
    var isCoffeeBringer: Bool
    
    init(id: Int, inGame: Bool, isCoffeeBringer: Bool) {
        self.id = id
        self.inGame = inGame
        self.isCoffeeBringer = isCoffeeBringer
    }
}

class ViewLogic {
    var currentUserIndex: Int!
    var currentUserIndicator: CoffeePinIndicatorCircularView
    var playerField: CoffeePlayerField
    var spinnerRPS: CoffeeSpinnerCollectionView
    var coffeeImage: UIImageView
    
    init(spinnerRPS: CoffeeSpinnerCollectionView, currentUserIndicator: CoffeePinIndicatorCircularView, playerField: CoffeePlayerField, currentCoffeeImage: UIImageView) {
        self.currentUserIndicator = currentUserIndicator
        self.playerField = playerField
        self.spinnerRPS = spinnerRPS
        //self.spinnerRPS.isScrollEnabled = false
        self.coffeeImage = currentCoffeeImage
    }
    
    func beginNewRound(choicesCallback: @escaping (_ choices: @escaping ([Int: Int]) -> ((Int) -> Void)) -> Void) {
        self.spinnerRPS.isScrollEnabled = true
        self.playerField.animatePlayerIsWaiting {
            self.spinnerRPS.isScrollEnabled = false
            
            choicesCallback({ (choices) in
                self.playerField.stopAnimatePlayerIsWaiting()
                for (key, value) in choices {
                    if key != self.currentUserIndex {
                        self.playerField.setPlayersRPS(at: key, choice: value)
                    }
                }
                
                return { winner in
                    if winner != self.currentUserIndex {
                        self.playerField.increaseIndicator(at: winner)
                    } else {
                        self.currentUserIndicator.increaseNumber()
                    }
                    
                }
            })
        }
    }
    
    func preparePlayersForRound(preps: [PlayersChoice], roundEnd: Bool) {
        
        if roundEnd {
            for prep in preps {
                let id = Int(prep.id)!
                if id != self.currentUserIndex {
                    if prep.gameWon {
                        self.playerField.disablePlayer(at: id, animation: true, asCoffeeBringer: prep.gameWon)
                    } else {
                        self.playerField.enablePlayer(at: id)
                    }
                } else {
                    if !prep.gameWon {
                        self.spinnerRPS.isHidden = false
                    } else {
                        self.spinnerRPS.hide(animation: true)
                        self.coffeeImage.isHidden = false
                        self.currentUserIndicator.isHidden = true
                    }
                }
            }
        } else {
            for prep in preps {
                let id = Int(prep.id)!
                if id != self.currentUserIndex {
                    if prep.roundLost || prep.gameWon {
                        self.playerField.disablePlayer(at: id, animation: true, asCoffeeBringer: prep.gameWon)
                    }
                } else {
                    if prep.roundLost || prep.gameWon {
                        self.spinnerRPS.hide(animation: true)
                        
                        if prep.gameWon {
                            self.coffeeImage.isHidden = false
                            self.currentUserIndicator.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    func resetForNewRound() {
        for index in 0...self.playerField.players.count-1 {
            if index != self.currentUserIndex {
                self.playerField.enablePlayer(at: index)
            }
        }
        
        self.spinnerRPS.isHidden = false
    }
    
    func setCurrentUser(index: Int) {
        self.currentUserIndex = index
    }
    
    func connectPlayer(index: Int, name: String) {
        self.playerField.connectPlayer(at: index, name: name)
    }
    
    func connectCurrentUser(index: Int) {
        self.currentUserIndex = index
    }
}
