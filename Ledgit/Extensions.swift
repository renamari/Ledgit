//
//  Extensions.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

//MARK:- UIViewController Extensions
extension UIViewController{
    var loadingIndicatorTag: Int { return 999999 }
    
    class var storyboardID: String{
        return "\(self)"
    }
    
    static func instantiate(from storyboard: Storyboard) -> Self {
        return storyboard.viewController(of: self)
    }
    
    func showAlert(with dict: [String:String]){
        let title = dict["title"]
        let message = dict["message"]
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func startLoading(){
        
        let indicator = NVActivityIndicatorView(
            frame: CGRect(x: (self.view.frame.width - 60) / 2, y: (self.view.frame.height - 60) / 2, width: 60, height: 60),
            type: .ballClipRotatePulse,
            color: .ledgitBlue,
            padding: 0)
        
        indicator.tag = loadingIndicatorTag
        indicator.startAnimating()
        
        self.view.addSubview(indicator)
    }

    func stopLoading(){
        
        if let loadingIndicator = self.view.viewWithTag(loadingIndicatorTag) as? NVActivityIndicatorView{
            loadingIndicator.stopAnimating()
            loadingIndicator.removeFromSuperview()
        }
        
        // user can interact again with the app
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
}

//MARK: UIFont Extension
extension UIFont {
    static var futuraMedium8: UIFont { return UIFont(name: "Futura-Medium", size: 8.0)!}
    static var futuraMedium10: UIFont { return UIFont(name: "Futura-Medium", size: 10.0)!}
    static var futuraMedium12: UIFont { return UIFont(name: "Futura-Medium", size: 12.0)!}
    static var futuraMedium15: UIFont { return UIFont(name: "Futura-Medium", size: 15.0)!}
    static var futuraMedium17: UIFont { return UIFont(name: "Futura-Medium", size: 17.0)!}
    static var futuraMedium18: UIFont { return UIFont(name: "Futura-Medium", size: 18.0)!}
    static var futuraMedium30: UIFont { return UIFont(name: "Futura-Medium", size: 30.0)!}
}

//MARK:- UIColor Extensions
extension UIColor {
    
    private convenience init?(hex6: Int, alpha: Float) {
        self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
    }
    
    public convenience init?(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    public convenience init?(hex: Int, alpha: Float) {
        if (0x000000 ... 0xFFFFFF) ~= hex {
            self.init(hex6: hex, alpha: alpha)
        } else {
            self.init()
            return nil
        }
    }
}

//MARK:- String Extensions
extension UIColor {
    static var kColor4990E2: UIColor { return UIColor(red: 73.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)}
    static var kColorFF7D7D: UIColor { return UIColor(red: 255.0/255.0, green: 125.0/255.0, blue: 125.0/255.0, alpha: 1.0)}
    static var kColorE3CC00: UIColor { return UIColor(red: 227.0/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1.0)}
    static var kColor87BEFE: UIColor { return UIColor(red: 135.0/255.0, green: 190.0/255.0, blue: 254.0/255.0, alpha: 1.0)}
    static var kColorFDBFBF: UIColor { return UIColor(red: 253.0/255.0, green: 191.0/255.0, blue: 191.0/255.0, alpha: 1.0)}
    static var kColor4A4A4A: UIColor { return UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1.0)}
    
    // MARK:- Theme colors
    static var ledgitBlue: UIColor { return UIColor(hex: 0x308CF9)! }
    static var ledgitPink: UIColor { return UIColor(hex: 0xEF7BC6)! }
    static var ledgitAqua: UIColor { return UIColor(hex: 0x1F9DBF)! }
    static var ledgitYellow: UIColor { return UIColor(hex: 0xFFBA00)! }
    static var ledgitNavigationTextGray: UIColor { return UIColor(hex: 0x3F6072)! }
    static var ledgitNavigationBarGray: UIColor { return UIColor(hex: 0xF2F5F7)! }
    static var ledgitSeparatorGray: UIColor { return UIColor(hex: 0x9C9C9C)! }
    static var facbookBlue: UIColor { return UIColor(hex: 0x25479B)!}
    //Grey color
    static var kColor4E4E4E: UIColor { return UIColor(red: 78.0/255.0, green: 78.0/255.0, blue: 78.0/255.0, alpha: 1.0)}
    //Light Gray Color
    static var kColorEBEBEB: UIColor { return UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)}
    //Text color gray
    static var kColor587685: UIColor { return UIColor(red: 88.0/255.0, green: 118.0/255.0, blue: 133.0/255.0, alpha: 1.0)}
    
    //MARK:- Pie Chart Colors
    static var kColor003559: UIColor {return UIColor(red: 0.0/255.0, green: 53.0/255.0, blue: 89.0/255.0, alpha: 1.0)}
    static var kColor061A40: UIColor { return UIColor(red: 6.0/255.0, green: 26.0/255.0, blue: 64.0/255.0, alpha: 1.0)}
    static var kColorB9D6F2: UIColor { return UIColor(red: 185.0/255.0, green: 214.0/255.0, blue: 242.0/255.0, alpha: 1.0)}
    static var kColor76DDFB: UIColor { return UIColor(red: 118.0/255, green: 221.0/255.0, blue: 251.0/255, alpha: 1.0)}
    static var kColor2C82BE: UIColor { return UIColor(red: 44.0/255.0, green: 130.0/255.0, blue: 190.0/255.0, alpha: 1.0)}
}

//MARK:- Date Extensions
extension Date {
    func toString(style format: LedgitDateStyle) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
}

// MARK:- String Extensions
extension String{
    
