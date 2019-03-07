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
    public func text(_ text: String?) -> Self {
        self.text = text
        return self
    }

    @discardableResult
    public func textKey(_ text: String) -> Self {
        self.text(NSLocalizedString(text, comment: ""))
        return self
    }

    @discardableResult
    public func color(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }

    @discardableResult
    public func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
}
