//
//  UIViewController+Content.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 3/4/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
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
            color: LedgitColor.coreBlue,
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
