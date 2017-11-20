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
    //var image: UIImage
    var users: String
    var owner: String
    var budget: Double
    var budgetSelection: BudgetSelection
    
    init?(dict: NSDictionary) {
        guard
            let name = dict["name"] as? String,
            let key = dict["key"] as? String,
            let startDate = dict["startDate"] as? String,
            let endDate = dict["endDate"] as? String,
            let users = dict["users"] as? String,
            let owner = dict["owner"] as? String,
            let budget = dict["budget"] as? Double,
            let budgetSelection = dict["budgetSelection"] as? String,
            let currencyStrings = dict["currencies"] as? [String]
            else {
                return nil
        }
        
        self.name = name
        self.key = key
        self.startDate = startDate
        self.endDate = endDate
        //self.image = UIImage(named: dict["image"] as! String)!
        self.users = users
        self.owner = owner
        self.budget = budget
        
        switch budgetSelection {
        case "Daily":
            self.budgetSelection = .daily
        case "Monthly":
            self.budgetSelection = .monthly
        case "Trip":
            self.budgetSelection = .trip
        default:
            self.budgetSelection = .daily
        }
        
        for item in currencyStrings {
            if let currency = Currency.all.first(where: { $0.code == item}) {
                self.currencies.append(currency)
            }
        }
    }
}
