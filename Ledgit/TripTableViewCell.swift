//
//  TripTableViewCell.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var tripColorImageView: UIImageView!
    @IBOutlet weak var tripDateLabel: UILabel!
    @IBOutlet weak var tripLocationLabel: UILabel!

    func configure(with trip: Trip) {
        tripNameLabel.text = trip.name
        tripDateLabel.text = trip.startDate
        tripLocationLabel.text = "Paris, France"
        tripColorImageView.image = UIImage(named: cellImageNames[indexPath.row % 3])
        
        //cell.cascadeImages(with: trip.currencies)
        contentView.layoutIfNeeded()
    }
}
