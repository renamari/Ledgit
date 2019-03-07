//
//  UIView+Content.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 3/4/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import UIKit

extension UIView {

    func addTapRecognizer(with action: Selector) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: action)
        self.addGestureRecognizer(tapRecognizer)
    }

    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = LedgitColor.separatorGray.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func roundedCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }

    func roundedCorners(radius: CGFloat, borderColor: UIColor) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 1
    }

    func dashedBorder(withColor color: CGColor) {
        self.layer.sublayers?.last?.removeFromSuperlayer()

        let layer = CAShapeLayer()
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        layer.frame = frame
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color
        layer.lineWidth = 1
        layer.lineJoin = CAShapeLayerLineJoin.round
        layer.lineDashPattern = [4 , 2]
        layer.path = UIBezierPath(roundedRect: frame, cornerRadius: 5).cgPath
        layer.masksToBounds = true
        self.layer.addSublayer(layer)

    }

    // view1: represents view which should be hidden and from which we are starting
    // view2: represents view which is second view or behind of view1
    // isReverse: default if false, but if we need reverse animation we pass true and it
    // will Flip from Left

    func flipTransition (with view2: UIView, isReverse: Bool = false) {
        var transitionOptions = UIView.AnimationOptions()
        transitionOptions = isReverse ? [.transitionFlipFromLeft] : [.transitionFlipFromRight] // options for transition

        // animation durations are equal so while first will finish, second will start
        // below example could be done also using completion block.

        UIView.transition(with: self, duration: 0.5, options: transitionOptions, animations: {
            self.isHidden = true
        })

        UIView.transition(with: view2, duration: 0.5, options: transitionOptions, animations: {
            view2.isHidden = false
        })
    }
}
