//
//  Currency.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

struct Currency: Equatable {
    var name: String
    var code: String
    var symbol: String
    var flagCode: String
    var image: UIImage
}

extension Currency {
    static var AUD: Currency {
        return Currency(
            name: "Australian Dollar",
            code: "AUD",
            symbol: "A$",
            flagCode: "AU",
            image: #imageLiteral(resourceName: "AU"))
    }
    
    static var BGN: Currency {
        return Currency(
            name: "Bulgarian Lev",
            code: "BGN",
            symbol: "BGN",
            flagCode: "BG",
            image: #imageLiteral(resourceName: "BG"))
    }
    static var BRL: Currency {
        return Currency(
            name: "Brazilian Real",
            code: "BRL",
            symbol: "R$",
            flagCode: "BR",
            image: #imageLiteral(resourceName: "BR"))
    }
    static var CAD: Currency {
        return Currency(
            name: "Canadian Dollar",
            code: "CAD",
            symbol: "CA$",
            flagCode: "CA",
            image: #imageLiteral(resourceName: "CA"))
    }
    static var CHF: Currency {
        return Currency(
            name: "Swiss Franc",
            code: "CHF",
            symbol: "CHF",
            flagCode: "CH2",
            image: #imageLiteral(resourceName: "CH2"))
    }
    static var CNY: Currency {
        return Currency(
            name: "Chinese Yuan",
            code: "CNY",
            symbol: "CN¥",
            flagCode: "CN",
            image: #imageLiteral(resourceName: "CN"))
    }
    static var CZK: Currency {
        return Currency(
            name: "Czech Koruna",
            code: "CZK",
            symbol: "CZK",
            flagCode: "CZ",
            image: #imageLiteral(resourceName: "CZ"))
    }
    static var DKK: Currency {
        return Currency(
            name: "Danish Krone",
            code: "DKK",
            symbol: "DKK",
            flagCode: "DK",
            image: #imageLiteral(resourceName: "DK"))
    }
    static var GBP: Currency {
        return Currency(
            name: "Great British Pound",
            code: "GBP",
            symbol: "£",
            flagCode: "GB",
            image: #imageLiteral(resourceName: "GB"))
    }
    static var HKD: Currency {
        return Currency(
            name: "Hong Kong Dollar",
            code: "HKD",
            symbol: "HK$",
            flagCode: "HK",
            image: #imageLiteral(resourceName: "HK"))
    }
    static var HRK: Currency {
        return Currency(
            name: "Croatia Kuna",
            code: "HRK",
            symbol: "HRK",
            flagCode: "HR",
            image: #imageLiteral(resourceName: "HR"))
    }
    static var HUF: Currency {
        return Currency(
            name: "Hungarian Forint",
            code: "HUF",
            symbol: "HUF",
            flagCode: "HU",
            image: #imageLiteral(resourceName: "HU"))
    }
    static var IDR: Currency {
        return Currency(
            name: "Indonesian Rupiah",
            code: "IDR",
            symbol: "IDR",
            flagCode: "ID",
            image: #imageLiteral(resourceName: "ID"))
    }
    static var ILS: Currency {
        return Currency(
            name: "Israeli New Shekel",
            code: "ILS",
            symbol: "₪",
            flagCode: "IL",
            image: #imageLiteral(resourceName: "IL"))
    }
    static var JPY: Currency {
        return Currency(
            name: "Japanese Yen",
            code: "JPY",
            symbol: "¥",
            flagCode: "JP",
            image: #imageLiteral(resourceName: "JP"))
    }
    static var KRW: Currency {
        return Currency(
            name: "South Korean Won",
            code: "KRW",
            symbol: "₩",
            flagCode: "KR",
            image: #imageLiteral(resourceName: "KR"))
    }
    static var MXN: Currency {
        return Currency(
            name: "Mexican Peso",
            code: "MXN",
            symbol: "MX$",
            flagCode: "MX",
            image: #imageLiteral(resourceName: "MX"))
    }
    static var MYR: Currency {
        return Currency(
            name: "Malaysian Ringgit",
            code: "MYR",
            symbol: "MYR",
            flagCode: "MY",
            image: #imageLiteral(resourceName: "MY"))}
    static var NOK: Currency {
        return Currency(
            name: "Norwegian Krone",
            code: "NOK",
            symbol: "NOK",
            flagCode: "NO",
            image: #imageLiteral(resourceName: "NO"))
    }
    static var NZD: Currency {
        return Currency(
            name: "New Zealand Dollar",
            code: "NZD",
            symbol: "NZ$",
            flagCode: "NZ",
            image: #imageLiteral(resourceName: "NZ"))
    }
    static var PHP: Currency {
        return Currency(
            name: "Philippine Peso",
            code: "PHP",
            symbol: "PHP",
            flagCode: "PH",
            image: #imageLiteral(resourceName: "PH"))
    }
    static var PLN: Currency {
        return Currency(
            name: "Polish Zloty",
            code: "PLN",
            symbol: "PLN",
            flagCode: "PL",
            image: #imageLiteral(resourceName: "PL"))
    }
    static var RON: Currency {
        return Currency(
            name: "Romanian Leu",
            code: "RON",
            symbol: "RON",
            flagCode: "RO",
            image: #imageLiteral(resourceName: "RO"))
    }
    static var RUB: Currency {
        return Currency(
            name: "Russian Ruble",
            code: "RUB",
            symbol: "RUB",
            flagCode: "RU",
            image: #imageLiteral(resourceName: "RU"))
    }
    static var SEK: Currency {
        return Currency(
            name: "Swedish Krona",
            code: "SEK",
            symbol: "SEK",
            flagCode: "SE",
            image: #imageLiteral(resourceName: "SE"))
    }
    static var SGD: Currency {
        return Currency(
            name: "Singapore Dollar",
            code: "SGD",
            symbol: "SGD",
            flagCode: "SG",
            image: #imageLiteral(resourceName: "SG"))
    }
    static var THB: Currency {
        return Currency(
            name: "Thai Baht",
            code: "THB",
            symbol: "THB",
            flagCode: "TH",
            image: #imageLiteral(resourceName: "TH"))
    }
    static var TRY: Currency {
        return Currency(
            name: "Turkish Lira",
            code: "TRY",
            symbol: "TRY",
            flagCode: "TR",
            image: #imageLiteral(resourceName: "TR"))
    }
    static var USD: Currency {
        return Currency(
            name: "US Dollar",
            code: "USD",
            symbol: "$",
            flagCode: "US",
            image: #imageLiteral(resourceName: "US"))
    }
    static var ZAR: Currency {
        return Currency(
            name: "South African Rand",
            code: "ZAR",
            symbol: "ZAR",
            flagCode: "ZA",
            image: #imageLiteral(resourceName: "ZA"))
    }
    static var EUR: Currency {
        return Currency(
            name: "Euro",
            code: "EUR",
            symbol: "€",
            flagCode: "EU",
            image: #imageLiteral(resourceName: "EU"))
    }
}

extension Currency {
    static let all: [Currency] = [AUD, BGN, BRL, CAD, CHF,
                                  CNY, CZK, DKK, GBP, HKD,
                                  HRK, HUF, IDR, ILS, JPY,
                                  KRW, MXN, MYR, NOK, NZD,
                                  PHP, PLN, RON, RUB, SEK,
                                  SGD, THB, TRY, USD, ZAR, EUR]
    
    static let codes: [String] = Currency.all.map{ $0.code }
}

extension Currency {
    static func get(from dict: [String]) -> [Currency] {
        var result: [Currency] = []
        dict.forEach { code in
            if let currency = Currency.all.first(where: { $0.code == code }) {
                result.append(currency)
            }
        }
        return result
    }
    
    static func get(with code: String) -> Currency? {
        return Currency.all.first(where: { $0.code == code })
    }
    
    // https://api.fixer.io/latest?base=USD
    static func getRates(completion: @escaping (NSDictionary) -> Void) {
        guard let user = LedgitUser.current else { return }
        guard let url = URL(string: "https://api.fixer.io/latest?base=\(user.homeCurrency.code)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil, let error = error { print(error.localizedDescription) }
            guard let data = data else { return }
            guard let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary else { return }
            guard let rates = result?["rates"] as? NSDictionary else { return }
            
            completion(rates)
        }.resume()
    }
}

extension Currency {
    static func ==(lhs:Currency, rhs:Currency) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.code == rhs.code &&
            lhs.flagCode == rhs.flagCode &&
            lhs.image == rhs.image &&
            lhs.symbol == rhs.symbol
    }
}

