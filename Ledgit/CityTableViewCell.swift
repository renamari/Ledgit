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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLabels(city:String, amount:Double){
        cityLabel.text = city
        amountLabel.text = Model.model.currentUser!.homeCurrency.symbol + String(format: "%.2f", amount)
    }

}
