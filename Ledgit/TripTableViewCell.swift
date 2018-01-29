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
    @IBOutlet weak var tripDateLabel: UILabel!
    @IBOutlet weak var tripLocationLabel: UILabel!
    
    fileprivate(set) lazy var cellImages:[UIImage] = {
        return [#imageLiteral(resourceName: "circle-icon"), #imageLiteral(resourceName: "heptagon-icon"), #imageLiteral(resourceName: "triangle-icon")]
    }()

    func configure(with trip: LedgitTrip, at indexPath: IndexPath) {
        tripNameLabel.text = trip.name
        tripDateLabel.text = trip.startDate
        tripLocationLabel.text = "Paris, France"
        tripColorImageView.image = cellImages[indexPath.row % 3]
        
        contentView.layoutIfNeeded()
        mainView.roundedCorners(radius: Constants.cornerRadius.tripCard)
        mainView.dropShadow()
    }
}
