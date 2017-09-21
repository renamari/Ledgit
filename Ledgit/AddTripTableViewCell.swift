//
//  AddTripTableViewCell.swift
//  Ledgit
//
//  Created by Camden Madina on 8/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class AddTripTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var contentStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainView.dashedBorder(withColor: UIColor.kColor3F6072.cgColor)
        mainView.addSubview(contentStackView)
    }
}
