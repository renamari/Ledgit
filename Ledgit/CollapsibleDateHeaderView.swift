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
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let scale: CGFloat = 0.35
    let headerPadding: CGFloat = 15
    var delegate: CollapsibleDateHeaderViewDelegate?
    var section: Int = 0
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.style { view in
            view.backgroundColor = LedgitColor.navigationBarGray
            view.addSubview(imageView)
            view.addSubview(titleLabel)
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerTapped)))
        }

        imageView.style { view in
            view.image(#imageLiteral(resourceName: "disclosure-icon"))
            view.contentMode = .scaleAspectFit
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: scale).isActive = true
            view.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: scale).isActive = true
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -headerPadding).isActive = true
            view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        }
    
        titleLabel.style { label in
            label.font(.futuraMedium14)
            label.color(LedgitColor.navigationTextGray)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: headerPadding).isActive = true
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        }
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
            self.imageView.image(collapsed ? #imageLiteral(resourceName: "disclosure-icon") : #imageLiteral(resourceName: "disclosure-down-icon"))
        }
    }
}
