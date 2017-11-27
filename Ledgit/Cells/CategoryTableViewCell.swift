//
//  CategoryTableViewCell.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/26/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        informationLabel.isHidden = true
    }
    
    func displayInformationLabel() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.informationLabel.isHidden = false
        }) { (success) in
            
            let delay = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.informationLabel.isHidden = true
            }
        }
    }
}
