//
//  LedgitExchangeRate.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 6/1/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation

struct LedgitExchangeRate: Decodable {
    let fromCurrencyCode: String
    let fromCurrencyName: String
    let toCurrencyCode: String
    let toCurrencyName: String
    let rate: Double

    enum CodingKeys: String, CodingKey {
        case realTimeExchangeRate = "Realtime Currency Exchange Rate"
        case fromCurrencyCode = "1. From_Currency Code"
        case fromCurrencyName = "2. From_Currency Name"
        case toCurrencyCode = "3. To_Currency Code"
        case toCurrencyName = "4. To_Currency Name"
        case rate = "5. Exchange Rate"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .realTimeExchangeRate)
        fromCurrencyCode = try nestedContainer.decode(String.self, forKey: .fromCurrencyCode)
        fromCurrencyName = try nestedContainer.decode(String.self, forKey: .fromCurrencyName)
        toCurrencyCode = try nestedContainer.decode(String.self, forKey: .toCurrencyCode)
        toCurrencyName = try nestedContainer.decode(String.self, forKey: .toCurrencyName)

        guard let rateDouble = Double(try nestedContainer.decode(String.self, forKey: .rate)) else { throw LedgitCurrencyFetchError.currencyService }
        rate = rateDouble
    }
}
