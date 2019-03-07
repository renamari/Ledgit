//
//  TutorialViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    private(set) var pageIndex: Int!

    func configure(with content: LedgitTutorial, and index: Int) {
        _ = view
        titleLabel.text(content.title)
        backgroundImageView.image(content.image)
        descriptionLabel.text(content.description)
        pageIndex = index
    }
}