    // Returns true if the string has at least one character in common with matchCharacters.
    func containsCharactersIn(matchCharacters: String) -> Bool{
        let characterSet = NSCharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet as CharacterSet) != nil
    }
    
    // Returns true if the string contains only characters found in matchCharacters.
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool{
        let disallowedCharacterSet = NSCharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet as CharacterSet) != nil
    }
    
    // Returns true if the string has no characters in common with matchCharacters.
    func doesNotContainCharactersIn(matchCharacters: String) -> Bool{
        let characterSet = NSCharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet as CharacterSet) != nil
    }
    
    func isNumeric() -> Bool{
        let scanner = Scanner(string: self)
        scanner.locale = Locale.current
        
        return scanner.scanDecimal(nil) && scanner.isAtEnd
    }
    
    func toDate(withFormat format:String?) -> Date {
        let formatter = DateFormatter()
        
        if let format = format { formatter.dateFormat = format }
        else { formatter.dateFormat = "MMMM dd, yyyy" }
        
        return formatter.date(from: self)!
    }
    
    func strip() -> String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UIView {
    
    func addTapRecognizer(with action: Selector) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: action)
        
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func createBorder(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func createBorder(radius: CGFloat, color: UIColor){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
    }
    
    func dashedBorder(withColor color: CGColor){
        self.layer.sublayers?.last?.removeFromSuperlayer()
        
        let layer = CAShapeLayer()
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        layer.frame = frame
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color
        layer.lineWidth = 1
        layer.lineJoin = kCALineJoinRound
        layer.lineDashPattern = [4 , 2]
        layer.path = UIBezierPath(roundedRect: frame, cornerRadius: 5).cgPath
        layer.masksToBounds = true
        self.layer.addSublayer(layer)
        
    }
    
    // view1: represents view which should be hidden and from which we are starting
    // view2: represents view which is second view or behind of view1
    // isReverse: default if false, but if we need reverse animation we pass true and it
    // will Flip from Left
    
    func flipTransition (with view2: UIView, isReverse: Bool = false) {
        var transitionOptions = UIViewAnimationOptions()
        transitionOptions = isReverse ? [.transitionFlipFromLeft] : [.transitionFlipFromRight] // options for transition
        
        // animation durations are equal so while first will finish, second will start
        // below example could be done also using completion block.
        
        UIView.transition(with: self, duration: 0.5, options: transitionOptions, animations: {
            self.isHidden = true
        })
        
        UIView.transition(with: view2, duration: 0.5, options: transitionOptions, animations: {
            view2.isHidden = false
        })
    }
}

extension UILayoutPriority: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    public init(floatLiteral value: Float) {
        self.init(rawValue: value)
    }
    
    public init(integerLiteral value: Int) {
        self.init(rawValue: Float(value))
    }
    
    public static func +(lhs: UILayoutPriority, rhs: UILayoutPriority) -> UILayoutPriority {
        return UILayoutPriority(rawValue: lhs.rawValue + rhs.rawValue)
    }
    
    public static func -(lhs: UILayoutPriority, rhs: UILayoutPriority) -> UILayoutPriority {
        return UILayoutPriority(rawValue: lhs.rawValue - rhs.rawValue)
    }
}

// MARK:- Table View Extensions
extension UITableView {
    func lastRow(at section: Int) -> Int{
        return self.numberOfRows(inSection: section) - 1
    }
}

extension DefaultsKeys {
    static let user = DefaultsKey<LedgitUser?>("user")
}
