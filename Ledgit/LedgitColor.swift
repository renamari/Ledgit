//
//  LedgitColor.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 2/6/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import UIKit

class LedgitColor: UIColor {
    static let coreBlue             = UIColor(hex: 0x308CF9)!
    static let coreRed              = UIColor(hex: 0xFF7D7D)!
    static let coreGreen            = UIColor(hex: 0x27AE60)!
    static let lightPink            = UIColor(hex: 0xEF7BC6)!
    static let lightAqua            = UIColor(hex: 0x1F9DBF)!
    static let coreYellow           = UIColor(hex: 0xFFBA00)!
    static let facebookBlue         = UIColor(hex: 0x25479B)!
    static let separatorGray        = UIColor(hex: 0x9C9C9C)!
    static let navigationTextGray   = UIColor(hex: 0x3F6072)!
    static let navigationBarGray    = UIColor(hex: 0xF2F5F7)!
    
    // Bar chart colors
    
    static let pieChartBlue1        = UIColor(hex: 0x479AFF)!
    static let pieChartBlue2        = UIColor(hex: 0x0D4FDD)!
    static let pieChartBlue3        = UIColor(hex: 0x0C2E7C)!
    static let pieChartBlue4        = UIColor(hex: 0x4472CA)!
    static let pieChartBlue5        = UIColor(hex: 0x1B4079)!
    static let pieChartBlue6        = UIColor(hex: 0x064789)!
    static let pieChartRed          = UIColor(hex: 0xF3494C)!
    static let pieChartOrange       = UIColor(hex: 0xF07851)!
    static let pieChartGreen        = UIColor(hex: 0x169776)!
    static let pieChartLightPurple  = UIColor(hex: 0xBD92D2)!
    static let pieChartDarkPurple   = UIColor(hex: 0x653797)!
    static let pieChartDarkGray     = UIColor(hex: 0x22313F)!
    
    
}

extension UIColor {
    
    private convenience init?(hex6: Int, alpha: Float) {
        self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
    }
    
    public convenience init?(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    public convenience init?(hex: Int, alpha: Float) {
        if (0x000000 ... 0xFFFFFF) ~= hex {
            self.init(hex6: hex, alpha: alpha)
        } else {
            self.init()
            return nil
        }
    }
}
