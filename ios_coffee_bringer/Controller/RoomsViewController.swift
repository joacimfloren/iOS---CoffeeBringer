//
//  RoomsViewController.swift
//  ios_coffee_bringer
//
//  Created by Rikard Olsson on 2016-11-16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import ObjectMapper
import UIKit
import CoreBluetooth

class RoomsViewController: UITableViewController {

    @IBOutlet weak var refreshController: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshController.addTarget(self, action: #selector(RoomsViewController.refresh), for: UIControlEvents.valueChanged)
        
        BLEData.bleCentral.roomsViewController = self
        
        // Check and see if we need user name
        self.initUser()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.refresh()
    }
    
    func initUser() {
        if let user = loadUser() {
            Current.user = user
        } else {
            self.performSegue(withIdentifier: "showInitialView", sender: nil)
        }
    }
    
    func refresh(){
        //self.refreshController.beginRefreshing()
        BLEData.bleCentral.refresh()
    }
    
    func loadUser() -> User? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User
        
        //TODO: Remove, just for test
        //return User(name: "Rikard")
    }

    func updateRoom(game: Game, bleGameData: BluetoothGameData){
        game.currentPlayers = bleGameData.numberOfPlayers
        self.tableView.reloadData()
    }
    
    func generateRandomStringWithLength(length: Int) -> String {
        
        var randomString = ""
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        for _ in 1...length {
            let randomIndex  = Int(arc4random_uniform(UInt32(letters.characters.count)))
            let a = letters.index(letters.startIndex, offsetBy: randomIndex)
            randomString +=  String(letters[a])
        }
        
        return randomString
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGameView" {
            BLEData.isPlayingGame = true
            let dc = segue.destination as! GameViewController
            dc.game = sender as! Game
        }
    }
    
    @IBAction func addActionButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showCreateView", sender: nil)
    }
    
    @IBAction func editNameActionButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showInitialView", sender: nil)
    }
    @IBAction func unwindToRoomsController(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindFromCreateController" {
            let createVC = segue.source as! CreateRoomViewController
            
            DispatchQueue.main.async {
                BLEData.State = .Host
                self.performSegue(withIdentifier: "showGameView", sender: createVC.game)
            }
        }
    }
    
    //MARK:- TABLE VIEW FUNCTIONS
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BLEData.games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTableViewCell", for: indexPath) as! RoomTableViewCell
        let data = BLEData.games[indexPath.row]
        
        cell.bestOfLabel.text = "BEST OF \(data.rounds)"
        cell.nameLabel.text = data.name+"'S GAME"
        cell.currentPlayersLabel.text = "\(data.currentPlayers)"
        cell.maxPlayersLabel.text = "\\\(data.maxPlayers)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BLEData.currentGame = BLEData.games[indexPath.row]
        
        if BLEData.currentGame.currentPlayers < BLEData.currentGame.maxPlayers {
            
            BLEData.validationString = generateRandomStringWithLength(length: 5)
            
                BLEData.peripheralDelegate.writeTo(peripheral: BLEData.currentGame.host, info: "9\(Current.user!.name);\(BLEData.validationString)")
                BLEData.waitingForId = true
                self.performSegue(withIdentifier: "showGameView", sender: BLEData.currentGame)
            
        } else {
            _ = SweetAlert().showAlert(BLEData.currentGame.host.name! + " says:", subTitle: "The game is full!", style: .warning, buttonTitle: "Ok", buttonColor: UIColor.gray, action: { ok in
                
            })
            
        }
        
    }
    
}
