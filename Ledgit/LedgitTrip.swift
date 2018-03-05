//
//  LedgitTrip.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/19/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation

struct LedgitTrip {
    var key: String
    var name: String
    var startDate: String
    var endDate: String
    var currencies: [Currency] = []
    var users: String
    var owner: String
    var budget: Double
    var length: Int
    var budgetSelection: BudgetSelection = .daily
    var dictionaryRepresentation: NSDictionary
    
    init?(dict: NSDictionary) {
        guard
            let nameString = dict["name"] as? String,
            let keyString = dict["key"] as? String,
            let startDateString = dict["startDate"] as? String,
            let endDateString = dict["endDate"] as? String,
            let usersString = dict["users"] as? String,
            let ownerString = dict["owner"] as? String,
            let budgetString = dict["dailyBudget"] as? Double,
            let lengthDouble = dict["length"] as? Int,
            let budgetSelectionString = dict["budgetSelection"] as? String,
            let currencyStrings = dict["currencies"] as? [String]
        else { return nil }
        
        key = keyString
        name = nameString
        startDate = startDateString
        endDate = endDateString
        users = usersString
        owner = ownerString
        budget = budgetString
        length = lengthDouble
        budgetSelection <= BudgetSelection(rawValue: budgetSelectionString)
        dictionaryRepresentation = dict
        
        currencyStrings.forEach { item in
            guard let currency = Currency.get(with: item) else { return }
            currencies.append(currency)
        }
    }
}
