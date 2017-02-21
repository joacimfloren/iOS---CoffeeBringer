//
//  RoomTableViewCell.swift
//  ios_coffee_bringer
//
//  Created by Rikard Olsson on 2016-11-16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {

    @IBOutlet weak var bestOfLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentPlayersLabel: UILabel!
    @IBOutlet weak var maxPlayersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
