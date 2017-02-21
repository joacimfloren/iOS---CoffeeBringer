//
//  CreateRoomViewController.swift
//  ios_coffee_bringer
//
//  Created by Joacim Florén on 2016-11-16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

class CreateRoomViewController: UIViewController {
    @IBOutlet weak var playersSlider: UISlider!
    @IBOutlet weak var firstToSlider: UISlider!
    let step: Float = 1
    var game : Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func playersValueChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
    }
    
    @IBAction func roundsValueChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
    }
    
    func getNumberOfCoffeeBringers(maxPlayers: Int) -> Int {
        switch maxPlayers {
        case 2:
            return 1
            
        case 3:
            return 2
            
        case 4:
            return 2
            
        case 5:
            return 3
            
        default:
            return 1
        }
    }

    @IBAction func createRoom(_ sender: UIButton) {
        let rounds = Int(firstToSlider.value)
        let name = "Okänd iPhones rum"
        let maxPlayers = Int(playersSlider.value)
        let coffeeBringers = getNumberOfCoffeeBringers(maxPlayers: maxPlayers)
        
        self.game = Game(id: 2, name: name, rounds: rounds, numberOfCoffeeBringers: coffeeBringers, maxPlayers: maxPlayers)
        BLEData.State = .Host
        
        self.performSegue(withIdentifier: "unwindFromCreateController", sender: nil)
    }

    @IBAction func stopActionButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
