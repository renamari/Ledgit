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
    func retrievedSampleTrip(_ trip: Trip)
    func retrievedTrip(_ trip: Trip)
    func addedTrip()
    func removedTrip()
}

class TripsManager {
    weak var delegate: TripsManagerDelegate?
    let trips = Database.database().reference().child("trips")
    
    var isConnected: Bool { return Reachability.isConnectedToNetwork() }
}

extension TripsManager {
    func fetchSampleTrip() {
        guard (UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.sampleProject) as? Bool) == true else { return }
        
        trips.child(Constants.ProjectID.sample).observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            guard let dict = snapshot.value as? NSDictionary else { return }
            
            let trip = Trip(dict: dict)
            self.delegate?.retrievedSampleTrip(trip)
        })
    }
    
    func fetchTrip(){
        guard let currentUser = Service.shared.currentUser else { return }
        
        trips.queryOrdered(byChild: "owner").queryEqual(toValue: currentUser.key).observe(.childAdded, with: { (snapshot) in
            if let snapshot = snapshot.value as? NSDictionary{
                let trip = Trip(dict: snapshot)
                
                self.delegate?.retrievedTrip(trip)
            }
        })
    }
    
    func removeTrip(withKey key: String){
        trips.child(key).removeValue()
        self.delegate?.removedTrip()
    }
    
    func createNew(trip: NSDictionary){
        let key = trip["key"] as! String
        
        trips.child(key).setValue(trip)
        self.delegate?.addedTrip()
    }
}
