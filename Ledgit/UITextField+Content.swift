//
//  UITextField+Content.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 3/4/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

extension UITextField {

    var isEmpty: Bool {
        if text == nil {
            return true

        } else if text!.isEmpty {
            return true

        } else {
            return false
        }
    }

    @discardableResult
    public func placeholder(_ t: String) -> Self {
        placeholder = t
        return self
    }

    @discardableResult
    public func text(_ t: String?) -> Self {
        text = t
        return self
    }

    func setEmpty() -> Self {
        text = ""
        return self
    }
}
