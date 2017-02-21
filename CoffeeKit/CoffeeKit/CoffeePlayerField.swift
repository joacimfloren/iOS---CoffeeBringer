//
//  CoffeePlayerField.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2016-11-25.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

public class ColorPair {
    var border: UIColor
    var fill: UIColor
    
    init(border: UIColor, fill: UIColor) {
        self.border = border
        self.fill = fill
    }
}

class PlayerPosition {
    var playerPositions = [Int:Int]()
    var count = 0
    
    func put(at: Int) -> Int {
        let position = count
        self.playerPositions[count] = at
        count += 1
        
        return position
    }
    
    func get(at: Int) -> Int {
        let result = self.playerPositions.first { (key, value) -> Bool in
            return value == at
        }
        
        if let result = result {
            return result.key
        } else {
            return -1
        }
    }
}


@IBDesignable
public class CoffeePlayerField: UIView {
    
    public var numberOfPlayers : Int = 4

    var colorPairs = [
        ColorPair(
            border: UIColor(netHex: 0x2ecc71),
            fill: UIColor(netHex: 0x0dae51)
        ),
        ColorPair(
            border: UIColor(netHex: 0x8e44ad),
            fill: UIColor(netHex: 0x70278f)
        ),
        ColorPair(
            border: UIColor(netHex: 0xd35400),
            fill: UIColor(netHex: 0xa74200)
        ),
        ColorPair(
            border: UIColor(netHex: 0x3498db),
            fill: UIColor(netHex: 0x2282c3)
        ),
        ColorPair(
            border: UIColor(netHex: 0x818181),
            fill: UIColor(netHex: 0x5d5d5d)
        )
    ]
    
    public var players : [CoffeePlayer] = [CoffeePlayer(), CoffeePlayer(), CoffeePlayer(), CoffeePlayer()]
    var playerPositions = PlayerPosition()
    
    var countDownLabel = CoffeeCountDownLabel()
    var overlay = UIView()
    var isInit = false
    
