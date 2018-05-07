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
    var provider: String = "Ledgit"
    var subscription: Subscription = .free
    var homeCurrency: Currency = .USD
    var categories = ["Transportation", "Food", "Lodging", "Entertainment", "Emergency", "Miscellaneous"]
    var dictionaryRepresentation: NSDictionary = [:]
    
    struct Keys {
        static let key = "uid"
        static let name = "name"
        static let email = "email"
        static let subscription = "subscription"
        static let homeCurrency = "homeCurrency"
        static let categories = "categories"
        static let provider = "provider"
    }
    
    init() {}
    
    init(dict: NSDictionary) {
        key <= dict[LedgitUser.Keys.key] as? String
        name <= dict[LedgitUser.Keys.name] as? String
        email <= dict[LedgitUser.Keys.email] as? String
        provider <= dict[LedgitUser.Keys.provider] as? String
        categories <= dict[LedgitUser.Keys.categories] as? [String]
        dictionaryRepresentation = dict
        
        if let currencyString = dict[LedgitUser.Keys.homeCurrency] as? String {
            homeCurrency <= Currency.get(with: currencyString)
        }
        
        if let subscriptionString = dict[LedgitUser.Keys.subscription] as? String {
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
