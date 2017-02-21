//
//  CoffeeNavigationBar.swift
//  ios_coffee_bringer
//
//  Created by Rikard Olsson on 2016-11-16.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

@IBDesignable
public class CoffeeNavigationController: UINavigationController {

    override public func viewWillLayoutSubviews() {
        self.navigationBar.barStyle = UIBarStyle.black
    }
 

}
