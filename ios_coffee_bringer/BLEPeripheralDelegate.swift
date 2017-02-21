//
//  BLEPeripheralDelegate.swift
//  ios_coffee_bringer
//
//  Created by Johan Rasmussen on 05/12/16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth

class BLEPeripheralDelegate : NSObject, CBPeripheralDelegate {
    
    var characteristicWrite : CBCharacteristic!
    var characteristicRead : CBCharacteristic!
    var gameVC : GameViewController!
    
    override init(){
        super.init()
    }
    
    func writeTo(peripheral: CBPeripheral, info: String){
        
        if characteristicWrite == nil {
            return
        }
        
        let data = GlobalMethods.ConvertStringToData(value: info)
        peripheral.writeValue(data as Data, for: characteristicWrite, type: CBCharacteristicWriteType.withResponse)
    }
    func readFrom(peripheral: CBPeripheral){
        
        if characteristicRead == nil {
            return
        }
        
        peripheral.readValue(for: characteristicRead)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let servicePeripheral = peripheral.services! as [CBService]! {
            for service in servicePeripheral {
                peripheral.discoverCharacteristics([CBUUID(string: BLEData.characteristicReadable), CBUUID(string: BLEData.characteristicWriteable)], for: service)
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if (service.characteristics! as [CBCharacteristic]!) != nil {
            for characteristic in service.characteristics! {
                
                if characteristic.uuid.uuidString == BLEData.characteristicWriteable{
                    if characteristicWrite == nil{
                        characteristicWrite = characteristic
                    }
                } else {
                    if characteristicRead == nil {
                        characteristicRead = characteristic
                    }
                    peripheral.setNotifyValue(true, for: characteristic)
                    readFrom(peripheral: peripheral)
                }
                
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        // Is notifying
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let data = characteristic.value{
            
            if characteristic.uuid.uuidString == BLEData.characteristicReadable {
                
                let info = GlobalMethods.ConvertDataToString(data: data)
                
                if info == ""{
                    return
                }
                print(info)
                if let state = Int(String(info[(info.index(info.startIndex, offsetBy: 0))])) {
                    
                    if state == 0 {
                        let bleGameData = BluetoothGameData(infoString: info)
                        
                        let tempGame: Game!
                        
                        if peripheral.name != nil {
                            tempGame = Game(id: 0, name: peripheral.name!, rounds: bleGameData.rounds, numberOfCoffeeBringers: bleGameData.numberOfCoffeeBringers, maxPlayers: bleGameData.maxPlayers, currentPlayers: bleGameData.numberOfPlayers)
                        }
                        else {
                            tempGame = Game(id: 1, name: peripheral.identifier.uuidString, rounds: bleGameData.rounds, numberOfCoffeeBringers: bleGameData.numberOfCoffeeBringers, maxPlayers: bleGameData.maxPlayers, currentPlayers: bleGameData.numberOfPlayers)
                        }
                        
                        tempGame.host = peripheral
                        
                        var shouldAppend = true
                        var existingGame: Game!
                        for room in BLEData.games {
                            if room.name == tempGame.name {
                                shouldAppend = false
                            }
                        }
                        if shouldAppend {
                            BLEData.games.append(tempGame)
                            BLEData.bleCentral.roomsViewController.tableView.reloadData()
                        }
                        else {
                            if existingGame != nil {
                                BLEData.bleCentral.roomsViewController.updateRoom(game: existingGame, bleGameData: bleGameData)
                            }
                        }
                    }
                    
                    if BLEData.isPlayingGame {
                        if state == 1 {
                            gameVC.startGameActionButton(self)
                        }
                        else if state == 2 {
                            // Receive player choices and show results
                            let bleGameData = BluetoothGameData(infoString: info)
                            BLEPeripheral.choicesSent[0](bleGameData.playerChoices)
                        }
                        else if state == 3 {
                            
                            GlobalMethods.ResetFromPreviousGame()
                            
                            SweetAlert().showAlert(peripheral.name! + " says:", subTitle: "The host closed the game", style: .warning, buttonTitle: "Ok", buttonColor: UIColor.gray, action: { ok in
            
                                   self.gameVC.navigationController?.popToRootViewController(animated: true)
                                
                            })
            
                            
                        }
                        else if state == 8  && BLEData.waitingForId {
                            
                            var hasSkippedState = false
                            var hasGottenId = false
                            var id = 9
                            var validationString = ""
                            for character in info.characters{
                                if !hasSkippedState{
                                    hasSkippedState = true
                                    continue
                                }
                                if !hasGottenId {
                                    id = Int(String(character))!
                                    hasGottenId = true
                                    continue
                                }
                                
                                validationString += String(character)
                            }
                            
                            if validationString == BLEData.validationString {
                                BLEData.id = id
                                BLEData.waitingForId = false
                                writeTo(peripheral: BLEData.currentGame.host, info: "8")
                            }
                        }
                        else if state == 9 {
                            let blePlayerData = BluetoothPlayerData(infoString: info)
                            for player in blePlayerData.players {
                                if player.id != "9"{
                                    
                                    if !gameVC.game.getAllPlayers().contains(where: { (p) -> Bool in
                                        return p.id == player.id
                                    }) {
                                        gameVC.addPlayerToGame(id: player.id, name: player.name)
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            return
        }
    }

}
