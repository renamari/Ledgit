//
//  UIButton+Content.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 3/4/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import UIKit

extension UIButton {
    
    @discardableResult
    public func text(_ t: String) -> Self {
        setTitle(t, for: .normal)
        return self
    }
    
    @discardableResult
    public func textKey(_ t: String) -> Self {
        text(NSLocalizedString(t, comment: ""))
        return self
    }
    
    @discardableResult
    public func image(_ s: String) -> Self {
        setImage(UIImage(named: s), for: .normal)
        return self
    }
    
    @discardableResult
    public func color(_ c: UIColor) -> Self {
        backgroundColor = c
        return self
    }
}
