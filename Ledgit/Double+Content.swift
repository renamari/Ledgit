//
//  Double+Content.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 4/10/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import Foundation

extension Double {
    func currencyFormat(with symbol: String = "$") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        guard var formattedNumber = formatter.string(from: NSNumber(value: self)) else { return "" }
        
        if formattedNumber.contains(".") {
            let split = formattedNumber.split(separator: ".")
            guard let decimals = split.last else { return "" }
            if decimals.count == 1 { formattedNumber += "0" }
            
        } else {
            formattedNumber += ".00"
        }
        
        return "\(symbol)\(formattedNumber)"
    }
}
