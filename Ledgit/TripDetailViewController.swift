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
    private var presenter = TripDetailPresenter(manager: TripDetailManager())
    var identifiers = [Constants.cellIdentifiers.weekly,
                       Constants.cellIdentifiers.category,
                       Constants.cellIdentifiers.history]
    var currentTrip: LedgitTrip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupPresenter()
        setupGestureRecognizers()
        setupNavigationBar()
        setupCollectionView()
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
        presenter.delegate = self
        presenter.attachTrip(trip)
        presenter.fetchEntries()
    }
    
    func setupButton(){
        actionButton.roundedCorners(radius: actionButton.frame.height / 2)
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
    
    func setupGestureRecognizers() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        guard currentTrip?.key != Constants.projectID.sample else {
            showAlert(with: Constants.clientErrorMessages.cannotAddEntriesToSample)
            return
        }
        performSegue(withIdentifier: Constants.segueIdentifiers.addEntry, sender: self)
    }
    
    @objc func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
            
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            
        case .changed:
            guard let view = gesture.view else { return }
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: view))
        
        case .ended:
            collectionView.endInteractiveMovement()
            
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Constants.segueIdentifiers.addEntry:
            guard let addEntryViewController = segue.destination as? AddEntryViewController else { return }
            addEntryViewController.presenter = presenter
            addEntryViewController.transitioningDelegate = self
            addEntryViewController.modalPresentationStyle = .custom
            
        default: break
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
        return identifiers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = identifiers[indexPath.row]
        
        switch identifier {
            
        case Constants.cellIdentifiers.weekly:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WeeklyCollectionViewCell
            cell.setup(with: presenter)
            return cell
            
        case Constants.cellIdentifiers.category:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CategoryCollectionViewCell
            cell.setup(with: presenter)
            return cell
            
        case Constants.cellIdentifiers.history:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! HistoryCollectionViewCell
            cell.setup(with: presenter)
            cell.delegate = self
            
            return cell
            
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let identifier = identifiers.remove(at: sourceIndexPath.item)
        identifiers.insert(identifier, at: destinationIndexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height * cellHeightScale
        let width = collectionView.frame.width * cellWidthScale
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth: CGFloat = collectionView.frame.width * cellWidthScale
        let inset = (collectionView.frame.width - cellWidth) / 2
        return UIEdgeInsetsMake(0, inset, 0, inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let cellWidth: CGFloat = collectionView.frame.width * cellWidthScale
        return collectionView.frame.width - cellWidth
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = Float(collectionView!.frame.width * cellWidthScale)
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

extension TripDetailViewController: DayTableCellDelegate {
    func selected(entry: LedgitEntry) {
        performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        print(entry)
    }
}
