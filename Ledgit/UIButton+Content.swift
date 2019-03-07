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
    public func text(_ title: String) -> Self {
        setTitle(title, for: .normal)
        return self
    }

    @discardableResult
    public func textKey(_ title: String) -> Self {
        text(NSLocalizedString(title, comment: ""))
        return self
    }

    @discardableResult
    public func image(_ string: String) -> Self {
        setImage(UIImage(named: string), for: .normal)
        return self
    }

    @discardableResult
    public func color(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
}
