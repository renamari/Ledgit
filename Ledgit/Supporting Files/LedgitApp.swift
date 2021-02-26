//
//  LedgitApp.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 2/18/21.
//  Copyright © 2021 Camden Developers. All rights reserved.
//

import SwiftUI

@main
struct LedgitApp: App {
    init() {
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                InsightsView()
            }
        }
    }
}
