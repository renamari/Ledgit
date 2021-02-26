//
//  ColorPalette.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 2/18/21.
//  Copyright © 2021 Camden Developers. All rights reserved.
//

import SwiftUI

public enum ColorPalette {
    public enum Role: String {
        case tint
        case destructive
        case positive
        case warning
        case primaryForeground
        case secondaryForeground
        case primaryBackground
        case secondaryBackground
    }
    
    static func color(for role: Role) -> UIColor {
        guard let color = UIColor(named: role.rawValue) else {
            fatalError("Unable to create a color for role: \(role.rawValue)")
        }
        
        return color
    }
    
    static func color(_ role: Role) -> Color {
        return Color(role.rawValue)
    }
}
