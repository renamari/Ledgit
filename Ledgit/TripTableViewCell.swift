//
//  TripTableViewCell.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var tripColorImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var bottomImageView: UIImageView!

    fileprivate lazy var images: [UIImage] = [#imageLiteral(resourceName: "circle-icon"), #imageLiteral(resourceName: "heptagon-icon"), #imageLiteral(resourceName: "triangle-icon")]
    fileprivate lazy var colors: [UIColor] = [LedgitColor.coreBlue, LedgitColor.coreRed, LedgitColor.coreYellow, LedgitColor.coreGreen]

    override func awakeFromNib() {
        super.awakeFromNib()
        setupElements()
    }

    func configure(with trip: LedgitTrip, at indexPath: IndexPath) {
        tripNameLabel.text(trip.name)
        topLabel.text(trip.startDate)
        bottomLabel.text(trip.endDate)
        tripColorImageView.image(images[indexPath.section % images.count])
        tripColorImageView.tintColor = colors[indexPath.section % colors.count]
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupElements()
    }

    func setupElements() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark

        if #available(iOS 13.0, *) {
            tripNameLabel.color(isDarkMode ? .white : LedgitColor.navigationTextGray)
            topLabel.color(isDarkMode ? .white : LedgitColor.navigationTextGray)
            bottomLabel.color(isDarkMode ? .white : LedgitColor.navigationTextGray)
            topImageView.tintColor = isDarkMode ? .white : LedgitColor.navigationTextGray
            bottomImageView.tintColor = isDarkMode ? .white : LedgitColor.navigationTextGray
        } else {
            tripNameLabel.color(LedgitColor.navigationTextGray)
            topLabel.color(LedgitColor.navigationTextGray)
            bottomLabel.color(LedgitColor.navigationTextGray)
            topImageView.tintColor = LedgitColor.navigationTextGray
            bottomImageView.tintColor = LedgitColor.navigationTextGray
        }
    }
}
