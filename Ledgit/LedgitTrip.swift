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
    
    struct Keys {
        static let name = "name"
        static let key = "key"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let users = "users"
        static let owner = "owner"
        static let budget = "budget"
        static let length = "length"
        static let budgetSelection = "budgetSelection"
        static let currencies = "currencies"
    }
    
    init?(dict: NSDictionary) {
        guard
            let nameString = dict[LedgitTrip.Keys.name] as? String,
            let keyString = dict[LedgitTrip.Keys.key] as? String,
            let startDateString = dict[LedgitTrip.Keys.startDate] as? String,
            let endDateString = dict[LedgitTrip.Keys.endDate] as? String,
            let usersString = dict[LedgitTrip.Keys.users] as? String,
            let ownerString = dict[LedgitTrip.Keys.owner] as? String,
            let budgetString = dict[LedgitTrip.Keys.budget] as? Double,
            let lengthDouble = dict[LedgitTrip.Keys.length] as? Int,
            let budgetSelectionString = dict[LedgitTrip.Keys.budgetSelection] as? String,
            let currencyStrings = dict[LedgitTrip.Keys.currencies] as? [String]
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
