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

struct DateSection {
    var date:Date
    var entries:[Entry]
}

struct CitySection {
    var location:String
    var amount:Double
}

enum PaymentType {
    case creditCard
    case cash
}

enum Subscription {
    case free
    case paid
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
    
    init(dict: NSDictionary){
        self.name = dict["name"] as! String
        self.key = dict["key"] as! String
        self.startDate = dict["startDate"] as! String
        self.endDate = dict["endDate"] as! String
        //self.image = UIImage(named: dict["image"] as! String)!
        self.users = dict["users"] as! String
        self.owner = dict["owner"] as! String
        self.budget = dict["dailyBudget"] as! Double
        if let dict = dict["currencies"] as? [String]{
            for item in dict {
                if let currency = Currency.all.first(where: { $0.code == item}) {
                    self.currencies.append(currency)
                }
            }
        }
    }
}

struct Entry {
    let date: Date
    let currency: Currency
    var location: String
    var description:String
    var category:String
    var paidBy: String
    var paymentType: String
    var cost: Double
    var owningTrip: String
    
    init(dict: NSDictionary) {
        self.date = (dict["date"] as! String).toDate(withFormat: nil)
        self.description = dict["description"] as! String
        self.currency = Currency.DEFAULT.getCurrency(withCode: dict["currency"] as! String)
        self.location = dict["location"] as! String
        self.category = dict["category"] as! String
        self.paidBy = dict["paidBy"] as! String
        self.paymentType = dict["paymentType"] as! String
        self.cost = dict["cost"] as! Double
        self.owningTrip = dict["owningTrip"] as! String
    }
}

struct User {
    var name: String?
    var email: String?
    var subscription: Subscription = .free
    var categories: [String] = ["Transportation", "Food", "Lodging", "Entertainment", "Emergency", "Miscellaneous"]
    var homeCurrency : Currency = .USD
    
    init(dict: NSDictionary){
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
        return textInput.position(from: position, offset:((newValue?.characters.count ?? 0) - (oldValue?.characters.count ?? 0))) ?? position
    }
}


