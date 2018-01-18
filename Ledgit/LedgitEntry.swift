//
//  LedgitEntry.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/19/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation

struct LedgitEntry {
    var key: String
    let date: Date
    let currency: Currency
    var location: String
    var description: String
    var category: String
    var paidBy: String
    var paymentType: PaymentType
    var cost: Double
    var owningTrip: String
    var exchangeRate: Double
    
    init?(dict: NSDictionary) {
        guard
            let keyString = dict["key"] as? String,
            let dateString = dict["date"] as? String,
            let descriptionString = dict["description"] as? String,
            let currencyString = dict["currency"] as? String,
            let currencyValue = Currency.get(with: currencyString),
            let locationString = dict["location"] as? String,
            let categoryString = dict["category"] as? String,
            let paidByString = dict["paidBy"] as? String,
            let paymentTypeString = dict["paymentType"] as? String,
            let owningTripString = dict["owningTrip"] as? String,
            let costDouble = dict["cost"] as? Double,
            let exchangeRateDouble = dict["exchangeRate"] as? Double,
            let paymentTypeValue = PaymentType(rawValue: paymentTypeString)
        else {
            return nil
        }
        
        key = keyString
        date = dateString.toDate(withFormat: nil)
        description = descriptionString
        currency = currencyValue
        location = locationString
        category = categoryString
        paidBy = paidByString
        cost = costDouble
        owningTrip = owningTripString
        paymentType = paymentTypeValue
        exchangeRate = exchangeRateDouble
    }
}
