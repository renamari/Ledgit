//
//  TutorialViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    fileprivate var pageTitles: [String] = Constants.pageTitles
    fileprivate var pageImages: [UIImage] = Constants.pageImages
    fileprivate var pageDescriptions: [String] = Constants.pageDescriptions
    var index: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        titleLabel.text(pageTitles[index])
        backgroundImageView.image = pageImages[index]
        descriptionLabel.text(pageDescriptions[index])
    }
}
