//
//  DateTableViewCell.swift
//  Ledgit
//
//  Created by Camden Madina on 8/22/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLabels(amount: Double, description: String, category: String){
        amountLabel.text = Model.model.currentUser!.homeCurrency.symbol + String(format: "%.2f", amount)
        descriptionLabel.text = description
        categoryLabel.text = category
    }

}
