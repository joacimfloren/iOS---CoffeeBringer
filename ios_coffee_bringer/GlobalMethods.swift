//
//  GlobalMethods.swift
//  ios_coffee_bringer
//
//  Created by Johan Rasmussen on 01/12/16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import Foundation

class GlobalMethods{
    static func ConvertStringToData(value: String) -> Data{
        let bytes = value.utf8
        
        let buffer = [UInt8](bytes)
        let data = NSData(bytes: buffer, length: buffer.count)
        return data as Data
    }
    
    static func ConvertDataToString(data: Data) -> String{
        let numberOfBytes = data.count
        var byteArray = [UInt8](repeating: 0, count: numberOfBytes)
        (data as NSData).getBytes(&byteArray, length: numberOfBytes)
        
        if let result = String(bytes: byteArray, encoding: String.Encoding.utf8) {
            return result
        }
        return "Data corrupted"
    }
    
    static func ResetFromPreviousGame(){
        GameLogic.lastRoundResult = nil
        GameLogic.coffeeBringerCounter = 0
        BLEData.State = .Client
    }
    
}
