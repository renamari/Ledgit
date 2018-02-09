//
//  CollapsibleDateHeaderView.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 1/28/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import UIKit

protocol CollapsibleDateHeaderViewDelegate {
    func toggleSection(_ header: CollapsibleDateHeaderView, section: Int)
}

class CollapsibleDateHeaderView: UITableViewHeaderFooterView {

    var delegate: CollapsibleDateHeaderViewDelegate?
    var section: Int = 0
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let scale: CGFloat = 0.35
    let headerPadding: CGFloat = 15
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = LedgitColor.navigationBarGray
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerTapped)))
        
        imageView.image = #imageLiteral(resourceName: "disclosure-icon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: scale).isActive = true
        imageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: scale).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -headerPadding).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        titleLabel.font = .futuraMedium14
        titleLabel.textColor = LedgitColor.navigationTextGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: headerPadding).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func headerTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleDateHeaderView else { return }
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        UIView.animate(withDuration: 0.75) {
            switch collapsed {
            case true:
                self.imageView.image = #imageLiteral(resourceName: "disclosure-icon")
            default:
                self.imageView.image = #imageLiteral(resourceName: "disclosure-down-icon")
            }
        }
    }
}
