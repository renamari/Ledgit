//
//  Service.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 10/18/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation
import Firebase
import FacebookCore
import FacebookLogin

protocol serviceDelegate {
    func errorUpdating(_ error: Error)
    func modelUpdated()
    //func receivedEntry(entry: Entry)
}

enum FirebaseLoginResult {
    case success(LedgitUser)
    case cancelled
    case failed(AuthErrorCode)
}

enum FirebaseNewAccountResult {
    case success
    case failed(AuthErrorCode)
}

enum SignoutResult {
    case success
    case failure(Error)
}

class Service {
    static let shared = Service()
    var storage = Storage.storage().reference()
    var users = Database.database().reference().child("users")
    var trips = Database.database().reference().child("trips")
    var entries = Database.database().reference().child("entries")
}