    let width : CGFloat = 100
    let height : CGFloat = 130
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // Init the view
        if !isInit {
            isInit = true
            
            // Set view
            self.setView(numOfPlayers: self.numberOfPlayers)
            self.countDownLabel.isHidden = true
            
            // Init overlay
            self.initOverlay()
            
            // Init Count Down Label
            self.initCountDownLabel()
        }
    }
    
    func initOverlay() {
        self.overlay.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.overlay.backgroundColor = UIColor.white
        self.overlay.alpha = 0.0
        self.addSubview(self.overlay)
    }
    
    func initCountDownLabel() {
        let width = CGFloat(500)
        let height = CGFloat(500)
        let x = self.bounds.width/2 - width/2
        let y = self.bounds.height/2 - height/2
        
        self.countDownLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        self.countDownLabel.textAlignment = .center
        self.countDownLabel.adjustsFontSizeToFitWidth = true
        self.countDownLabel.text = "3"
        self.countDownLabel.font = self.countDownLabel.font.withSize(60)
        self.countDownLabel.textColor = UIColor.black
        
        self.addSubview(self.countDownLabel)
    }
    
    func getPosition(numOfPlayers: Int, index: Int) -> CGPoint {
        let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        var point = CGPoint()
        
        let margin = width/2
        
        switch numOfPlayers {
        case 1:
            point = CGPoint(x: center.x-margin, y: center.y-margin)
            break
            
        case 2:
            let stick = self.bounds.width/4
            switch index {
            case 0:
                point = CGPoint(x: stick-margin, y: center.y-margin)
                break
                
            case 1:
                point = CGPoint(x: stick*3-margin, y: center.y-margin)
                break
                
            default:
                point = CGPoint(x: stick-margin, y: center.y-margin)
            }
            break
        case 3:
            switch index {
            case 0:
                point = CGPoint(x: center.x/2-margin, y: center.y+center.y/2-margin)
                break
                
            case 1:
                point = CGPoint(x: (center.x/2)*3-margin, y: center.y+center.y/2-margin)
                break
                
            case 2:
                point = CGPoint(x: center.x-margin, y: center.y-center.y/2-margin)
                break
                
            default:
                point = CGPoint(x: center.x/2-margin, y: center.y+center.y/2-margin)
            }
            break
        case 4:
            let w4 = center.x/2
            let h4 = center.y/2
            
            switch index {
            case 0:
                point = CGPoint(x: w4-margin, y: h4-margin)
                break
                
            case 1:
                point = CGPoint(x: center.x+w4-margin, y: h4-margin)
                break
                
            case 2:
                point = CGPoint(x: w4-margin, y: center.y+h4-margin)
                break
                
            case 3:
                point = CGPoint(x: center.x+w4-margin, y: center.y+h4-margin)
                break
                
            default:
                point = CGPoint(x: w4-margin, y: h4-margin)
            }
        break
            
        default:
            point = CGPoint(x: self.bounds.width/2-margin, y: self.bounds.height/2-margin)
        }
        
        return point
    }
    
    func setView(numOfPlayers: Int) {
        
        // Reset players
        self.players = [CoffeePlayer(), CoffeePlayer(), CoffeePlayer(), CoffeePlayer()]
        for index in 0..<numOfPlayers {
            let point = self.getPosition(numOfPlayers: numOfPlayers, index: index)
            let player = self.players[index]
            player.frame = CGRect(x: point.x, y: point.y, width: width, height: height)
            
            player.activeColorPair = colorPairs[index]
            player.unactiveColorPair = colorPairs[colorPairs.count-1]
            player.setUnactive()
            player.borderWidth = 6
            player.layoutIfNeeded()
            
            if (index % 2) != 0 {
                player.circularRPSView.updateCircularView(orientation: .RIGHT)
                player.rpsView.setOrientation(orientation: .LEFT)
                player.circularRPSView.layoutIfNeeded()
            } else {
                player.rpsView.setOrientation(orientation: .RIGHT)
            }
            
            self.addSubview(player)
        }
    }
    
    func updateView(numberOfPlayers: Int){
        if numberOfPlayers >= 0 && numberOfPlayers < 5 {
            self.subviews.forEach({ $0.removeFromSuperview() })
            
            if numberOfPlayers > 0 {
                self.setView(numOfPlayers: numberOfPlayers)
            }
        }
    }
    
    public func animatePlayerIsWaiting(callback: @escaping () -> Void) {
        for player in self.players {
            player.startLoadingAnimation()
        }
        
        self.countDownLabel.startAnimateCountdown(callback: callback)
    }
    
    public func stopAnimatePlayerIsWaiting() {
        for player in self.players {
            player.stopLoadingAnimation()
        }
    }
    
    public func setPlayersRPS(at: Int, choice: Int) {
        if inRangeOfRPS(number: choice) && inRangeOfNumOfPlayers(number: at) {
            let player = getPlayerBy(position: at)
            
            if !player.isCoffeeBringer {
                player.setImage(number: choice)
            }
        }
    }
    
    public func connectPlayer(at: Int, name: String) {
        if inRangeOfNumOfPlayers(number: at) {
            let index = playerPositions.put(at: at)
            let player = self.players[index]
            
            player.connect(name: name)
            player.setActive()
            
            player.layoutIfNeeded()
        }
    }
    
    public func increaseIndicator(at: Int, increaseWith: Int = 1) {
        self.setIndicator(at: at, with: increaseWith)
    }
    
    public func setIndicator(at: Int, with: Int) {
        if inRangeOfNumOfPlayers(number: at) {
            let player = getPlayerBy(position: at)
            
            player.circularRPSView.indicator.increaseNumber()
        }
    }
    
    public func enablePlayer(at: Int) {
        if inRangeOfNumOfPlayers(number: at) {
            let player = getPlayerBy(position: at)
            
            if !player.isCoffeeBringer {
                player.rpsView.isHidden = false
                player.disabled = false
            }
        }
    }
    
    public func disablePlayer(at: Int, animation: Bool = false, asCoffeeBringer: Bool = false) {
        if inRangeOfNumOfPlayers(number: at) {
            let player = getPlayerBy(position: at)
            
            if !player.disabled && !asCoffeeBringer {
                player.rpsView.hide(animation: animation)
                player.disabled = true
            } else if !player.disabled && asCoffeeBringer {
                player.setAsCoffeeBringer()
            }
        }
    }
    
    func inRangeOfRPS(number: Int) -> Bool {
        if number >= 0 && number < 3 {
            return true
        }
        
        return false
    }
    
    func inRangeOfNumOfPlayers(number: Int) -> Bool {
        if number >= 0 && number <= self.numberOfPlayers {
            return true
        }
        
        return false
    }
    
    func getPlayerBy(position: Int) -> CoffeePlayer {
        let index = playerPositions.get(at: position)
        let player = self.players[index]
        
        return player
    }
    
    public func coffeeBringerIs(at: Int) {
        if inRangeOfNumOfPlayers(number: at) {
            let player = self.getPlayerBy(position: at)
            
            player.setAsCoffeeBringer()
        }
    }
}
