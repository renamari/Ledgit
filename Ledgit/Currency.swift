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
}

extension Currency {
    static var AUD: Currency {
        return Currency(
            name: "Australian Dollar",
            code: "AUD",
            symbol: "A$",
            flagCode: "AU")
    }
    static var BGN: Currency {
        return Currency(
            name: "Bulgarian Lev",
            code: "BGN",
            symbol: "BGN",
            flagCode: "BG")
    }
    static var BRL: Currency {
        return Currency(
            name: "Brazilian Real",
            code: "BRL",
            symbol: "R$",
            flagCode: "BR")
    }
    static var CAD: Currency {
        return Currency(
            name: "Canadian Dollar",
            code: "CAD",
            symbol: "CA$",
            flagCode: "CA")
    }
    static var CHF: Currency {
        return Currency(
            name: "Swiss Franc",
            code: "CHF",
            symbol: "CHF",
            flagCode: "CH")
    }
    static var CNY: Currency {
        return Currency(
            name: "Chinese Yuan",
            code: "CNY",
            symbol: "CN¥",
            flagCode: "CN")
    }
    static var CZK: Currency {
        return Currency(
            name: "Czech Koruna",
            code: "CZK",
            symbol: "CZK",
            flagCode: "CZ")
    }
    static var DKK: Currency {
        return Currency(
            name: "Danish Krone",
            code: "DKK",
            symbol: "DKK",
            flagCode: "DK")
    }
    static var GBP: Currency {
        return Currency(
            name: "Great British Pound",
            code: "GBP",
            symbol: "£",
            flagCode: "GB")
    }
    static var HKD: Currency {
        return Currency(
            name: "Hong Kong Dollar",
            code: "HKD",
            symbol: "HK$",
            flagCode: "HK")
    }
    static var HRK: Currency {
        return Currency(
            name: "Croatia Kuna",
            code: "HRK",
            symbol: "HRK",
            flagCode: "HR")
    }
    static var HUF: Currency {
        return Currency(
            name: "Hungarian Forint",
            code: "HUF",
            symbol: "HUF",
            flagCode: "HU")
    }
    static var IDR: Currency {
        return Currency(
            name: "Indonesian Rupiah",
            code: "IDR",
            symbol: "IDR",
            flagCode: "ID")
    }
    static var ILS: Currency {
        return Currency(
            name: "Israeli New Shekel",
            code: "ILS",
            symbol: "₪",
            flagCode: "IL")
    }
    static var JPY: Currency {
        return Currency(
            name: "Japanese Yen",
            code: "JPY",
            symbol: "¥",
            flagCode: "JP")
    }
    static var KRW: Currency {
        return Currency(
            name: "South Korean Won",
            code: "KRW",
            symbol: "₩",
            flagCode: "KR")
    }
    static var MXN: Currency {
        return Currency(
            name: "Mexican Peso",
            code: "MXN",
            symbol: "MX$",
            flagCode: "MX")
    }
    static var MYR: Currency {
        return Currency(
            name: "Malaysian Ringgit",
            code: "MYR",
            symbol: "MYR",
            flagCode: "MY")
    }
    static var NOK: Currency {
        return Currency(
            name: "Norwegian Krone",
            code: "NOK",
            symbol: "NOK",
            flagCode: "NO")
    }
    static var NZD: Currency {
        return Currency(
            name: "New Zealand Dollar",
            code: "NZD",
            symbol: "NZ$",
            flagCode: "NZ")
    }
    static var PHP: Currency {
        return Currency(
            name: "Philippine Peso",
            code: "PHP",
            symbol: "PHP",
            flagCode: "PH")
    }
    static var PLN: Currency {
        return Currency(
            name: "Polish Zloty",
            code: "PLN",
            symbol: "PLN",
            flagCode: "PL")
    }
    static var RON: Currency {
        return Currency(
            name: "Romanian Leu",
            code: "RON",
            symbol: "RON",
            flagCode: "RO")
    }
    static var RUB: Currency {
        return Currency(
            name: "Russian Ruble",
            code: "RUB",
            symbol: "RUB",
            flagCode: "RU")
    }
    static var SEK: Currency {
        return Currency(
            name: "Swedish Krona",
            code: "SEK",
            symbol: "SEK",
            flagCode: "SE")
    }
    static var SGD: Currency {
        return Currency(
            name: "Singapore Dollar",
            code: "SGD",
            symbol: "SGD",
            flagCode: "SG")
    }
    static var THB: Currency {
        return Currency(
            name: "Thai Baht",
            code: "THB",
            symbol: "THB",
            flagCode: "TH")
    }
    static var TRY: Currency {
        return Currency(
            name: "Turkish Lira",
            code: "TRY",
            symbol: "TRY",
            flagCode: "TR")
    }
    static var USD: Currency {
        return Currency(
            name: "US Dollar",
            code: "USD",
            symbol: "$",
            flagCode: "US")
    }
    static var ZAR: Currency {
        return Currency(
            name: "South African Rand",
            code: "ZAR",
            symbol: "ZAR",
            flagCode: "ZA")
    }
    static var EUR: Currency {
        return Currency(
            name: "Euro",
            code: "EUR",
            symbol: "€",
            flagCode: "EU")
    }
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
    
