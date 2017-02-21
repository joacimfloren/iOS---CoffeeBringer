//
//  ResultViewController.swift
//  ios_coffee_bringer
//
//  Created by Rikard Olsson on 2016-11-21.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit
import CoffeeKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultReceiversLabel: CoffeeResultsLabel!
    @IBOutlet weak var resultGettersLabel: CoffeeResultsLabel!
    
    var receivers = [String]()
    var getters = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.resultReceiversLabel.setText(names: receivers)
        self.resultGettersLabel.setText(names: getters)
    }
    
    @IBAction func okActionButton(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindFromResultView", sender: nil)
    }

}
