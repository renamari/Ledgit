//
//  MainViewController.swift
//  Ledgit
//
//  Created by Camden Madina on 8/12/17.
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
    
    var pageViewController:UIPageViewController?
    var isSignUp:Bool?
    var currentIndex = 0
    
    fileprivate(set) lazy var pageTitles:[String] = {
        return [
            Constants.TutorialTitles.first,
            Constants.TutorialTitles.second,
            Constants.TutorialTitles.third]
    }()
    
    fileprivate(set) lazy var pageColors:[UIColor] = {
        return [
            .kColor4083FF,
            .kColorEF7BC6,
            .kColor1F9DBF]
    }()
    
    fileprivate(set) lazy var pageDescriptions:[String] = {
        return [
            Constants.TutorialDescriptions.first,
            Constants.TutorialDescriptions.second,
            Constants.TutorialDescriptions.third]
    }()
    
    fileprivate(set) lazy var backgroundImageNames:[String] = {
        return ["tutorial-icon-0","tutorial-icon-1","tutorial-icon-2"]
    }()
    
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newTutorialViewController(0),
                self.newTutorialViewController(1),
                self.newTutorialViewController(2)]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        setupPageViewController()
    }
    
    func setupUI(){
        signupButton.createBorder(radius: Constants.CornerRadius.button, color: nil)
        signinButton.createBorder(radius: Constants.CornerRadius.button, color: .kColor308CF9)
        
    }
    
    func setupPageViewController(){
        
        // 1. Assign first view controller
        if let firstViewController = orderedViewControllers.first {
            
            // 2. Initialize new page view controller
            pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            pageViewController?.delegate = self
            pageViewController?.dataSource = self
            pageViewController?.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            pageViewController?.view.frame = CGRect(x: 0, y: 0, width: tutorialView.frame.width, height: tutorialView.frame.height)
            tutorialView.addSubview((pageViewController?.view)!)
        }
    }
    
    fileprivate func newTutorialViewController(_ index: Int) -> UIViewController {
        
        // 1. Create a new tutorial view controller screen
        let tutorialViewController = TutorialViewController.instantiate(from: .main)
    
        // 2. Update its properties
        tutorialViewController.backgroundImageName = backgroundImageNames[index]
        tutorialViewController.descriptionText = pageDescriptions[index]
        tutorialViewController.titleText = pageTitles[index]
        tutorialViewController.backgroundColor = pageColors[index]
        tutorialViewController.index = index
        
        // 3. Return tutorial screen
        return tutorialViewController
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        isSignUp = true
        performSegue(withIdentifier: Constants.SegueIdentifiers.authenticate, sender: nil)
    }
    
    @IBAction func signinButtonPressed(_ sender: Any) {
        isSignUp = false
        performSegue(withIdentifier: Constants.SegueIdentifiers.authenticate, sender: nil)
    }
    
    @IBAction func exploreButtonPressed(_ sender: Any) {
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.authenticate{
            if let authenticateViewController = segue.destination as? AuthenticateViewController{
                authenticateViewController.isSignUp = isSignUp!
                //authenticateViewController.isLoading = true
            }
        }
    }
    

}

//MARK:- UIPageViewController Delegate Extensions
extension MainViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        // 1. Check if there are any more view controllers to display
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        // 2. If yes, decrease the index by one
        let previousIndex = viewControllerIndex - 1
        
        // 3. Make sure you are not at the first screen
        guard previousIndex >= 0 else {
            return nil
        }
        
        // 4. Return the view controller to display
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        // 1. Check if there are any more view controllers to display
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        // 2. If yes, increase the index by one
        let nextIndex = viewControllerIndex + 1
        
        // 3. Make sure you are not at the first screen
        guard orderedViewControllers.count != nextIndex else {
            return nil
        }
        
        // 4. Return the view controller to display
        return orderedViewControllers[nextIndex]
    }
    
    
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
        let itemController = pendingViewControllers.first as! TutorialViewController
        currentIndex = itemController.index!
    }
}
