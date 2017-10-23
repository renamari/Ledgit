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
    
    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        guard let index = index else { return }
        
        // 1. Change description label text and image
        backgroundImageView.image = pageImages[index]
        descriptionLabel.text = pageDescriptions[index]
        
        // 2. Change title text
        titleLabel.text = pageTitles[index]
    }
}
