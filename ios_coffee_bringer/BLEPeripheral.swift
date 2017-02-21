//
//  BLEPeripheral.swift
//  ios_coffee_bringer
//
//  Created by Johan Rasmussen on 01/12/16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEPeripheral : NSObject, CBPeripheralManagerDelegate {
    
    var peripheralManager : CBPeripheralManager?
    var characteristicReadable : CBMutableCharacteristic!
    var characteristicWriteable : CBMutableCharacteristic!
    var gameVC : GameViewController!
    
    var receivedPlayerChoices = [PlayersChoice]()
    
    static var choicesSent: [([PlayersChoice]) -> Void] = []
    
    var isPlaying = true
    
    static func addToChoicesReceived(completion: @escaping (_ choices: [PlayersChoice]) -> Void) {
        self.choicesSent.removeAll()
        self.choicesSent.append(completion)
    }
    
    
    // May not be in the game, just connected devices to talk to
    var clients = [CBCentral]()
    
    override init() {
        super.init()
        
        BLEData.centralManager.stopScan()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: [ CBPeripheralManagerOptionShowPowerAlertKey: true ])
        
    }
    
    func setController(gameVC: GameViewController){
        self.gameVC = gameVC
    }
    
    func sendToClients(info: String){
        peripheralManager?.updateValue(GlobalMethods.ConvertStringToData(value: info), for: characteristicReadable, onSubscribedCentrals: clients)
    }
    
    func readFrom(request: CBATTRequest) -> String {
        characteristicWriteable.value = request.value
        let result = GlobalMethods.ConvertDataToString(data: request.value!)
        return result
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager)
    {
        if ( peripheral.state == .poweredOn )
        {
            let advertisementData = [CBAdvertisementDataLocalNameKey: "Host"]
            peripheral.startAdvertising(advertisementData)
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        //print("Advertising...")
        // Service
        let serviceUUID = CBUUID(string: BLEData.serviceUuid)
        let service = CBMutableService(type: serviceUUID, primary: true)
        
        // Characteristics
        
        // Readable
        var characteristicUUID = CBUUID(string: BLEData.characteristicReadable)
        var properties: CBCharacteristicProperties = [.notify, .read]
        var permissions: CBAttributePermissions = [.readable]
        self.characteristicReadable = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: properties,
            value: nil,
            permissions: permissions
        )
        // Writeable
        characteristicUUID = CBUUID(string: BLEData.characteristicWriteable)
        properties = [.notify, .write]
        permissions = [.writeable]
        self.characteristicWriteable = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: properties,
            value: nil,
            permissions: permissions
        )
        
        service.characteristics = [characteristicReadable, characteristicWriteable]
        self.peripheralManager?.add(service)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        if request.characteristic.uuid.isEqual(self.characteristicReadable.uuid){
            
            let bleGameData = BluetoothGameData(
                numberOfPlayers: gameVC.game.currentPlayers,
                maxPlayers: gameVC.game.maxPlayers,
                pChoices: [PlayersChoice(id: "0", choice: 1)],
                state: 0,
                numberOfCoffeeBringers: gameVC.game.numberOfCoffeBringers,
                rounds: gameVC.game.rounds
            )
            
            sendToClients(info: bleGameData.getWriteableString())
            
            request.value = characteristicReadable.value
            self.peripheralManager?.respond(to: request, withResult: .success)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if request.characteristic.uuid.isEqual(characteristicWriteable.uuid){
                let result = readFrom(request: request)
                
                if let state = Int(String(result[(result.index(result.startIndex, offsetBy: 0))])) {
                    
                    if state == 1 {
                        
                        if isPlaying {
                            let bleGameData = BluetoothGameData(infoString: result)
                            for choice in bleGameData.playerChoices {
                                if choice.id == "9" {
                                    break
                                }
                                // May have to check for duplicates? Not sure yet
                                receivedPlayerChoices.append(choice)
                            }
                            
                            if receivedPlayerChoices.count >= gameVC.game.currentPlayers - 1 {
                             
                                isPlaying = false
                                
                                let myChoice = PlayersChoice()
                                myChoice.choice = gameVC.spinnerRPS.selectedRPS
                                myChoice.id = String(BLEData.id)
                                receivedPlayerChoices.append(myChoice)
                                
                                let bleGameData = BluetoothGameData(
                                    numberOfPlayers: gameVC.game.currentPlayers,
                                    maxPlayers: gameVC.game.maxPlayers,
                                    pChoices: receivedPlayerChoices,
                                    state: 2,
                                    numberOfCoffeeBringers: gameVC.game.numberOfCoffeBringers,
                                    rounds: gameVC.game.rounds
                                )
                                
                                let sendToClientsString = bleGameData.getWriteableString()
                                sendToClients(info: sendToClientsString)
                                
                                
                                DispatchQueue.global(qos: .background).async {
                                    
                                    // Wait for choicesSent to fill
                                    while(BLEPeripheral.choicesSent.isEmpty){}
                                    
                                    DispatchQueue.main.async {
                                        BLEPeripheral.choicesSent[0](self.receivedPlayerChoices)
                                        self.receivedPlayerChoices.removeAll()
                                    }
                                }
                                
                            }
                        }
                        
                        
                    }
                    else if state == 8 {
                        let blePlayerData = BluetoothPlayerData(state: 9, players: gameVC.game.getAllPlayers())
                            sendToClients(info: blePlayerData.getWriteableString())
                    
                        if gameVC.game.currentPlayers >= gameVC.game.maxPlayers {
                            gameVC.startButton.isEnabled = true
                        }
                    
                    }
                    else if state == 9 {
                        
                        if gameVC.game.currentPlayers < gameVC.game.maxPlayers {
                            var hasReadState = false
                            var name = ""
                            var hasReadName = false
                            var validationString = ""
                            for character in result.characters {
                                if !hasReadState{
                                    hasReadState = true
                                    continue
                                }
                                
                                if character == ";"{
                                    hasReadName = true
                                    continue
                                }
                                
                                if !hasReadName {
                                    name += String(character)
                                    continue
                                }
                                
                                validationString += String(character)
                            }
                            
                            gameVC.addPlayerToGame(id: String(gameVC.game.currentPlayers), name: name)
                            // Sending state 8
                            sendToClients(info: "8\(gameVC.game.currentPlayers - 1)\(validationString)")
                        }
                        
                    }
                    
                }
                
                peripheralManager?.respond(to: request, withResult: .success)
            }
        }

    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        
        for var client in self.clients {
            if client == central{
                // Duplicate, update new connection
                client = central
                return
            }
        }
        
        // Save centrals, these are the clients
        //print("Subscribed \(central)")
        
        clients.append(central)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        // Not relevant at this point
        
    }
    
}
