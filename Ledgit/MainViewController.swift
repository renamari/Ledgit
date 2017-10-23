//
//  MainViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import Stevia
import NVActivityIndicatorView
import Firebase
import SwiftDate

class MainViewController: UIViewController {
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tutorialView: UIView!
    private var pageViewController: UIPageViewController?

    var method: AuthenticationMethod = .signin
    var currentIndex = 0
    
    fileprivate lazy var pageColors: [UIColor] = Constants.pageColors
    
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newTutorialViewController(with: 0),
                self.newTutorialViewController(with: 1),
                self.newTutorialViewController(with: 2)]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        setupPageViewController()
    }
    
    func setupUI(){
        signupButton.createBorder(radius: Constants.CornerRadius.button)
        signinButton.createBorder(radius: Constants.CornerRadius.button, color: .ledgitBlue)
    }
    
    func setupPageViewController(){
        
        // 1. Retrieve first view controller from ordered array
        guard let firstViewController = orderedViewControllers.first as? TutorialViewController else { return }
        
        // 2. Initialize new page view controller
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController?.delegate = self
        pageViewController?.dataSource = self
        pageViewController?.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        pageViewController?.view.frame = CGRect(x: 0, y: 0, width: tutorialView.frame.width, height: tutorialView.frame.height)
        
        guard let view = pageViewController?.view else { return }
        tutorialView.addSubview(view)
    }
    
    fileprivate func newTutorialViewController(with index: Int) -> UIViewController {
        
        // 1. Create a new tutorial view controller screen
        let tutorialViewController = TutorialViewController.instantiate(from: .main)
        
        // 2. Update its properties
        tutorialViewController.index = index
        
        // 3. Return tutorial screen
        return tutorialViewController
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        method = .signup
        performSegue(withIdentifier: Constants.SegueIdentifiers.authenticate, sender: nil)
    }
    
    @IBAction func signinButtonPressed(_ sender: Any) {
        method = .signin
        performSegue(withIdentifier: Constants.SegueIdentifiers.authenticate, sender: nil)
    }
    
    @IBAction func exploreButtonPressed(_ sender: Any) {
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == Constants.SegueIdentifiers.authenticate{
            guard let authenticateViewController = segue.destination as? AuthenticateViewController else{
                return
            }
            authenticateViewController.method = method
        }
    }
}

//MARK:- UIPageViewController Delegate Extensions
extension MainViewController: UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        // 1. Check if there are any more view controllers to display
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
        // 2. If yes, decrease the index by one
        let previousIndex = viewControllerIndex - 1
        
        // 3. Make sure you are not at the first screen
        guard previousIndex >= 0 else { return nil }
        
        // 4. Return the view controller to display
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        // 1. Check if there are any more view controllers to display
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
        
        // 2. If yes, increase the index by one
        let nextIndex = viewControllerIndex + 1
        
        // 3. Make sure you are not at the first screen
        guard orderedViewControllers.count != nextIndex else { return nil }
        
        // 4. Return the view controller to display
        return orderedViewControllers[nextIndex]
    }
}

extension MainViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // 1. Check if screen has finished transition from one view to next
        if completed {
            
            // 2. If yes, update the page control current indicator to change to index
            pageControl.currentPage = currentIndex
            pageControl.currentPageIndicatorTintColor = pageColors[currentIndex]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        // 1. Update the current index to the view controller index user will transition to
        guard let controller = pendingViewControllers.first as? TutorialViewController, let index = controller.index else { return }
        
        currentIndex = index
    }
}
