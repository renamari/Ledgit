//
//  TripsViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

class TripsViewController: UIViewController, AddTripDelegate {
    @IBOutlet weak var tripsTableView: UITableView!
    
    fileprivate(set) lazy var cellImageNames:[String] = {
        return ["circle-icon","heptagon-icon","triangle-icon"]
    }()
    
    var trips:[Trip] = []
    
    var isLoading:Bool = false{
        didSet{
            switch isLoading{
            case true:
                startLoading()
            default:
                stopLoading()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .white
    }
    
    func setupView(){
        if (UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.sampleProject) as? Bool) == true{
            Model.model.fetchSampleTrip(completion: { (trip) in
                self.trips.insert(trip, at: 0)
                
                self.tripsTableView.beginUpdates()
                self.tripsTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
                self.tripsTableView.endUpdates()
            })
        }
    }
    
    func setupTableView(){
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
        tripsTableView.rowHeight = 215
        
        fetchTrips()
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: Constants.NavigationIdentifiers.settings) as! UINavigationController
        
        present(navigationController, animated: true, completion: nil)
    }
    
    func addedTrip(dict: NSDictionary) {
        Model.model.createNewTrip(trip: dict)
    }
    
    func fetchTrips(){
        Model.model.fetchTrip { [unowned self] (trip) in
            let numRows = self.tripsTableView.numberOfRows(inSection: 0)
            
            self.trips.append(trip)
            
            self.tripsTableView.beginUpdates()
            self.tripsTableView.insertRows(at: [IndexPath(row: numRows - 1, section: 0)], with: .right)
            self.tripsTableView.endUpdates()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.add{
            if let destinationViewController = segue.destination as? AddTripViewController{
                destinationViewController.delegate = self
            }
        }else if segue.identifier == Constants.SegueIdentifiers.detail{
            if let destinationViewController = segue.destination as? TripDetailViewController{
                if let selectedRow = tripsTableView.indexPathForSelectedRow?.row{
                    destinationViewController.currentTrip = trips[selectedRow]
                }
            }
        }
    }
}

extension TripsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == trips.count { //Is last index path
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTripCell", for: indexPath) as! AddTripTableViewCell
            cell.configure()
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripTableViewCell
            let trip = trips[indexPath.row]
            cell.configure(with: trip)
            
            return cell
        }
    }
}

extension TripsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            // Selected add trip cell
            performSegue(withIdentifier: Constants.SegueIdentifiers.add, sender: self)
        
        }else{
            //Create trip detail view controller
            performSegue(withIdentifier: Constants.SegueIdentifiers.detail, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            //Cannot delete last row
            return false
        }else{
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            return .none
        }else{
            return .delete
        }
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this trip?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            // 1. If user swipes to delete
            if editingStyle == .delete {
                
                // 2. Create local variables for the section and selected row
                let selectedRow = indexPath.row
                
                // 3. Retrieve item info in selected cell
                let item = self.trips[selectedRow]
                
                // 4. Delete item from Firebase with item key
                let itemKey = item.key
                
                if selectedRow == 0 {
                    UserDefaults.standard.set(false, forKey: Constants.UserDefaultKeys.sampleProject)
                }else{
                    
                   Model.model.removeTrip(withKey: itemKey, completion: { 
                    self.trips.remove(at: selectedRow)
                    
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.endUpdates()
                   })
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
}
