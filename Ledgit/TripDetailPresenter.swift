//
//  TripDetailPresenter.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/26/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation
import Firebase

protocol TripDetailPresenterDelegate: class {
    func retrieveEntry()
}

class TripDetailPresenter {
    weak var delegate: TripDetailPresenterDelegate?
    var manager: TripDetailManager!
    var trip: LedgitTrip!
    var entries: [LedgitEntry] = []
    var costToday: Double = 0
    var totalCost: Double = 0
    var averageCost: Double = 0
    var dates: [Date] = []
    
    init(manager: TripDetailManager) {
        self.manager = manager
        self.manager.delegate = self
    }
    
    func attachTrip(_ trip: LedgitTrip) {
        self.trip = trip
    }
    
    func create(entry: NSDictionary) {
        manager.create(entry: entry)
    }
    
    func fetchEntries() {
        manager.fetchEntry(forTrip: trip)
    }
}

extension TripDetailPresenter: TripDetailManagerDelegate {
    func retrievedEntry(_ entry: LedgitEntry) {
        if !dates.contains(entry.date) {
            dates.append(entry.date)
        }
    
        if entry.date.isToday {
            costToday += entry.convertedCost
        }
        
        totalCost += entry.convertedCost
        averageCost = totalCost / Double(dates.count)
        entries.append(entry)
        delegate?.retrieveEntry()
    }
}
