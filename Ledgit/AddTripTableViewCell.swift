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
    
    var stackView: UIStackView {
        let addImageView = UIImageView(image: #imageLiteral(resourceName: "add-icon"))
        let label = UILabel()
        label.text = "Add Trip"
        label.font(.futuraMedium21)
        label.color(LedgitColor.navigationTextGray)
        
       let stackView = UIStackView(arrangedSubviews: [addImageView, label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .horizontal
        
        return stackView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainView.dashedBorder(withColor: LedgitColor.navigationTextGray.cgColor)
    }
    
    func configure() {
        contentView.layoutIfNeeded()
        mainView.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
        stackView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor)
    }
}
