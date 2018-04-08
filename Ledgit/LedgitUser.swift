//
//  LedgitUser.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/19/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation

struct LedgitUser: Equatable {
    var key: String = ""
    var name: String = ""
    var email: String = ""
    var subscription: Subscription = .free
    var homeCurrency: Currency = .USD
    var categories = ["Transportation", "Food", "Lodging", "Entertainment", "Emergency", "Miscellaneous"]
    var dictionaryRepresentation: NSDictionary = [:]
    
    init() {}
    
    init(dict: NSDictionary) {
        key <= dict["uid"] as? String
        name <= dict["name"] as? String
        email <= dict["email"] as? String
        categories <= dict["categories"] as? [String]
        dictionaryRepresentation = dict
        
        if let currencyString = dict["homeCurrency"] as? String {
            homeCurrency <= Currency.get(with: currencyString)
        }
        
        if let subscriptionString = dict["subscription"] as? String {
            subscription <= Subscription(rawValue: subscriptionString)
        }
    }
}

extension LedgitUser {
    static var current = LedgitUser()
}

extension LedgitUser {
    static func ==(lhs: LedgitUser, rhs: LedgitUser) -> Bool {
        return lhs.key == rhs.key
    }
}
