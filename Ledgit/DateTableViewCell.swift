//
//  DateTableViewCell.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/22/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    func updateLabels(amount: Double, description: String, category: String) {
        amountLabel.text(amount.currencyFormat())
        descriptionLabel.text(description)
        categoryLabel.text(category)
    }

    func setup(with entry: LedgitEntry) {
        amountLabel.text(entry.convertedCost.currencyFormat())
        descriptionLabel.text(entry.description)
        categoryLabel.text(entry.category)
    }
}
