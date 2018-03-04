//
//  UIImageView+Content.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 3/4/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import UIKit

extension UIImageView {
    @discardableResult
    public func image(_ i: UIImage) -> Self {
        image = i
        return self
    }
}

