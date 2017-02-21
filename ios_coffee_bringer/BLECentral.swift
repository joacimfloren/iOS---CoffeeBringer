//
//  BLEHandler.swift
//  ios_coffee_bringer
//
//  Created by Johan Rasmussen on 24/11/16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLECentral : NSObject, CBCentralManagerDelegate {
    
    var roomsViewController: RoomsViewController!
    var gameViewController: GameViewController!
    
    override init() {
        super.init()
        BLEData.centralManager = CBCentralManager(delegate: self, queue: nil)
        BLEData.centralManager.delegate = self
    }
    
    func refresh(){
        print("Bluetooth: Refreshing..")
        
        BLEData.isPlayingGame = false
        
        for device in BLEData.foundDevices{
            BLEData.centralManager.cancelPeripheralConnection(device)
        }
        BLEData.foundDevices.removeAll()
        BLEData.games.removeAll()
        BLEData.centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber(value: false as Bool)])
        self.roomsViewController.refreshController.endRefreshing()
        self.roomsViewController.tableView.reloadData()
    }
    
    //MARK: CentralManager
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unsupported:
            print("Bluetooth: Unsupported")
        case .unauthorized:
            print("Bluetooth: Unauthorized")
        case .unknown:
            print("Bluetooth: Unknown")
        case .resetting:
            print("Bluetooth: Resetting")
        case .poweredOff:
            print("Bluetooth: Powered off")
        case .poweredOn:
            print("Bluetooth: Powered on")
            self.refresh()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        BLEData.foundDevices.append(peripheral)
        BLEData.centralManager.connect(peripheral, options: nil)
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
  
        peripheral.delegate = BLEData.peripheralDelegate
        peripheral.discoverServices([CBUUID(string: BLEData.serviceUuid)])
    }
}
