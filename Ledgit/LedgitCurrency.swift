//
//  LedgitCurrency.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

struct LedgitCurrency: Equatable {
    var name: String
    var code: String
    var symbol: String
    var flagCode: String
}

extension LedgitCurrency {
    static var AUD: LedgitCurrency {
        return LedgitCurrency(
            name: "Australian Dollar",
            code: "AUD",
            symbol: "A$",
            flagCode: "AU")
    }
    static var BGN: LedgitCurrency {
        return LedgitCurrency(
            name: "Bulgarian Lev",
            code: "BGN",
            symbol: "BGN",
            flagCode: "BG")
    }
    static var BRL: LedgitCurrency {
        return LedgitCurrency(
            name: "Brazilian Real",
            code: "BRL",
            symbol: "R$",
            flagCode: "BR")
    }
    static var CAD: LedgitCurrency {
        return LedgitCurrency(
            name: "Canadian Dollar",
            code: "CAD",
            symbol: "CA$",
            flagCode: "CA")
    }
    static var CHF: LedgitCurrency {
        return LedgitCurrency(
            name: "Swiss Franc",
            code: "CHF",
            symbol: "CHF",
            flagCode: "CH")
    }
    static var CNY: LedgitCurrency {
        return LedgitCurrency(
            name: "Chinese Yuan",
            code: "CNY",
            symbol: "CN¥",
            flagCode: "CN")
    }
    static var CZK: LedgitCurrency {
        return LedgitCurrency(
            name: "Czech Koruna",
            code: "CZK",
            symbol: "CZK",
            flagCode: "CZ")
    }
    static var DKK: LedgitCurrency {
        return LedgitCurrency(
            name: "Danish Krone",
            code: "DKK",
            symbol: "DKK",
            flagCode: "DK")
    }
    static var GBP: LedgitCurrency {
        return LedgitCurrency(
            name: "Great British Pound",
            code: "GBP",
            symbol: "£",
            flagCode: "GB")
    }
    static var HKD: LedgitCurrency {
        return LedgitCurrency(
            name: "Hong Kong Dollar",
            code: "HKD",
            symbol: "HK$",
            flagCode: "HK")
    }
    static var HRK: LedgitCurrency {
        return LedgitCurrency(
            name: "Croatia Kuna",
            code: "HRK",
            symbol: "HRK",
            flagCode: "HR")
    }
    static var HUF: LedgitCurrency {
        return LedgitCurrency(
            name: "Hungarian Forint",
            code: "HUF",
            symbol: "HUF",
            flagCode: "HU")
    }
    static var IDR: LedgitCurrency {
        return LedgitCurrency(
            name: "Indonesian Rupiah",
            code: "IDR",
            symbol: "IDR",
            flagCode: "ID")
    }
    static var ILS: LedgitCurrency {
        return LedgitCurrency(
            name: "Israeli New Shekel",
            code: "ILS",
            symbol: "₪",
            flagCode: "IL")
    }
    static var JPY: LedgitCurrency {
        return LedgitCurrency(
            name: "Japanese Yen",
            code: "JPY",
            symbol: "¥",
            flagCode: "JP")
    }
    static var KRW: LedgitCurrency {
        return LedgitCurrency(
            name: "South Korean Won",
            code: "KRW",
            symbol: "₩",
            flagCode: "KR")
    }
    static var MXN: LedgitCurrency {
        return LedgitCurrency(
            name: "Mexican Peso",
            code: "MXN",
            symbol: "MX$",
            flagCode: "MX")
    }
    static var MYR: LedgitCurrency {
        return LedgitCurrency(
            name: "Malaysian Ringgit",
            code: "MYR",
            symbol: "MYR",
            flagCode: "MY")
    }
    static var NOK: LedgitCurrency {
        return LedgitCurrency(
            name: "Norwegian Krone",
            code: "NOK",
            symbol: "NOK",
            flagCode: "NO")
    }
    static var NZD: LedgitCurrency {
        return LedgitCurrency(
            name: "New Zealand Dollar",
            code: "NZD",
            symbol: "NZ$",
            flagCode: "NZ")
    }
    static var PHP: LedgitCurrency {
        return LedgitCurrency(
            name: "Philippine Peso",
            code: "PHP",
            symbol: "PHP",
            flagCode: "PH")
    }
    static var PLN: LedgitCurrency {
        return LedgitCurrency(
            name: "Polish Zloty",
            code: "PLN",
            symbol: "PLN",
            flagCode: "PL")
    }
    static var RON: LedgitCurrency {
        return LedgitCurrency(
            name: "Romanian Leu",
            code: "RON",
            symbol: "RON",
            flagCode: "RO")
    }
    static var RUB: LedgitCurrency {
        return LedgitCurrency(
            name: "Russian Ruble",
            code: "RUB",
            symbol: "RUB",
            flagCode: "RU")
    }
    static var SEK: LedgitCurrency {
        return LedgitCurrency(
            name: "Swedish Krona",
            code: "SEK",
            symbol: "SEK",
            flagCode: "SE")
    }
    static var SGD: LedgitCurrency {
        return LedgitCurrency(
            name: "Singapore Dollar",
            code: "SGD",
            symbol: "SGD",
            flagCode: "SG")
    }
    static var THB: LedgitCurrency {
        return LedgitCurrency(
            name: "Thai Baht",
            code: "THB",
            symbol: "THB",
            flagCode: "TH")
    }
    static var TRY: LedgitCurrency {
        return LedgitCurrency(
            name: "Turkish Lira",
            code: "TRY",
            symbol: "TRY",
            flagCode: "TR")
    }
    static var USD: LedgitCurrency {
        return LedgitCurrency(
            name: "US Dollar",
            code: "USD",
            symbol: "$",
            flagCode: "US")
    }
    static var ZAR: LedgitCurrency {
        return LedgitCurrency(
            name: "South African Rand",
            code: "ZAR",
            symbol: "ZAR",
            flagCode: "ZA")
    }
    static var EUR: LedgitCurrency {
        return LedgitCurrency(
            name: "Euro",
            code: "EUR",
            symbol: "€",
            flagCode: "EU")
    }
}

extension LedgitCurrency {
    static func get(from dict: [String]) -> [LedgitCurrency] {
        var result: [LedgitCurrency] = []
        dict.forEach { code in
            if let currency = LedgitCurrency.all.first(where: { $0.code == code }) {
                result.append(currency)
            }
        }
        return result
    }
    
    static func get(with code: String) -> LedgitCurrency? {
        return LedgitCurrency.all.first(where: { $0.code == code })
    }
    
    static func ==(lhs:LedgitCurrency, rhs:LedgitCurrency) -> Bool {
        return lhs.name == rhs.name && lhs.code == rhs.code && lhs.flagCode == rhs.flagCode && lhs.symbol == rhs.symbol
    }
}

extension LedgitCurrency {
    static let all: [LedgitCurrency] = [AUD, BGN, BRL, CAD, CHF,
                                  CNY, CZK, DKK, GBP, HKD,
                                  HRK, HUF, IDR, ILS, JPY,
                                  KRW, MXN, MYR, NOK, NZD,
                                  PHP, PLN, RON, RUB, SEK,
                                  SGD, THB, TRY, USD, ZAR, EUR]
    
    static let codes: [String] = LedgitCurrency.all.map { $0.code }
}

extension LedgitCurrency {
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

