//
//  String+Content.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 3/4/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import UIKit

extension String {
    func toDouble() -> Double {
        let validSet = CharacterSet(charactersIn: "0123456789.")
        guard let double = Double(components(separatedBy: validSet.inverted).joined(separator: "")) else { return 0.0 }
        return double
    }
    
    func currencyFormat(with symbol: String = LedgitUser.current.homeCurrency.symbol) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        guard
            let amount = Double(self),
            let formattedNumber = formatter.string(from: NSNumber(value: amount))
            else {
                return ""
        }
        return "\(symbol)\(formattedNumber)"
    }
    
    // Returns true if the string has at least one character in common with matchCharacters.
    func containsCharactersIn(matchCharacters: String) -> Bool{
        let characterSet = NSCharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet as CharacterSet) != nil
    }
    
    // Returns true if the string contains only characters found in matchCharacters.
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool{
        let disallowedCharacterSet = NSCharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet as CharacterSet) != nil
    }
    
    // Returns true if the string has no characters in common with matchCharacters.
    func doesNotContainCharactersIn(matchCharacters: String) -> Bool{
        let characterSet = NSCharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet as CharacterSet) != nil
    }
    
    func isNumeric() -> Bool{
        let scanner = Scanner(string: self)
        scanner.locale = Locale.current
        
        return scanner.scanDecimal(nil) && scanner.isAtEnd
    }
    
    func toDate(withFormat format: LedgitDateStyle = .full) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.date(from: self)!
    }
    
    func strip() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
