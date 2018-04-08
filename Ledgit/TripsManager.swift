//
//  TripsManager.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 10/22/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation
import Firebase
import CoreData

enum DataSource {
    case firebase
    case coreData
}

protocol TripsManagerDelegate: class {
    func retrievedSampleTrip(_ trip: LedgitTrip)
    func retrievedTrip(_ trip: LedgitTrip)
    func addedTrip()
}

class TripsManager {
    weak var delegate: TripsManagerDelegate?
    let auth = Auth.auth()
    let trips = Database.database().reference().child("trips")
    var isConnected: Bool { return Reachability.isConnectedToNetwork() }
    
    var coreData: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Application Delegate wasn't found. Something went terribly wrong.")
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    var source: DataSource {
        let subscription = LedgitUser.current.subscription
        return subscription == .free ? .coreData : .firebase
    }
    
    deinit {
        trips.removeAllObservers()
    }
}

extension TripsManager {
    func fetchSampleTrip() {
        guard UserDefaults.standard.bool(forKey: Constants.userDefaultKeys.sampleTrip) == true else {
            Log.warning("Could not fetch sample trip key from user defaults")
            return
        }
        
        // NOTE: Not really core data, since you can't hard code data using core-data
        // I'll just add information here.
        let startDate = Date().prevMonth(at: .start)
        let endDate = Date().nextMonth(at: .start)
        let tripLength = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 61

        let tripDictionary: NSDictionary = ["key": "ledgit1234567890",
                                            "name": "Europe \(Date().year)",
                                            "startDate": "\(startDate.toString(style: .full))",
                                            "endDate": "\(endDate.toString(style: .full))",
                                            "currencies": ["USD", "MXN", "EUR"],
                                            "users": "",
                                            "owner": "Ledgit",
                                            "dailyBudget": Double(57),
                                            "length": tripLength,
                                            "budgetSelection": "Daily"]
        
        guard let sampleTrip = LedgitTrip(dict: tripDictionary) else {
            Log.warning("Was not able to create a sample trip when requested.")
            return
        }
        delegate?.retrievedSampleTrip(sampleTrip)
    }
    
    private func fetchFirebaseSampleTrip() {
        guard UserDefaults.standard.bool(forKey: Constants.userDefaultKeys.sampleTrip) == true else {
            Log.warning("Could not fetch sample trip key from user defaults")
            return
        }
        
        trips.child(Constants.projectID.sample).observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            guard let dict = snapshot.value as? NSDictionary else {
                Log.warning("Trip data that came back from firebase wasn't an NSDictionary")
                return
            }
            
            guard let trip = LedgitTrip(dict: dict) else {
                Log.warning("Could not generate trip from data")
                return
            }
            
            self.delegate?.retrievedSampleTrip(trip)
        })
    }

    func fetchTrip() {
        source == .firebase ? fetchFirebaseTrip() : fetchCoreDataTrip()
    }
    
    private func fetchFirebaseTrip() {
        guard let currentUserKey = auth.currentUser?.uid else {
            Log.warning("Firebase authentication current user had no uid")
            return
        }
        
        trips.queryOrdered(byChild: "owner").queryEqual(toValue: currentUserKey).observe(.childAdded, with: { (snapshot) in
            guard let snapshot = snapshot.value as? NSDictionary else {
                Log.warning("Trip data that came back from firebase wasn't an NSDictionary")
                return
            }
            
            guard let trip = LedgitTrip(dict: snapshot) else {
                Log.warning("Could not generate trip from data")
                return
            }
            
            self.delegate?.retrievedTrip(trip)
        })
    }
    
    private func fetchCoreDataTrip() {
        
    }
    
    func removeTrip(withKey key: String) {
        source == .firebase ? removeFirebaseTrip(key) : removeCoreDataTrip(key)
    }
    
    private func removeFirebaseTrip(_ key: String) {
        trips.child(key).removeValue()
    }
    
    private func removeCoreDataTrip(_ key: String) {
        
    }
    
    func createNew(trip: NSDictionary) {
        source == .firebase ? createFirebaseTrip(data: trip) : createCoreDataTrip(data: trip)
    }
    
    private func createFirebaseTrip(data: NSDictionary) {
        guard let key = data["key"] as? String else {
            Log.warning("Data to create trip did not contain key")
            return
        }
        
        trips.child(key).setValue(data)
        delegate?.addedTrip()
    }
    
    private func createCoreDataTrip(data: NSDictionary) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Trip", in: coreData) else {
            Log.warning("Could not create trip entity")
            return
        }
        
        let trip = NSManagedObject(entity: entity, insertInto: coreData)
        
        // 3
        guard
            let budget = data["dailyBudget"] as? String,
            let budgetSelection = data["budgetSelection"] as? String,
            let currencies = data["currencies"] as? [String],
            let startDate = data["startDate"] as? String,
            let endDate = data["startDate"] as? String,
            let key = data["key"] as? String,
            let length = data["length"] as? String,
            let name = data["name"] as? String,
            let owner = data["owner"] as? String,
            let users = data["users"] as? String
        else { return }
        
        trip.setValue(budgetSelection, forKey: "budgetSelection")
        trip.setValue(currencies, forKey: "currencies")
        trip.setValue(startDate, forKey: "startDate")
        trip.setValue(budget, forKey: "dailyBudget")
        trip.setValue(endDate, forKey: "startDate")
        trip.setValue(length, forKey: "length")
        trip.setValue(owner, forKey: "owner")
        trip.setValue(users, forKey: "users")
        trip.setValue(name, forKey: "name")
        trip.setValue(key, forKey: "key")
        
        do {
            try coreData.save()
            print(trip)
            self.delegate?.addedTrip()
            
        } catch let error as NSError {
            Log.warning("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func update(_ trip: LedgitTrip) {
        source == .firebase ? updateFirebase(trip) : updateCoreData(trip)
    }
    
    private func updateFirebase(_ trip: LedgitTrip) {
        let newData: NSDictionary = [
            "dailyBudget": trip.budget,
            "budgetSelection": trip.budgetSelection.rawValue,
            "currencies": trip.currencies.map{ $0.code },
            "endDate": trip.endDate,
            "startDate": trip.startDate,
            "length": trip.length,
            "key": trip.key,
            "name": trip.name,
            "owner": trip.owner,
            "users": trip.users
        ]
        
        trips.child(trip.key).setValue(newData) { (error, ref) in
            if let error = error {
                Log.error(error)
            }
        }
    }
    
    private func updateCoreData(_ trip: LedgitTrip) {
        
    }
}
