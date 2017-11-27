//
//  TripsManager.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 10/22/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation
import Firebase

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
}

extension TripsManager {
    func fetchSampleTrip() {
        guard (UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.sampleProject) as? Bool) == true else { return }
        
        trips.child(Constants.ProjectID.sample).observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            guard let dict = snapshot.value as? NSDictionary else { return }
            
            if let trip = LedgitTrip(dict: dict) {
                self.delegate?.retrievedSampleTrip(trip)
            }
        })
    }
    
    func fetchTrip(){
        guard let currentUserKey = auth.currentUser?.uid else { return }
        
        trips.queryOrdered(byChild: "owner").queryEqual(toValue: currentUserKey).observe(.childAdded, with: { (snapshot) in
            guard let snapshot = snapshot.value as? NSDictionary else { return }
            
            if let trip = LedgitTrip(dict: snapshot) {
                self.delegate?.retrievedTrip(trip)
            }
        })
    }
    
    func removeTrip(withKey key: String){
        trips.child(key).removeValue()
    }
    
    func createNew(trip: NSDictionary){
        guard let key = trip["key"] as? String else { return }
        
        trips.child(key).setValue(trip)
        delegate?.addedTrip()
    }
    
    func update(_ trip: LedgitTrip) {
        
        let newData: NSDictionary = [
            "budget": trip.budget,
            "budgetSelection": trip.budgetSelection.rawValue,
            "currencies": trip.currencies.map{ $0.code },
            "endDate": trip.endDate,
            "startDate": trip.startDate,
            "key": trip.key,
            "name": trip.name,
            "owner": trip.owner,
            "users": trip.users
        ]
        trips.child(trip.key).setValue(newData)
    }
}
