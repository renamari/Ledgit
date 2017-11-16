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
    func errorUpdating(_ error: NSError)
    func modelUpdated()
    //func receivedEntry(entry: Entry)
}

enum FirebaseLoginResult {
    case success(User)
    case cancelled
    case failed(AuthErrorCode)
}

enum FirebaseNewAccountResult {
    case success
    case failed(AuthErrorCode)
}

enum SignoutResult {
    case success
    case failure(NSError)
}

class Service {
    static let shared = Service()
    
    var storage = Storage.storage().reference()
    var users = Database.database().reference().child("users")
    var trips = Database.database().reference().child("trips")
    var entries = Database.database().reference().child("entries")
    var auth = Auth.auth()
    var facebook = LoginManager()
    
    var delegate: serviceDelegate?
    
    var currentUser: User?
    
    var CURRENT_USER_REF:DatabaseReference{
        let userID = UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.uid) as! String
        let currentUser = users.child(userID)
        return currentUser
        
    }
    
    func isUserAuthenticated() -> Bool{
        guard Reachability.isConnectedToNetwork() == true else{
            return false
        }
        
        guard auth.currentUser != nil else{
            return false
        }
        
        guard UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.uid) != nil else{
            return false
        }
        
        return true
    }
    
    func authenticateUser(with email:String, password: String, completion: @escaping (FirebaseLoginResult) -> Void){
        auth.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error, let code = AuthErrorCode(rawValue: error._code){
                completion(.failed(code))
            }
            
            if let user = user {
                self.users.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let snapshot = snapshot.value as? NSDictionary{
                        UserDefaults.standard.set(user.uid, forKey: Constants.UserDefaultKeys.uid)
                        
                        completion(.success(User(dict: snapshot)))
                    }
                })
            }
        }
    }
    
    func authenticateUserWithFacebook(completion: @escaping (FirebaseLoginResult) -> Void){
        facebook.logIn(readPermissions: [ReadPermission.publicProfile,ReadPermission.email, ReadPermission.userFriends], viewController: nil) { (result) in
            switch result{
            case .failed(let error):
                
                if let code = AuthErrorCode(rawValue: error._code){
                    completion(.failed(code))
                }
                
            case .cancelled:
                completion(.cancelled)
                
            case .success( _,  _, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                
                self.auth.signIn(with: credential, completion: { (user, error) in
                    if let error = error, let code = AuthErrorCode(rawValue: error._code){
                        completion(.failed(code))
                    }
                    
                    if let user = user {
                        self.users.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                            if let snapshot = snapshot.value as? NSDictionary{
                                UserDefaults.standard.set(user.uid, forKey: Constants.UserDefaultKeys.uid)
                                
                                completion(.success(User(dict: snapshot)))
                            }
                        })
                    }
                })
            }
        }
    }
    
    func createUser(with email: String, password: String, completion: @escaping (FirebaseLoginResult) -> Void){
        auth.createUser(withEmail: email, password: password) { [unowned self] (user, error) in
            if let error = error, let code = AuthErrorCode(rawValue: error._code){
                completion(.failed(code))
            }
            
            if let user = user {
                let data: [String : Any] = [
                    "provider": user.providerID,
                    "email": email,
                    "uid": user.uid,
                    "profileImageURL": ""
                ]
                
                self.users.child(user.uid).setValue(data)
                UserDefaults.standard.set(user.uid, forKey: Constants.UserDefaultKeys.uid)
                UserDefaults.standard.set(true, forKey: Constants.UserDefaultKeys.sampleProject)
                
                let returnUser = User(dict: data as NSDictionary)
                completion(.success(returnUser))
            }
        }
    }
    
    func createUserWithFacebook(completion: @escaping (FirebaseLoginResult) -> Void){
        facebook.logIn(readPermissions: [ReadPermission.publicProfile,ReadPermission.email, ReadPermission.userFriends], viewController: nil) { [unowned self] (result) in
            switch result{
            case .failed(let error):
                
                if let code = AuthErrorCode(rawValue: error._code){
                    completion(.failed(code))
                }
                
            case .cancelled:
                completion(.cancelled)
                
            case .success( _,  _, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                
                self.auth.signIn(with: credential, completion: { (user, error) in
                    if let error = error, let code = AuthErrorCode(rawValue: error._code){
                        completion(.failed(code))
                    }
                    
                    if let user = user {
                        let data: [String : Any] = [
                            "provider": user.providerID,
                            "email": user.email!,
                            "name": user.displayName!,
                            "uid": user.uid,
                            "profileImageURL": (user.photoURL?.absoluteString)!
                        ]
                        
                        self.users.child(user.uid).setValue(data)
                        UserDefaults.standard.set(user.uid, forKey: Constants.UserDefaultKeys.uid)
                        UserDefaults.standard.set(true, forKey: Constants.UserDefaultKeys.sampleProject)
                        
                        let returnUser = User(dict: data as NSDictionary)
                        completion(.success(returnUser))
                    }
                })
            }
        }
    }
    
    func signout(completion: @escaping (SignoutResult) -> Void){
        do{
            try auth.signOut()
            
            UserDefaults.standard.set(nil, forKey: Constants.UserDefaultKeys.uid)
            
            completion(.success)
            
        }catch let error as NSError{
            
            completion(.failure(error))
        }
    }
    
    func fetchSampleTrip(completion: @escaping(Trip) -> Void){
        trips.child(Constants.ProjectID.sample).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? NSDictionary else{
                return
            }
            
            if let trip = Trip(dict: dict) {
                completion(trip)
            }
        })
    }
    
    func fetchTrip(completion: @escaping(Trip) -> Void){
        trips.queryOrdered(byChild: "owner").queryEqual(toValue: auth.currentUser!.uid).observe(.childAdded, with: { (snapshot) in
            
            if let snapshot = snapshot.value as? NSDictionary{
                if let trip = Trip(dict: snapshot) {
                    completion(trip)
                }
            }
        })
    }
    
    func removeTrip(withKey key: String, completion: @escaping () -> Void){
        trips.child(key).removeValue()
        completion()
    }
    
    func createNew(trip: NSDictionary){
        
        let key = trip["key"] as! String
        
        trips.child(key).setValue(trip)
    }
    
    func fetchEntry(inTrip trip: Trip, completion: @escaping(Entry) -> Void){
        entries.queryOrdered(byChild: "owningTrip").queryEqual(toValue: trip.key).observe(.childAdded, with: { (snapshot) in
            if let snapshot = snapshot.value as? NSDictionary{
                let entry = Entry(dict: snapshot)
                
                completion(entry)
            }
        })
    }
    
    func createNew(entry: NSDictionary) {
        let key = entry["key"] as! String
        
        entries.child(key).setValue(entry)
    }
    
    func fetchCategories(completion: @escaping ([String]) -> Void){
        let categories = self.currentUser!.categories
        
        completion(categories)
    }
    
    func addCategory(category: String, completion: @escaping (Bool) -> Void){
        self.currentUser!.categories.append(category)
        CURRENT_USER_REF.child("categories").setValue(self.currentUser!.categories)
        completion(true)
    }
    
    func updateCategory(category: String, with newCategory: String, completion:@escaping (Bool) -> Void){
        if let index = self.currentUser!.categories.index(where: {$0 == category}){
            self.currentUser!.categories[index] = newCategory
        }
        CURRENT_USER_REF.child("categories").setValue(self.currentUser!.categories)
        completion(true)
    }
    
    func updateUser(name: String, email:String, completion: @escaping(Bool) -> Void){
        
        let changeRequest = auth.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { (error) in
            //MARK:CHANGE FOR REALEASE
            if let error = error{
                print(error.localizedDescription)
            }
            self.currentUser!.name = name
            self.CURRENT_USER_REF.child("name").setValue(name)
        }
        
        auth.currentUser?.updateEmail(to: email, completion: { (error) in
            //MARK:-Change for release
            if let error = error{
                print(error.localizedDescription)
            }
            self.currentUser!.email = email
            self.CURRENT_USER_REF.child("email").setValue(email)
        })
        
        completion(true)
    }
    
    func removeCategory(with category: String, completion: @escaping (Bool) -> Void){
        if let index = currentUser!.categories.index(where: {$0 == category}){
            currentUser!.categories.remove(at: index)
            CURRENT_USER_REF.child("categories").setValue(currentUser!.categories)
            
            completion(true)
        }
    }
}
