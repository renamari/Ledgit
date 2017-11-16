//
//  Utilities.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case main = "Main"
    case trips = "Trips"
    case settings = "Settings"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
    
    func viewController<Element: UIViewController>(of viewControllerClass: Element.Type) -> Element{
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! Element
    }
    
    func initialViewController() -> UIViewController?{
        return instance.instantiateInitialViewController()
    }
}

enum AuthenticationMethod {
    case signin
    case signup
}

enum TripActionMethod {
    case add
    case edit
}

struct DateSection {
    var date:Date
    var entries:[Entry]
}

struct CitySection {
    var location:String
    var amount:Double
}

enum PaymentType {
    case credit
    case cash
}

enum Subscription {
    case free
    case paid
}

enum BudgetSelection {
    case daily
    case monthly
    case trip
}

struct Trip {
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
    
    init?(dict: NSDictionary){
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

struct Entry {
    var key: String
    let date: Date
    let currency: Currency
    var location: String
    var description:String
    var category:String
    var paidBy: String
    var paymentType: PaymentType
    var cost: Double
    var owningTrip: String
    
    init(dict: NSDictionary) {
        guard let key = dict["key"] as? String,
        let date = (dict["date"] as? String)?.toDate(withFormat: nil),
        let description = dict["description"] as? String,
        let currency = Currency.getCurrency(withCode: dict["currency"] as! String),
        let location = dict["location"] as? String,
        let category = dict["category"] as? String,
        let paidBy = dict["paidBy"] as? String,
        let paymentType = dict["paymentType"] as? String,
        let owningTrip = dict["owningTrip"] as? String,
        let cost = dict["cost"] as? Double else {
            
            self.key = ""
            self.date = Date()
            self.description = ""
            self.currency = Currency.USD
            self.location = ""
            self.category = ""
            self.paidBy = ""
            self.paymentType = .cash
            self.cost = 0
            self.owningTrip = ""
            return
        }
        
        self.key = key
        self.date = date
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

struct User {
    var key: String
    var name: String?
    var email: String?
    var subscription: Subscription = .free
    var categories: [String] = ["Transportation", "Food", "Lodging", "Entertainment", "Emergency", "Miscellaneous"]
    var homeCurrency : Currency = .USD
    
    init(dict: NSDictionary){
        self.key = dict["uid"] as! String
        
        if let name = dict["name"] as? String{
            self.name = name
        }
        
        if let email = dict["email"] as? String{
            self.email = email
        }
        
        if let subscription = dict["subscription"] as? String{
            switch subscription{
            case "free":
                self.subscription = .free
            default:
                self.subscription = .paid
            }
        }
        
        if let categories = dict["categories"] as? [String]{
            self.categories = categories
        }
        
        if let currency = dict["homeCurrency"] as? String{
            if let homeCurrency = Currency.all.first(where:{ $0.code == currency}){
                self.homeCurrency = homeCurrency
            }
        }
    }
}

public protocol FormatterProtocol {
    func getNewPosition(forPosition: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition
}

class CurrencyFormatter : NumberFormatter, FormatterProtocol {
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
        guard obj != nil else { return }
        var str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if !string.isEmpty, numberStyle == .currency && !string.contains(currencySymbol) {
            // Check if the currency symbol is at the last index
            if let formattedNumber = self.string(from: 1), formattedNumber[formattedNumber.index(before: formattedNumber.endIndex)...] == currencySymbol {
                str = String(str[..<str.index(before: str.endIndex)])
            }
        }
        obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
    }
    
    func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
        return textInput.position(from: position, offset:((newValue?.count ?? 0) - (oldValue?.count ?? 0))) ?? position
    }
}