    static func ==(lhs:Currency, rhs:Currency) -> Bool {
        return lhs.name == rhs.name && lhs.code == rhs.code && lhs.flagCode == rhs.flagCode && lhs.symbol == rhs.symbol
    }
}

extension Currency {
    static let all: [Currency] = [AUD, BGN, BRL, CAD, CHF,
                                  CNY, CZK, DKK, GBP, HKD,
                                  HRK, HUF, IDR, ILS, JPY,
                                  KRW, MXN, MYR, NOK, NZD,
                                  PHP, PLN, RON, RUB, SEK,
                                  SGD, THB, TRY, USD, ZAR, EUR]
    
    static let codes: [String] = Currency.all.map { $0.code }
}

extension Currency {
    static var rates: [String: Double] {
        set { UserDefaults.standard.set(newValue, forKey: Constants.userDefaultKeys.lastRates) }
        get {
            guard let lastUpdatedRates = UserDefaults.standard.value(forKey: Constants.userDefaultKeys.lastRates) as? [String: Double] else {
                let rates: [String: Double] = [:]
                UserDefaults.standard.set(rates, forKey: Constants.userDefaultKeys.lastRates)
                return rates
            }
            return lastUpdatedRates
        }
    }
    
    static var lastUpdated: Date? {
        set { UserDefaults.standard.set(newValue, forKey: Constants.userDefaultKeys.lastUpdated) }
        get {
            guard let lastUpdated = UserDefaults.standard.value(forKey: Constants.userDefaultKeys.lastUpdated) as? Date else { return nil }
            return lastUpdated
        }
    }
    
    // https://api.fixer.io/latest?base=USD
    static func getRates() {
        
        guard Reachability.isConnectedToNetwork() else {
            Log.warning("Could not start exchange rate request because user is not connected to network.")
            return
        }
        
        // Weird, reverse guard
        // Here if lastUpdated is NOT nil, check if lastUpdated is equal to today. If yes, skip update
        // If lastUpdated IS nil, immediately go and update.
        guard lastUpdated != nil, lastUpdated != Date() else {
            Log.info("Starting update on rates")
            
            guard let url = URL(string: "http://data.fixer.io/api/latest?access_key=\(Constants.fixerKey)&base=\(LedgitUser.current.homeCurrency.code)") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil, let error = error { Log.error(error) }
                guard let data = data else { return }
                guard let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary else { return }
                guard let ratesData = result?["rates"] as? [String : Double] else { return }
        
                rates = ratesData
                lastUpdated = Date()
                Log.info("Sucessfully updated rates data and last updated \(Date())")
            }
            
            task.resume()
            return
        }
        
        Log.warning("Either this was the first app usage, or the exchange rates were already refreshed today")
    }
    
    static func getRate(between base: String, and currency: String) -> Promise<Double> {
        return Promise { resolve, reject in
        
            guard Reachability.isConnectedToNetwork() else {
                Log.warning("Could not start exchange rate request because user is not connected to network.")
                reject(makeError("Could not start exchange rate request because user is not connected to network."))
                return
            }
            
            let queryString = "\(base)_\(currency)"
            guard let url = URL(string: "http://free.currencyconverterapi.com/api/v5/convert?q=\(queryString)&compact=ultra") else {
                reject(makeError("Could not create a url to get custom exchange rate"))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil, let error = error {
                    reject(error)
                }
                guard
                    let data = data,
                    let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Double],
                    let rate = result?[queryString]
                else {
                    reject(makeError("Something went wrong with extracting the data for custom exchange rate"))
                    return
                }
                
                Log.info("Sucessfully got exchange rate between \(base) and \(currency)")
                
                resolve(rate)
            }
            
            task.resume()
        }
    }
}

