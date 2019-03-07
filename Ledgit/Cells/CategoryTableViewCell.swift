//
//  CategoryTableViewCell.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/26/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import AMPopTip

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        informationLabel.isHidden = true
    }

    func displayInformationLabel(on view: UIView) {
        let popTip = PopTip()
        popTip.style(PopStyle.default)
        popTip.show(text: "Swipe cells for actions",
                    direction: .down, maxWidth: 200,
                    in: view, from: frame, duration: 3)
    }
}
