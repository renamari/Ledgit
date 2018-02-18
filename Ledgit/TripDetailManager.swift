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
    func removedEntry(_ entry: LedgitEntry)
    func updatedEntry(_ key: String)
}

class TripDetailManager {
    weak var delegate: TripDetailManagerDelegate?
    let auth = Auth.auth()
    let trips = Database.database().reference().child("trips")
    let entries = Database.database().reference().child("entries")
    
    #if DEBUG
    var isConnected: Bool = false
    #else
    var isConnected: Bool {
        get { return Reachability.isConnectedToNetwork() }
    }
    #endif
    
    init() {
    #if DEBUG
        isConnected = Reachability.isConnectedToNetwork()
    #endif
    }
    
    deinit {
        entries.removeAllObservers()
    }
}

extension TripDetailManager {
    func fetchEntry(forTrip trip: LedgitTrip) {
        
        entries.queryOrdered(byChild: "owningTrip").queryEqual(toValue: trip.key).observe(.childChanged, with: { snapshot in
            guard let snapshot = snapshot.value as? NSDictionary else { return }
            guard let entry = LedgitEntry(dict: snapshot) else { return }
            self.delegate?.retrievedEntry(entry)
        })
    
        entries.queryOrdered(byChild: "owningTrip").queryEqual(toValue: trip.key).observe(.childAdded, with: { snapshot in
            guard let snapshot = snapshot.value as? NSDictionary else { return }
            guard let entry = LedgitEntry(dict: snapshot) else { return }
            self.delegate?.retrievedEntry(entry)
        })
    }
    
    func create(entry: NSDictionary) {
        guard let entryKey = entry["key"] as? String else { return }
        guard let tripKey = entry["owningTrip"] as? String else { return }
        entries.child(entryKey).setValue(entry)
        trips.child(tripKey).updateChildValues(["entries": entryKey])
    }
    
    func remove(_ entry: LedgitEntry) {
        let key = entry.key
        
        entries.child(key).removeValue { (error, ref) in
            guard error == nil else { return }
            self.delegate?.removedEntry(entry)
        }
    }
    
    func update(_ entryData: NSDictionary) {
        guard let entryKey = entryData["key"] as? String else { return }
        entries.child(entryKey).setValue(entryData)
        delegate?.updatedEntry(entryKey)
    }
}
