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
    case signin, signup
}

enum LedgitAction {
    case add, edit
}

struct DateSection {
    var date: Date
    var entries: [LedgitEntry]
    var collapsed: Bool = false
}

struct CitySection {
    var location: String
    var amount: Double
}

enum PaymentType: String {
    case credit = "Credit"
    case cash = "Cash"
}

enum Subscription: String {
    case free = "Free"
    case paid = "Paid"
}

enum BudgetSelection: String {
    case daily = "Daily"
    case trip = "Trip"
}

enum LedgitDateStyle: String {
    case full = "MMMM d, yyyy"
    case long = "MMM d, yyyy"
    case medium = "EEEE, MMM d"
    case month = "MMM"
    case short = "MM/dd/yyyy"
    case day = "E"
    case year = "yyyy"
}

infix operator <=: NilCoalescingPrecedence
public func <=<T>(lhs: inout T, rhs: T?) {
    lhs = rhs ?? lhs
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



func makeError(_ string: String) -> Error {
    return NSError(domain: "RenameMeErrorDomain",
                   code: 1,
                   userInfo: [NSLocalizedDescriptionKey: string])
}

struct Log {
    
    static func debug(_ string: String,
                      _ method: String = #function,
                      _ line: Int = #line) {
        print("\(Date()): <DEBUG>\t\t\(string)")
    }
    
    static func info(_ string: String,
                     _ method: String = #function,
                     _ line: Int = #line) {
        print("\(Date()): <INFO>\t\t\(string)")
    }
    
    static func warning(_ string: String,
                        _ method: String = #function,
                        _ line: Int = #line) {
        print("\(Date()): <WARNING>\t\(string)")
    }
    
    static func critical(_ string: String,
                         _ method: String = #function,
                         _ line: Int = #line) {
        print("\(Date()): <CRITICAL>\t\(string)")
    }
    
    static func error(_ error: Error,
                      _ method: String = #function,
                      _ line: Int = #line) {
        print("\(Date()): <ERROR>\t\t\(error.localizedDescription)")
    }
}
