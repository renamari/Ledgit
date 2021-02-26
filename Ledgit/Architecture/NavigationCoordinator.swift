//
//  NavigationCoordinator.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 2/17/21.
//  Copyright © 2021 Camden Developers. All rights reserved.
//

import UIKit

open class NavigationCoordinator: UINavigationController {
    public var prefersLargeTitles: Bool { true }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCoordinator()
    }
    
    open func setupLayout() {
        navigationBar.prefersLargeTitles = prefersLargeTitles
    }
    
    open func setupCoordinator() {
        fatalError("Please override `setupCoordinator()`")
    }
    
    public final func setRoot(_ view: UIViewController, animated: Bool = true) {
        navigate(withAction: .setStack([view]), animated: animated)
    }
}
