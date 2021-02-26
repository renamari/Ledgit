//
//  InsightsCoordinator.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 2/17/21.
//  Copyright © 2021 Camden Developers. All rights reserved.
//

import SwiftUI

final class InsightsCoordinator: NavigationCoordinator {
    override func setupCoordinator() {
        let controller = UIHostingController(rootView: InsightsView())
        setRoot(controller)
    }
}
