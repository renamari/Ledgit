//
//  TutorialViewController.swift
//  Ledgit
//
//  Created by Camden Madina on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var descriptionText: String?
    var pageImage: UIImage?
    var titleText:String?
    var index:Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Change description label text and image
        backgroundImageView.image = pageImage
        descriptionLabel.text = descriptionText
        
        // 2. Change title text
        titleLabel.text = titleText
    }
}
