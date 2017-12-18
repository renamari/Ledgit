//
//  LedgitUser.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/19/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation

struct LedgitUser {
    var key: String
    var name: String?
    var email: String?
    var subscription: Subscription = .free
    var categories: [String] = ["Transportation", "Food", "Lodging", "Entertainment", "Emergency", "Miscellaneous"]
    var homeCurrency : Currency = .USD
    
    init?(dict: NSDictionary){
        guard
            let key = dict["uid"] as? String
        else {
            return nil
        }
        
        self.key = key
        self.name = dict["name"] as? String
        self.email = dict["email"] as? String
        
        if let currency = dict["homeCurrency"] as? String {
            if let homeCurrency = Currency.all.first(where:{ $0.code == currency}){
                self.homeCurrency = homeCurrency
            }
        }
        
        if let categories = dict["categories"] as? [String] {
            self.categories = categories
        }
        
        if let subscription = dict["subscription"] as? String {
            switch subscription{
            case "free":
                self.subscription = .free
            default:
                self.subscription = .paid
            }
        }
    }
}

extension LedgitUser {
    static var current: LedgitUser?
}
