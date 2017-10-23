//
//  TripsPresenter.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 10/22/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation

protocol TripsPresenterDelegate: class {
    func retrievedSampleTrip()
    func retrievedTrip()
}

class TripsPresenter {
    weak var delegate: TripsPresenterDelegate?
    var manager: TripsManager!
    var trips:[Trip] = []
    
    init(manager: TripsManager) {
        self.manager = manager
        self.manager.delegate = self
    }
    
    func retrieveTrips() {
        manager.fetchSampleTrip()
        manager.fetchTrip()
    }
}

extension TripsPresenter: TripsManagerDelegate{
    func retrievedSampleTrip(_ trip: Trip) {
        trips.insert(trip, at: 0)
        delegate?.retrievedSampleTrip()
    }
    
    func retrievedTrip(_ trip: Trip) {
        trips.append(trip)
        delegate?.retrievedTrip()
    }
    
    func addedTrip() {
        
    }
    
    func removedTrip() {
        
    }
}
