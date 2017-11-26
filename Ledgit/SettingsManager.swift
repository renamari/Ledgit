//
//  SettingsManager.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/21/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation
import Firebase

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
}

extension SettingsManager {
    func signout() {
        do {
            try auth.signOut()
            
            UserDefaults.standard.set(nil, forKey: Constants.UserDefaultKeys.uid)
            
            delegate?.signedout(.success)
    
        } catch let error {
            delegate?.signedout(.failure(error))
        }
    }
    
    func fetchCategories() {
        guard let categories = LedgitUser.current?.categories else {
            delegate?.retrieved([])
            return
        }
        delegate?.retrieved(categories)
    }
    
    func add(category: String){
        guard var currentUser = LedgitUser.current else { return }
        currentUser.categories.append(category)
        LedgitUser.current?.categories.append(category)
        users.child(currentUser.key).child("categories").setValue(currentUser.categories)
        delegate?.added(category)
    }
    
    func updateCategory(to newCategory: String, from category: String) {
        guard var categories = LedgitUser.current?.categories, let key = LedgitUser.current?.key else { return }
        guard let index = categories.index(where: {$0 == category}) else { return }
        
        categories[index] = newCategory
        users.child(key).child("categories").setValue(categories)
        LedgitUser.current?.categories = categories
        delegate?.updated(categories)
    }
    
    func remove(_ category: String) {
        guard var currentUser = LedgitUser.current else { return }
        guard let index = currentUser.categories.index(where: {$0 == category}) else { return }
        
        let categories = currentUser.categories.remove(at: index)
        users.child(currentUser.key).child("categories").setValue(categories)
    }
    
    func updateUser(name: String, email: String) {
        let changeRequest = auth.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { (error) in
            //MARK:CHANGE FOR REALEASE
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let key = LedgitUser.current?.key else { return }
            LedgitUser.current?.name = name
            self.users.child(key).child("name").setValue(name)
        }
        
        auth.currentUser?.updateEmail(to: email, completion: { (error) in
            //MARK:-Change for release
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let key = LedgitUser.current?.key else { return }
            LedgitUser.current?.email = email
            self.users.child(key).child("email").setValue(email)
        })
    }
}
