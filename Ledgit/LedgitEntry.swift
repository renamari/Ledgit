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
    
    init?(dict: NSDictionary) {
        guard
            let key = dict["key"] as? String,
            let date = dict["date"] as? String,
            let description = dict["description"] as? String,
            let currencyString = dict["currency"] as? String,
            let currency = Currency.get(with: currencyString),
            let location = dict["location"] as? String,
            let category = dict["category"] as? String,
            let paidBy = dict["paidBy"] as? String,
            let paymentType = dict["paymentType"] as? String,
            let owningTrip = dict["owningTrip"] as? String,
            let cost = dict["cost"] as? Double
            else {
                return nil
        }
        
        self.key = key
        self.date = date.toDate(withFormat: nil)
        self.description = description
        self.currency = currency
        self.location = location
        self.category = category
        self.paidBy = paidBy
        self.cost = cost
        self.owningTrip = owningTrip
        self.paymentType = (paymentType == "Cash") ? .cash : .credit
    }
}
