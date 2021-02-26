//
//  NavigationCoordinator+Navigate.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 2/17/21.
//  Copyright © 2021 Camden Developers. All rights reserved.
//

import UIKit

/**
 Coordinator is a specialized class that encapsulates a segment of similar flows, yet subclasses `UINavigationController` in order to integrate well with the iOS ecosystem.
 As a result, we want to expose a special method that calls the underlying `UINavigationController` navigation methods instead of allowing Coordinator subclasses to do so.
 */

public extension NavigationCoordinator {
    enum NavigationAction {
        case setStack([UIViewController])
        case resetStack
        case forward(UIViewController)
        case back(UIViewController)
        case present(UIViewController)
        case dismiss
    }
    
    /**
     Performs navigation to other `UIViewController` or `Coordinator`.
     - Parameters:
        - action: The desired navigation action to perform. See `NavigationAction`.
        - animated: Whether the navigation should be animated. Default is `true`.
        - perform: A block called before the navigation occurs. Use this to perform any additional work such as analytics.
     */
    func navigate(withAction action: NavigationAction, animated: Bool = true, onPerform: (() -> Void)? = nil) {
        onPerform?()
        
        switch action {
        case .setStack(let stack):
            precondition(!stack.isEmpty)
            super.setViewControllers(stack, animated: animated)
            
        case .resetStack:
            super.popToRootViewController(animated: animated)
            
        case .forward(let viewController):
            super.pushViewController(viewController, animated: animated)
            
        case .back(let viewController):
            super.popToViewController(viewController, animated: animated)
             
        case .present(let viewController):
            super.present(viewController, animated: animated, completion: nil)
            
        case .dismiss:
            super.dismiss(animated: animated)
        }
    }
}

extension NavigationCoordinator {
    @available(*, unavailable, message: "NavigationCoordinator subclasses should not invoke pushViewController(:animated:) directly. Please use navigate(withAction:animated:).")
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
    }
    
    @available(*, unavailable, message: "NavigationCoordinator subclasses should not invoke showDetailViewController(:sender:) directly. Please use navigate(withAction:animated:).")
    public override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        
    }
    
    @available(*, unavailable, message: "NavigationCoordinator subclasses should not invoke show(:sender:) directly. Please use navigate(withAction:animated:).")
    public override func show(_ vc: UIViewController, sender: Any?) {
        
    }
    
    @available(*, unavailable, message: "NavigationCoordinator subclasses should not invoke present(:animated:completion:) directly. Please use navigate(withAction:animated:).")
    public override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        
    }
    
    @available(*, unavailable, message: "NavigationCoordinator subclasses should not invoke popToRootViewController(animated:) directly. Please use navigate(withAction:animated:)")
    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        fatalError("This method should never fatal because it's unavailable to subclasses. We should be calling `super` instead.")
    }
    
    @available(*, unavailable, message: "NavigationCoordinator subclasses should not invoke setViewControllers(:animated:) directly. Please use navigate(withAction:animated:).")
    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        
    }
    
    @available(*, unavailable, message: "NavigationCoordinator subclasses should not invoke setViewControllers(animated:completion:) directly. Please use navigate(withAction:animated:).")
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        
    }
    
    @available(*, unavailable, message: "NavigationCoordinator subclasses should not invoke popToViewController(:animated:) directly. Please use navigate(withAction:animated:).")
    open override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        fatalError("This method should never fatal because it's unavailable to subclasses. We should be calling `super` instead.")
    }
}
