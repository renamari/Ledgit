//
//  CityTableViewCell.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/22/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    func updateLabels(city:String, amount:Double){
        cityLabel.text = city
        amountLabel.text = LedgitUser.current.homeCurrency.symbol + String(format: "%.2f", amount)
    }
}
