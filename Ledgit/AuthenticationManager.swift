//
//  AuthenticationManager.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 10/19/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation
import Firebase
import CoreData

typealias ErrorDictionary = [String:String]

protocol AuthenticationManagerDelegate: class {
    func userAuthenticated(_ user: LedgitUser)
    func authenticationError(_ error: LedgitError)
}

class AuthenticationManager {
    weak var delegate: AuthenticationManagerDelegate?
    var users: DatabaseReference { return Database.database().reference().child("users") }
    var auth: Auth { return Auth.auth() }
    var coreData: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Application Delegate wasn't found. Something went terribly wrong.")
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
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
}

extension AuthenticationManager {
    func performCoreDataSignUp() {
        guard let entity = NSEntityDescription.entity(forEntityName: Constants.ledgitEntity.user, in: coreData) else {
            Log.warning("Could not create user entity")
            return
        }
        
        let user = NSManagedObject(entity: entity, insertInto: coreData)
        let name = ""
        let email = ""
        let key = UUID().uuidString.lowercased()
        let provider = "Ledgit"
        let subscription = "Free"
        let homeCurrency = "USD"
        let categories = ["Transportation", "Food", "Lodging", "Entertainment", "Emergency", "Miscellaneous"]
        
        let data: NSDictionary = [
            LedgitUser.Keys.key: key,
            LedgitUser.Keys.email: email,
            LedgitUser.Keys.provider: provider,
            LedgitUser.Keys.categories: categories,
            LedgitUser.Keys.subscription: subscription,
            LedgitUser.Keys.homeCurrency: homeCurrency
        ]
        
        user.setValue(email, forKey: LedgitUser.Keys.email)
        user.setValue(name, forKey: LedgitUser.Keys.name)
        user.setValue(provider, forKey: LedgitUser.Keys.provider)
        user.setValue(subscription, forKey: LedgitUser.Keys.subscription)
        user.setValue(homeCurrency, forKey: LedgitUser.Keys.homeCurrency)
        user.setValue(key, forKey: LedgitUser.Keys.key)
        user.setValue(categories, forKey: LedgitUser.Keys.categories)
        
        do {
            try coreData.save()
            UserDefaults.standard.set(key, forKey: Constants.userDefaultKeys.uid)
            UserDefaults.standard.set(true, forKey: Constants.userDefaultKeys.sampleTrip)
            
            let ledgitUser = LedgitUser(dict: data)
            self.delegate?.userAuthenticated(ledgitUser)
            
        } catch let error as NSError {
            Log.warning("Could not add user object to core data. \(error), \(error.userInfo)")
            self.delegate?.authenticationError(.coreDataFault)
        }
    }
    
    func performFirebaseSignUp(with email: String, password: String) {
        
        guard isConnected else {
            self.delegate?.authenticationError(.noNetworkConnection)
            return
        }
        
        guard !email.isEmpty, !password.isEmpty else {
            self.delegate?.authenticationError(.emptyTextFields)
            return
        }
        
        auth.createUser(withEmail: email, password: password) { [unowned self] (result, error) in
            if let error = error, let code = AuthErrorCode(rawValue: error._code){
                self.delegate?.authenticationError(self.handleError(with: code))
            }
            
            guard let user = result?.user else {
                self.delegate?.authenticationError(.general)
                return
            }
            
            let data: NSDictionary = [
                LedgitUser.Keys.provider: user.providerID,
                LedgitUser.Keys.email: email,
                LedgitUser.Keys.key: user.uid
            ]
            
            self.users.child(user.uid).setValue(data)
            UserDefaults.standard.set(user.uid, forKey: Constants.userDefaultKeys.uid)
            UserDefaults.standard.set(true, forKey: Constants.userDefaultKeys.sampleTrip)
            let authenticatedUser = LedgitUser(dict: data)
            self.delegate?.userAuthenticated(authenticatedUser)
        }
    }
    
    func performFirebaseSignIn(with email:String, password: String) {
        guard isConnected else {
            self.delegate?.authenticationError(.noNetworkConnection)
            return
        }
        
        guard !email.isEmpty, !password.isEmpty else {
            self.delegate?.authenticationError(.emptyTextFields)
            return
        }
        
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error, let code = AuthErrorCode(rawValue: error._code){
                self.delegate?.authenticationError(self.handleError(with: code))
            }
            
            guard let user = result?.user else {
                self.delegate?.authenticationError(.general)
                return
            }
            
            self.users.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshot = snapshot.value as? NSDictionary else {
                    self.delegate?.authenticationError(.general)
                    return
                }
                
                UserDefaults.standard.set(user.uid, forKey: Constants.userDefaultKeys.uid)
                let authenticatedUser = LedgitUser(dict: snapshot)
                self.delegate?.userAuthenticated(authenticatedUser)
            })
        }
    }
    
    func handleError(with code: AuthErrorCode) -> LedgitError {
        switch code {
            
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
            
        case .userDisabled:
            return .userDisabled
            
        case .invalidEmail:
            return .invalidEmail
            
        case .wrongPassword:
            return .wrongPassword
            
        case .userNotFound:
            return .userNotFound
            
        default:
            return .general
        }
    }
}
