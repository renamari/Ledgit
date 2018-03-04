//
//  UILayout+Content.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 3/4/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import UIKit

extension UILayoutPriority: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    public init(floatLiteral value: Float) {
        self.init(rawValue: value)
    }
    
    public init(integerLiteral value: Int) {
        self.init(rawValue: Float(value))
    }
    
    public static func +(lhs: UILayoutPriority, rhs: UILayoutPriority) -> UILayoutPriority {
        return UILayoutPriority(rawValue: lhs.rawValue + rhs.rawValue)
    }
    
    public static func -(lhs: UILayoutPriority, rhs: UILayoutPriority) -> UILayoutPriority {
        return UILayoutPriority(rawValue: lhs.rawValue - rhs.rawValue)
    }
}
