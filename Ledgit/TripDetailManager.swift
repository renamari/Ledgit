//
//  TripDetailManager.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/26/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation
import Firebase

protocol TripDetailManagerDelegate: class {
    func retrievedEntry(_ entry: LedgitEntry)
}

class TripDetailManager {
    weak var delegate: TripDetailManagerDelegate?
    let auth = Auth.auth()
    let trips = Database.database().reference().child("trips")
    let entries = Database.database().reference().child("entries")
    var isConnected: Bool { return Reachability.isConnectedToNetwork() }
}

extension TripDetailManager {
    func fetchEntry(forTrip trip: LedgitTrip) {
        entries.queryOrdered(byChild: "owningTrip").queryEqual(toValue: trip.key).observe(.childAdded, with: { snapshot in
            guard let snapshot = snapshot.value as? NSDictionary else { return }
            guard let entry = LedgitEntry(dict: snapshot) else { return }
            self.delegate?.retrievedEntry(entry)
        })
    }
    
    func create(entry: NSDictionary) {
        guard let key = entry["key"] as? String else { return }
        entries.child(key).setValue(entry)
    }
}
