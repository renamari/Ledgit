//
//  LedgitEntry.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/19/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation

struct LedgitEntry: Equatable {
    var key: String
    let date: Date
    let currency: LedgitCurrency
    var location: String
    var description: String
    var category: String
    var paidBy: String
    var paymentType: PaymentType
    var cost: Double
    var convertedCost: Double
    var owningTrip: String
    var exchangeRate: Double
    var homeCurrency: LedgitCurrency
    var dictionaryRepresentation: NSDictionary

    struct Keys {
        static let key = "key"
        static let date = "date"
        static let currency = "currency"
        static let location = "location"
        static let description = "entryDescription"
        static let category = "category"
        static let paidBy = "paidBy"
        static let paymentType = "paymentType"
        static let owningTrip = "owningTrip"
        static let cost = "cost"
        static let convertedCost = "convertedCost"
        static let exchangeRate = "exchangeRate"
        static let homeCurrency = "homeCurrency"
    }

    init?(dict: NSDictionary) {
        guard
            let keyString = dict[LedgitEntry.Keys.key] as? String,
            let dateString = dict[LedgitEntry.Keys.date] as? String,
            let descriptionString = dict[LedgitEntry.Keys.description] as? String,
            let currencyString = dict[LedgitEntry.Keys.currency] as? String,
            let currencyValue = LedgitCurrency.get(with: currencyString),
            let homeCurrencyString = dict[LedgitEntry.Keys.homeCurrency] as? String,
            let homeCurrencyValue = LedgitCurrency.get(with: homeCurrencyString),
            let locationString = dict[LedgitEntry.Keys.location] as? String,
            let categoryString = dict[LedgitEntry.Keys.category] as? String,
            let paidByString = dict[LedgitEntry.Keys.paidBy] as? String,
            let paymentTypeString = dict[LedgitEntry.Keys.paymentType] as? String,
            let owningTripString = dict[LedgitEntry.Keys.owningTrip] as? String,
            let costDouble = dict[LedgitEntry.Keys.cost] as? Double,
            let convertedCostDouble = dict[LedgitEntry.Keys.convertedCost] as? Double,
            let exchangeRateDouble = dict[LedgitEntry.Keys.exchangeRate] as? Double,
            let paymentTypeValue = PaymentType(rawValue: paymentTypeString)
            else {
                return nil
        }

        key = keyString
        date = dateString.toDate()
        description = descriptionString
        currency = currencyValue
        homeCurrency = homeCurrencyValue
        location = locationString
        category = categoryString
        paidBy = paidByString
        cost = costDouble
        convertedCost = convertedCostDouble
        owningTrip = owningTripString
        paymentType = paymentTypeValue
        exchangeRate = exchangeRateDouble
        dictionaryRepresentation = dict
    }

    static func == (lhs: LedgitEntry, rhs: LedgitEntry) -> Bool {
        return lhs.key == rhs.key
    }
}
