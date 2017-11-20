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
    
    fileprivate var entries: [LedgitEntry] = []
    fileprivate var dayCost: Double = 0
    fileprivate var totalCost: Double = 0
    fileprivate var averageCost: Double = 0
    fileprivate var daysSeen: [Date] = []
    
    let transition = BubbleTransition()
    
    let cellHeightScale: CGFloat = Constants.Scales.cellHeight
    let cellWidthScale: CGFloat = Constants.Scales.cellWidth
    
    var currentTrip: LedgitTrip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        
        setupUI()
        
        setupNavigationBar()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    func setupUI() {
        
      
    }
    
    func setupButton(){
        actionButton.layer.cornerRadius = actionButton.frame.height / 2
        actionButton.layer.masksToBounds = true
        actionButton.clipsToBounds = true
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchEntries()
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .ledgitNavigationBarGray
    }
    
    func fetchEntries(){
        guard currentTrip != nil else{
            return
        }
        
        Service.shared.fetchEntry(inTrip: currentTrip!) { [unowned self] (entry) in
            if !self.daysSeen.contains(entry.date){
                self.daysSeen.append(entry.date)
            }
            
            if entry.date.isToday{
                self.dayCost += entry.cost
                
            }
            
            self.totalCost += entry.cost
            self.averageCost = self.totalCost / Double(self.daysSeen.count)
            
            self.entries.append(entry)
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        guard currentTrip?.key != Constants.ProjectID.sample else {
            showAlert(with: Constants.ClientErrorMessages.cannotAddEntriesToSample)
            return
        }
        
        performSegue(withIdentifier: Constants.SegueIdentifiers.addEntry, sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.addEntry {
            guard let addEntryViewController = segue.destination as? AddEntryViewController else {
                return
            }
            
            addEntryViewController.owningTrip = currentTrip
            addEntryViewController.transitioningDelegate = self
            addEntryViewController.modalPresentationStyle = .custom
        }
    }
}

extension TripDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.weekly, for: indexPath) as! WeeklyCollectionViewCell
            cell.setupChart(with: entries)
            cell.updateLabels(dayAmount: dayCost, budgetAmount: currentTrip!.budget, remainingAmount: currentTrip!.budget - dayCost, averageAmount: averageCost)
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.category, for: indexPath) as! CategoryCollectionViewCell
            cell.setupChart(with: entries)
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.history, for: indexPath) as! HistoryCollectionViewCell
            cell.updateTableViews(with: entries)
            
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
