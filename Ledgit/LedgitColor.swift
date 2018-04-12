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

extension UIColor {
    //Grey color
    static var kColor4E4E4E: UIColor { return UIColor(red: 78.0/255.0, green: 78.0/255.0, blue: 78.0/255.0, alpha: 1.0)}
    //Light Gray Color
    static var kColorEBEBEB: UIColor { return UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)}
    //Text color gray
    static var kColor587685: UIColor { return UIColor(red: 88.0/255.0, green: 118.0/255.0, blue: 133.0/255.0, alpha: 1.0)}
    
    //MARK:- Pie Chart Colors
    static var kColor003559: UIColor {return UIColor(red: 0.0/255.0, green: 53.0/255.0, blue: 89.0/255.0, alpha: 1.0)}
    static var kColor061A40: UIColor { return UIColor(red: 6.0/255.0, green: 26.0/255.0, blue: 64.0/255.0, alpha: 1.0)}
    static var kColorB9D6F2: UIColor { return UIColor(red: 185.0/255.0, green: 214.0/255.0, blue: 242.0/255.0, alpha: 1.0)}
    static var kColor76DDFB: UIColor { return UIColor(red: 118.0/255, green: 221.0/255.0, blue: 251.0/255, alpha: 1.0)}
    static var kColor2C82BE: UIColor { return UIColor(red: 44.0/255.0, green: 130.0/255.0, blue: 190.0/255.0, alpha: 1.0)}
}
