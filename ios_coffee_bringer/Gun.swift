//
//  Gun.swift
//  ios_coffee_bringer
//
//  Created by Rikard Olsson on 2016-12-12.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import Foundation

public class Gun<T> {
    
    typealias EventHandler = (T) -> ()
    
    private var eventHandlers = [EventHandler]()
    
    func load(handler: @escaping EventHandler) {
        eventHandlers.append(handler)
    }
    
    func fire(data: T) {
        for handler in eventHandlers {
            handler(data)
        }
    }
}
