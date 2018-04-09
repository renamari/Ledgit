//
//  SettingsManager.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/21/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol SettingsManagerDelegate: class {
    func signedout(_ result: SignoutResult)
    func retrieved(_ categories: [String])
    func added(_ category: String)
    func updated(_ categories: [String])
}

class SettingsManager {
    weak var delegate: SettingsManagerDelegate?
    let users = Database.database().reference().child("users")
    let auth = Auth.auth()
    
    var source: DataSource {
        let subscription = LedgitUser.current.subscription
        return subscription == .free ? .coreData : .firebase
    }
    var coreData: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Application Delegate wasn't found. Something went terribly wrong.")
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    var user: NSManagedObject? {
        guard let uid = UserDefaults.standard.value(forKey: Constants.userDefaultKeys.uid) as? String else {
            return nil
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.ledgitEntity.user)
        request.predicate = NSPredicate(format: "\(Constants.userDefaultKeys.uid) == %@", uid)
        request.fetchLimit = 1
        
        guard let users = try? coreData.fetch(request) else {
            return nil
        }
        
        guard let user = users.first as? NSManagedObject else {
            return nil
        }
        
        return user
    }
    /*
 
     guard let uid = UserDefaults.standard.value(forKey: Constants.userDefaultKeys.uid) as? String else {
     navigateToMain()
     return true
     }
     
     // If uid exist, search for a core data user
     let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.ledgitEntity.user)
     request.predicate = NSPredicate(format: "\(Constants.userDefaultKeys.uid) == %@", uid)
     request.fetchLimit = 1
     
     do {
     let users = try persistentContainer.viewContext.fetch(request)
     
     guard let user = users.first as? NSManagedObject else {
     navigateToMain()
     return true
     }
     
     let data: NSDictionary = [
     "uid": uid,
     "key": user.value(forKey: "key") as Any,
     "name": user.value(forKey: "name") as Any,
     "email": user.value(forKey: "email") as Any,
     "provider": user.value(forKey: "provider") as Any,
     "categories": user.value(forKey: "categories") as Any,
     "subscription": user.value(forKey: "subscription") as Any,
     "homeCurrency": user.value(forKey: "homeCurrency") as Any
     ]
     
     LedgitUser.current = LedgitUser(dict: data)
     navigateToTrips()
     return true
     
     } catch {
     
     Log.critical("Something is wrong. There is a user default uid value, but it didn't get the core data member")
     navigateToMain()
     return true
     }*/
}

extension SettingsManager {
    func signout() {
        do {
            try auth.signOut()
            
            UserDefaults.standard.set(nil, forKey: Constants.userDefaultKeys.uid)
            
            delegate?.signedout(.success)
    
        } catch let error {
            delegate?.signedout(.failure(error))
        }
    }
    
    func fetchCategories() {
        delegate?.retrieved(LedgitUser.current.categories)
    }
    
    func add(category: String){
        // Save categories to core data user
    
        do {
            LedgitUser.current.categories.append(category)
            
            user?.setValue(LedgitUser.current.categories, forKey: LedgitUser.Keys.categories)
            
            try coreData.save()
            
            // Save categories to firebase
            users.child(LedgitUser.current.key).child(LedgitUser.Keys.categories).setValue(LedgitUser.current.categories)
            
            delegate?.added(category)
            
        } catch let error as NSError {
            Log.critical("Problem saving categories to user \(error)")
        }
    }
    
    func updateCategory(to newCategory: String, from category: String) {
        let key = LedgitUser.current.key
        var categories = LedgitUser.current.categories
        
        guard let index = categories.index(of: category) else { return }
        
        categories[index] = newCategory
        
        do {
            user?.setValue(categories, forKey: LedgitUser.Keys.categories)
            
            users.child(key).child(LedgitUser.Keys.categories).setValue(categories)
            
            try coreData.save()
            
            LedgitUser.current.categories = categories
            
            delegate?.updated(categories)
            
        } catch let error as NSError {
            Log.error(error)
            
        }
    }
    
    func remove(_ category: String) {
        guard let index = LedgitUser.current.categories.index(of: category) else { return }
        
        
        do {
            user?.setValue(LedgitUser.current.categories, forKey: LedgitUser.Keys.categories)
            
            users.child(LedgitUser.current.key).child("categories").setValue(LedgitUser.current.categories)
            
            try coreData.save()
            
            LedgitUser.current.categories.remove(at: index)
            
        } catch let error as NSError {
            Log.error(error)
            
        }
    }
    
    func updateUser(name: String, email: String) {
        user?.setValue(email, forKey: LedgitUser.Keys.email)
        user?.setValue(name, forKey: LedgitUser.Keys.name)
        
        do {
            try coreData.save()
            LedgitUser.current.name = name
            LedgitUser.current.email = email
            
        } catch let error as NSError {
            Log.error(error)
        }
        
        let changeRequest = auth.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { (error) in
            //MARK:CHANGE FOR REALEASE
            if let error = error {
                Log.error(error)
            }
            
            let key = LedgitUser.current.key
            LedgitUser.current.name = name
            self.users.child(key).child("name").setValue(name)
        }
        
        auth.currentUser?.updateEmail(to: email, completion: { (error) in
            //MARK:-Change for release
            if let error = error {
                Log.error(error)
            }
            
            let key = LedgitUser.current.key
            LedgitUser.current.email = email
            self.users.child(key).child("email").setValue(email)
        })
    }
}
