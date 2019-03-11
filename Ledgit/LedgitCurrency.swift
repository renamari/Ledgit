//
//  LedgitCurrency.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

struct LedgitCurrency: Equatable {
    let name: String
    let code: String
    let symbol: String
    let flagCode: String
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

    static func == (lhs: LedgitCurrency, rhs: LedgitCurrency) -> Bool {
        return lhs.code == rhs.code
    }
}

extension LedgitCurrency {
    static let all: [LedgitCurrency] = [AUD, BGN, BRL, CAD, CHF,
                                        CNY, CZK, DKK, GBP, HKD,
                                        HRK, HUF, IDR, ILS, JPY,
                                        KRW, MXN, MYR, NOK, NZD,
                                        PHP, PLN, RON, RUB, SEK,
                                        SGD, THB, TRY, USD, ZAR, EUR]
}

enum LedgitCurrencyFetchError: Error {
    case noNetwork
    case noSavedRate
    case noNetworkOrSavedRate
    case currencyService
}

extension LedgitCurrency {
    static func getRate(between base: String, and currency: String, completion: @escaping ((Result<Double>) -> Void)) {
        let queryString = base + "_" + currency
        let queryStringDate = queryString + "_date"
        let defaults = UserDefaults.standard

        if let exchangeRate = defaults.value(forKey: queryString) as? Double, let date = defaults.value(forKey: queryStringDate) as? Date, date > 1.days.ago {
            LedgitLog.info("Found exchange rate for \(queryString) and is less than 1 day old in UserDefaults, not calling API")

            DispatchQueue.main.async {
                completion(.success(exchangeRate))
            }

            return
        } else {
            if !Reachability.isConnectedToNetwork {
                completion(.failure(LedgitCurrencyFetchError.noNetworkOrSavedRate))
                return
            }
        }

        guard Reachability.isConnectedToNetwork else {
            LedgitLog.warning("Could not start exchange rate request because user is not connected to network.")

            DispatchQueue.main.async {
                completion(.failure(LedgitCurrencyFetchError.noNetwork))
            }

            return
        }

        let query = URLQueryItem(name: "q", value: base + "_" + currency)
        let keyQuery = URLQueryItem(name: "apiKey", value: "f6637a01d6f29b468bdb")
        let compactQuery = URLQueryItem(name: "compact", value: "ultra")
        var components = URLComponents(string: "https://free.currencyconverterapi.com/api/v6/convert")
        components?.queryItems = [query, keyQuery, compactQuery]

        guard let url = components?.url else {

            DispatchQueue.main.async {
                completion(.failure(LedgitCurrencyFetchError.currencyService))
            }

            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(LedgitCurrencyFetchError.currencyService))
                }

                return
            }

            guard let data = data,
                let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Double],
                let rate = result?[queryString] else {
                    DispatchQueue.main.async {
                        completion(.failure(LedgitCurrencyFetchError.currencyService))
                    }
                    return
            }

            LedgitLog.info("Sucessfully got exchange rate between \(base) and \(currency)")
            defaults.set(Date(), forKey: queryStringDate)
            defaults.set(rate, forKey: queryString)

            DispatchQueue.main.async {
                completion(.success(rate))
            }
        }

        task.resume()
    }
}
