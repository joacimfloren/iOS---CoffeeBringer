//
//  BLEConstants.swift
//  ios_coffee_bringer
//
//  Created by Johan Rasmussen on 21/11/16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

enum STATE {
    case Host
    case Client
}

class BLEData {
    static let serviceUuid = "00000000-0000-0000-0000-000000001111"
    static let characteristicReadable = "00000000-0000-0000-0000-000000002222"
    static let characteristicWriteable = "00000000-0000-0000-0000-000000003333"
    
    static var State = STATE.Client
    static var bleCentral = BLECentral()
    static var peripheralDelegate = BLEPeripheralDelegate()
    static var games = [Game]()
    static var currentGame : Game!
    static var centralManager: CBCentralManager!
    static var foundDevices = [CBPeripheral]()
    static var waitingForId = false
    
    static var id = 9
    static var validationString = ""
    static var isPlayingGame = false
}
