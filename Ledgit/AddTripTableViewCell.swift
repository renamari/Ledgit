//
//  AddTripTableViewCell.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class AddTripTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var contentStackView: UIStackView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainView.dashedBorder(withColor: UIColor.kColor3F6072.cgColor)
        mainView.addSubview(contentStackView)
    }
    
    func configure() {
        contentView.layoutIfNeeded()
    }
}
