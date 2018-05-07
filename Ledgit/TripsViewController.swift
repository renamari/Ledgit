//
//  TripsViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class TripsViewController: UIViewController {
    @IBOutlet weak var tripsTableView: UITableView!
    private let presenter = TripsPresenter(manager: TripsManager())
    private var selectedIndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupPresenter()
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .white
    }
    
    func setupPresenter() {
        presenter.delegate = self
        presenter.retrieveTrips()
    }
    
    func setupTableView(){
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
        tripsTableView.rowHeight = 215
    }
    
    func setupGestureRecognizers() {
        let edgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(swipedEdge(gesture:)))
        edgeRecognizer.edges = .left
        view.addGestureRecognizer(edgeRecognizer)
    }
    
    @objc func swipedEdge(gesture: UIGestureRecognizer) {
        guard let gesture = gesture as? UIScreenEdgePanGestureRecognizer else { return }
        guard gesture.edges == .left else { return }
        
        settingsButtonPressed(gesture)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let navigationController = SettingsNavigationController.instantiate(from: .settings)

        present(navigationController, animated: true, completion: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueIdentifiers.action {
            guard let destinationViewController = segue.destination as? TripActionViewController else { return }
            guard let selectedRow = sender as? Int else { return }
            destinationViewController.delegate = self
            destinationViewController.presenter = presenter
            
            if selectedRow == tripsTableView.lastRow() {
                destinationViewController.method = .add
                
            } else {
                destinationViewController.method = .edit
                destinationViewController.trip = presenter.trips[selectedRow]
            }
            
        } else if segue.identifier == Constants.segueIdentifiers.detail {
            guard  let destinationViewController = segue.destination as? TripDetailViewController else { return }
            guard let selectedRow = tripsTableView.indexPathForSelectedRow?.row else { return }
            destinationViewController.title = presenter.trips[selectedRow].name
            destinationViewController.currentTrip = presenter.trips[selectedRow]
        }
    }
}

extension TripsViewController: TripActionDelegate {
    func added(trip dict: NSDictionary) {
        presenter.createNew(trip: dict)
    }
    
    func edited(_ trip: LedgitTrip) {
        if let index = presenter.trips.index(where: { $0.key == trip.key }) {
            presenter.trips.remove(at: index)
            presenter.trips.insert(trip, at: index)
            presenter.edited(trip)
            tripsTableView.reloadData()
        }
    }
}

extension TripsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.trips.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tableView.lastRow() { //Is last index path
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.add, for: indexPath) as! AddTripTableViewCell
            cell.configure()
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.trip, for: indexPath) as! TripTableViewCell
            let trip = presenter.trips[indexPath.row]
            cell.configure(with: trip, at: indexPath)
            
            return cell
        }
    }
}

extension TripsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        if indexPath.row == tableView.lastRow() {
            performSegue(withIdentifier: Constants.segueIdentifiers.action, sender: indexPath.row)
        
        } else {
            performSegue(withIdentifier: Constants.segueIdentifiers.detail, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.row != tableView.lastRow() else { return false } //Cannot delete last row
        
        return true
    }
 
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard indexPath.row != tableView.lastRow() else { return nil }
        let selectedRow = indexPath.row
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { [unowned self] (row, index) in
            self.performSegue(withIdentifier: Constants.segueIdentifiers.action, sender: indexPath.row)
        }
        
        edit.backgroundColor = LedgitColor.coreYellow
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [unowned self] (row, index) in
            
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this trip?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                
                if selectedRow == 0 && (UserDefaults.standard.value(forKey: Constants.userDefaultKeys.sampleTrip) as? Bool) == true {
                    UserDefaults.standard.set(false, forKey: Constants.userDefaultKeys.sampleTrip)
                }
                
                tableView.beginUpdates()
                self.presenter.removeTrip(at: selectedRow)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                
            }
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        if selectedRow == 0 && (UserDefaults.standard.value(forKey: Constants.userDefaultKeys.sampleTrip) as? Bool) == true {
            return [delete]
        } else {
            return [delete, edit]
        }
    }
}

extension TripsViewController: TripsPresenterDelegate {
    func retrievedSampleTrip() {
        tripsTableView.beginUpdates()
        tripsTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
        tripsTableView.endUpdates()
    }
    
    func retrievedTrip() {
        tripsTableView.beginUpdates()
        tripsTableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .right)
        tripsTableView.endUpdates()
        
        var index: Double = 0
        tripsTableView.visibleCells.forEach { cell in
            cell.transform = CGAffineTransform(translationX: 0, y: tripsTableView.bounds.size.height)
            
            UIView.animate(withDuration: 1.5, delay: 0.05 * index, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            
            index += 1
        }
    }
    
    func addedTrip() {
        tripsTableView.reloadData()
    }
}
