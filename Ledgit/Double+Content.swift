//
//  Double+Content.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 4/10/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import Foundation

extension Double {
    func currencyFormat(with symbol: String = LedgitUser.current.homeCurrency.symbol) -> String {
        let value = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = symbol
        return formatter.string(from: value) ?? ""
    }
}
