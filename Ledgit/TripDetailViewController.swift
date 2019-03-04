//
//  TripDetailViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/18/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import SwiftDate
import MessageUI
import BubbleTransition
import NotificationBannerSwift
import AMPopTip
import BetterSegmentedControl

class TripDetailViewController: UIViewController {
    @IBOutlet var pageSegmentedControl: BetterSegmentedControl!
    
    private var presenter = TripDetailPresenter(manager: TripDetailManager())
    
    var currentIndex: Int = 0
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    let summaryViewController = SummaryViewController.instantiate(from: .trips)
    let categoryViewController = CategoryViewController.instantiate(from: .trips)
    let historyViewController = HistoryViewController.instantiate(from: .trips)
    lazy var pages: [UIViewController] = [summaryViewController, categoryViewController, historyViewController]
    
    var currentTrip: LedgitTrip?
    
    lazy var addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                          target: self,
                                                          action: #selector(addButtonPressed))
    
    lazy var exportButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                             target: self,
                                                             action: #selector(exportButtonPressed))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        setupPresenter()
        setupPageViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    func setupSegmentedControl() {
        let summarySegment = LabelSegment(text: "Summary", normalFont: .futuraMedium16, normalTextColor: LedgitColor.separatorGray,
                                          selectedFont: .futuraMedium16, selectedTextColor: LedgitColor.coreBlue)
        let categorySegment = LabelSegment(text: "Category", normalFont: .futuraMedium16, normalTextColor: LedgitColor.separatorGray,
                                           selectedFont: .futuraMedium16, selectedTextColor: LedgitColor.coreBlue)
        let historySegment = LabelSegment(text: "History", normalFont: .futuraMedium16, normalTextColor: LedgitColor.separatorGray,
                                          selectedFont: .futuraMedium16, selectedTextColor: LedgitColor.coreBlue)
        
        pageSegmentedControl.segments = [summarySegment, categorySegment, historySegment]
        pageSegmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }
    
    func setupPageViewController() {
        guard let firstViewController = pages.first else { return }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        
        view.addSubview(pageViewController.view)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: pageSegmentedControl.bottomAnchor).isActive = true
    }
    
    func setupPresenter() {
        guard let trip = currentTrip else {
            showAlert(with: LedgitError.errorGettingTrip)
            dismiss(animated: true, completion: nil)
            return
        }
        presenter.delegate = self
        presenter.attach(trip)
        presenter.fetchEntries()
        summaryViewController.presenter = presenter
        categoryViewController.presenter = presenter
        historyViewController.presenter = presenter
        historyViewController.delegate = self
    }
    
    func setupNavigationBar() {
        if #available(iOS 11.0, *), UIScreen.main.nativeBounds.height <= 1136 {
            navigationItem.largeTitleDisplayMode = .never
        }
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = LedgitColor.navigationBarGray
        
        navigationItem.rightBarButtonItems = shouldDisplayExportButton ? [addButton, exportButton] : [addButton]
    }

    var shouldDisplayExportButton: Bool {
        guard currentTrip?.key != Constants.projectID.sample else {
            Log.info("Did not set up export button because it was sample trip")
            return false
        }
        
        guard presenter.entries.count > 0 else {
            Log.info("Did not set up export because there are no entries in the trip")
            return false
        }
        
        return true
    }
    
    @objc func exportButtonPressed() {
        let banner = NotificationBanner(title: "Creating your expense report.")
        banner.backgroundColor = LedgitColor.coreBlue
        banner.autoDismiss = false
        
        banner.show(queuePosition: .front, bannerPosition: .top, queue: .default, on: nil)
    
        startLoading()
        
        //Set the default sharing message.
        guard let trip = currentTrip else {
            Log.warning("Tried to begin export process, but no trip available")
            return
        }
        
        // Create expense file
        guard let expenseFile = Utilities.createCSV(with: trip, and: presenter.entries) else {
            Log.critical("Could not create expense file")
            return
        }
        
        let message = "The expense report for your \(trip.name) trip."
        let shareViewController = UIActivityViewController(activityItems: [message, expenseFile], applicationActivities: nil)
        shareViewController.excludedActivityTypes = [.addToReadingList, .copyToPasteboard]
        
        present(shareViewController, animated: true) {
            self.stopLoading()
            banner.dismiss()
        }
    }
    
    @objc func addButtonPressed() {
        performSegue(withIdentifier: Constants.segueIdentifiers.entryAction, sender: nil)
    }
    
    @objc func segmentedControlChanged(control: BetterSegmentedControl) {
        let upcomingIndex = Int(control.index)
        
        while upcomingIndex != currentIndex {
            upcomingIndex < currentIndex ? goToPreviousPage() : goToNextPage()
            currentIndex += upcomingIndex < currentIndex ? -1 : 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueIdentifiers.entryAction {
            guard let entryActionViewController = segue.destination as? EntryActionViewController else { return }
            entryActionViewController.presenter = presenter
            entryActionViewController.parentTrip = currentTrip
            if let entry = sender as? LedgitEntry {
                entryActionViewController.entry = entry
                entryActionViewController.action = .edit
            }
        }
    }
}

extension TripDetailViewController: TripDetailPresenterDelegate {
    func receivedEntryUpdate() {
        summaryViewController.needsLayout = true
        categoryViewController.needsLayout = true
        historyViewController.needsLayout = true
    }
}

extension TripDetailViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 1. Check if there are any more view controllers to display
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        // 2. If yes, decrease the index by one
        let previousIndex = viewControllerIndex - 1
        
        // 3. Make sure you are not at the first screen
        guard previousIndex >= 0 else { return nil }
        
        // 4. Return the view controller to display
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // 1. Check if there are any more view controllers to display
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        // 2. If yes, increase the index by one
        let nextIndex = viewControllerIndex + 1
        
        // 3. Make sure you are not at the first screen
        guard pages.count != nextIndex else { return nil }
        
        // 4. Return the view controller to display
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // 1. Check if screen has finished transition from one view to next
        guard completed else { return }
        
        // 2. If yes, update the page control current indicator to change to index
        pageSegmentedControl.setIndex(UInt(currentIndex), animated: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        // 1. Update the current index to the view controller index user will transition to
        
        guard let controller = pendingViewControllers.first, let index = pages.index(where: { controller ==  $0 }) else { return }
        currentIndex = index
    }
    
    func goToNextPage() {
        guard let currentViewController = pageViewController.viewControllers?.first else { return }
        guard let nextViewController = pageViewController(pageViewController, viewControllerAfter: currentViewController) else { return }
        pageViewController.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
    
    func goToPreviousPage() {
        guard let currentViewController = pageViewController.viewControllers?.first else { return }
        guard let nextViewController = pageViewController(pageViewController, viewControllerBefore: currentViewController) else { return }
        pageViewController.setViewControllers([nextViewController], direction: .reverse, animated: true, completion: nil)
    }
}

extension TripDetailViewController: DayTableCellDelegate {
    func selected(entry: LedgitEntry, at cell: UITableViewCell) {
        performSegue(withIdentifier: Constants.segueIdentifiers.entryAction, sender: entry)
    }
}
