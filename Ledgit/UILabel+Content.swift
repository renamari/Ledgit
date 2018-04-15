//
//  UILabel+Content.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 3/4/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import UIKit

extension UILabel {

    @discardableResult
    public func text(_ t: String?) -> Self {
        text = t
        return self
    }
    
    @discardableResult
    public func textKey(_ t: String) -> Self {
        text(NSLocalizedString(t, comment: ""))
        return self
    }
    
    @discardableResult
    public func color(_ c: UIColor) -> Self {
        textColor = c
        return self
    }
    
    @discardableResult
    public func font(_ f: UIFont) -> Self {
        font = f
        return self
    }
}
