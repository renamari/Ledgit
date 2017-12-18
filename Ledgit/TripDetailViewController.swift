//
//  TripDetailViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/18/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import SwiftDate
import BubbleTransition

class TripDetailViewController: UIViewController {
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    private let transition = BubbleTransition()
    private let cellHeightScale: CGFloat = Constants.scales.cellHeight
    private let cellWidthScale: CGFloat = Constants.scales.cellWidth
    
    var currentTrip: LedgitTrip?
    var presenter: TripDetailPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupPresenter()
        setupNavigationBar()
        setupCollectionView()
        
        Currency.getRates { rates in
            print(rates)
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    func setupPresenter() {
        guard let trip = currentTrip else {
            showAlert(with: Constants.clientErrorMessages.errorGettingTrip)
            dismiss(animated: true, completion: nil)
            return
        }
        presenter = TripDetailPresenter(manager: TripDetailManager(), and: trip)
        presenter?.delegate = self
        presenter?.fetchEntries()
    }
    
    func setupButton(){
        actionButton.createBorder(radius: actionButton.frame.height / 2)
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .ledgitNavigationBarGray
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        guard currentTrip?.key != Constants.projectID.sample else {
            showAlert(with: Constants.clientErrorMessages.cannotAddEntriesToSample)
            return
        }
        performSegue(withIdentifier: Constants.segueIdentifiers.addEntry, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueIdentifiers.addEntry {
            guard let addEntryViewController = segue.destination as? AddEntryViewController else {
                return
            }
            addEntryViewController.presenter = presenter
            addEntryViewController.transitioningDelegate = self
            addEntryViewController.modalPresentationStyle = .custom
        }
    }
}

extension TripDetailViewController: TripDetailPresenterDelegate {
    func retrieveEntry() {
        collectionView.reloadData()
    }
}

extension TripDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifiers.weekly, for: indexPath) as! WeeklyCollectionViewCell
            if let presenter = presenter {
                cell.setupChart(with: presenter.entries)
                cell.updateLabels(dayAmount: presenter.costToday, budgetAmount: presenter.trip.budget, remainingAmount: presenter.trip.budget - presenter.costToday, averageAmount: presenter.averageCost)
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifiers.category, for: indexPath) as! CategoryCollectionViewCell
            if let presenter = presenter { cell.setupChart(with: presenter.entries) }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifiers.history, for: indexPath) as! HistoryCollectionViewCell
            if let presenter = presenter { cell.updateTableViews(with: presenter.entries) }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height * cellHeightScale
        let width = collectionView.frame.width * cellWidthScale
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth:CGFloat = collectionView.frame.width * cellWidthScale
        let inset = (collectionView.frame.width - cellWidth) / 2
        return UIEdgeInsetsMake(0, inset, 0, inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let cellWidth:CGFloat = collectionView.frame.width * 0.90
        return collectionView.frame.width - cellWidth
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = Float(collectionView!.frame.width * 0.90)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionView!.contentSize.width)
        var newPage = Float(pageControl.currentPage)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? pageControl.currentPage + 1 : pageControl.currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        pageControl.currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
}

extension TripDetailViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = actionButton.center
        transition.bubbleColor = actionButton.backgroundColor!
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = actionButton.center
        transition.bubbleColor = actionButton.backgroundColor!
        return transition
    }
}
