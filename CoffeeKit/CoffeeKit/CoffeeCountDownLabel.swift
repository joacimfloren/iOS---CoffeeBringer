//
//  CoffeeCountDownLabel.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2016-12-08.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

class CoffeeCountDownLabel: UILabel {

    var number = 3
    var timer : Timer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.text = "\(self.number)"
    }
    
    public func startAnimateCountdown(callback: @escaping () -> Void) {
        self.isHidden = false
        self.number = 3
        self.text = "\(self.number)"
        DispatchQueue(label: "com.app.queue", qos: .background, target: nil).async {
            
            while(true) {
                sleep(1)
                if self.number > 1 {
                    self.number -= 1
                    
                    DispatchQueue.main.async {
                        self.text = "\(self.number)"
                    }
                } else {
                    break
                }
            }
            
            DispatchQueue.main.async {
                self.isHidden = true
                callback()
            }
        }
    }
}
