//
//  MainViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase
import SwiftDate

class MainViewController: UIViewController {
    // NOTE: Removing sign up/in and explore buttons here
    // because opting for coredata first
    // so there is no need to get members to authenticate.
    // Not removing the IBOutlets/IBAction declarations in
    // case I want to add them back later
    //@IBOutlet weak var signupButton: UIButton!
    //@IBOutlet weak var signinButton: UIButton!
    //@IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tutorialView: UIView!
    private var pageViewController = UIPageViewController()
    private var presenter = AuthenticationPresenter(manager: AuthenticationManager())
    var isLoading: Bool = false {
        didSet {
            switch isLoading {
            case true:
                startLoading()
            case false:
                stopLoading()
            }
        }
    }

    var method: AuthenticationMethod = .signin
    var currentIndex = 0
    
    lazy var pageColors: [UIColor] = Constants.pageColors
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [createNewTutorialViewController(at: 0),
                createNewTutorialViewController(at: 1),
                createNewTutorialViewController(at: 2)]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPresenter()
        setupPageViewController()
    }
    
    func setupPresenter() {
        presenter.delegate = self
    }
    
    func setupUI() {
        startButton.roundedCorners(radius: Constants.cornerRadius.button)
        
        // NOTE: Look at the note at the top of the file
        //signupButton.roundedCorners(radius: Constants.cornerRadius.button)
        ///signinButton.roundedCorners(radius: Constants.cornerRadius.button, borderColor: LedgitColor.coreBlue)
    }
    
    func setupPageViewController() {
        // 1. Retrieve first view controller from ordered array
        guard let firstViewController = orderedViewControllers.first else { return }
        
        // 2. Initialize new page view controller
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: tutorialView.frame.width, height: tutorialView.frame.height)
        
        tutorialView.addSubview(pageViewController.view)
    }
    
    fileprivate func createNewTutorialViewController(at index: Int) -> UIViewController {
        
        // 1. Create a new tutorial view controller screen
        let tutorialViewController = TutorialViewController.instantiate(from: .main)
        
        // 2. Update its properties
        tutorialViewController.index = index
        
        // 3. Return tutorial screen
        return tutorialViewController
    }
    
    // MARK: - IBActions
    @IBAction func startButtonPressed(_ sender: Any) {
        // Always create a core data member by default
        isLoading = true
        presenter.authenticateUser(platform: .coreData, method: .signup)
    }
    
    // NOTE: Look at the note at the top of the file
    @IBAction func signupButtonPressed(_ sender: Any) {
        method = .signup
        performSegue(withIdentifier: Constants.segueIdentifiers.authenticate, sender: nil)
    }
    
    // NOTE: Look at the note at the top of the file
    @IBAction func signinButtonPressed(_ sender: Any) {
        method = .signin
        performSegue(withIdentifier: Constants.segueIdentifiers.authenticate, sender: nil)
    }
    
    // NOTE: Look at the note at the top of the file
    @IBAction func exploreButtonPressed(_ sender: Any) {}

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueIdentifiers.authenticate {
            guard let authenticateViewController = segue.destination as? AuthenticateViewController else { return }
            authenticateViewController.method = method
        }
    }
}

//MARK:- UIPageViewController Delegate Extensions
extension MainViewController: UIPageViewControllerDataSource {
    
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
        guard completed == true else { return }
            
        // 2. If yes, update the page control current indicator to change to index
        pageControl.currentPage = currentIndex
        pageControl.currentPageIndicatorTintColor = pageColors[currentIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        // 1. Update the current index to the view controller index user will transition to
        guard let controller = pendingViewControllers.first as? TutorialViewController else { return }
        currentIndex = controller.index
    }
}

extension MainViewController: AuthenticationPresenterDelegate {
    func successfulAuthentication(of user: LedgitUser) {
        isLoading = false
        LedgitUser.current = user
        
        let navigationController = TripsNavigationController.instantiate(from: .trips)
        present(navigationController, animated: true, completion: nil)
    }
    
    func displayError(_ error: LedgitError) {
        isLoading = false
        showAlert(with: error)
    }
}
