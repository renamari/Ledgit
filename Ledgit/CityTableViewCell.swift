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
    @IBOutlet var totalLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupElements()
    }

    func updateLabels(city:String, amount:Double) {
        cityLabel.text(city)
        amountLabel.text(LedgitUser.current.homeCurrency.symbol + String(format: "%.2f", amount))
    }

    func setup(with section: CitySection) {
        cityLabel.text(section.location)
        amountLabel.text(LedgitUser.current.homeCurrency.symbol + String(format: "%.2f", section.amount))
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupElements()
    }

    func setupElements() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark

        if #available(iOS 13.0, *) {
            cityLabel.color(isDarkMode ? .white : LedgitColor.navigationTextGray)
            totalLabel.color(isDarkMode ? .white : LedgitColor.navigationTextGray)
        }
    }
}
