//
//  AddEntryViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 10/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var addEntryView: UIView!
    
    let cellHeightScale: CGFloat = Constants.Scales.cellHeight
    let cellWidthScale: CGFloat = Constants.Scales.cellWidth
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setupButton() {
        closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        
        closeButton.layer.cornerRadius = 25
        closeButton.layer.masksToBounds = true
        closeButton.clipsToBounds = true
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
