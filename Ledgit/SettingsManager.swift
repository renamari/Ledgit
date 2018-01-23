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
        LedgitUser.current.categories.append(category)
        users.child(LedgitUser.current.key).child("categories").setValue(LedgitUser.current.categories)
        delegate?.added(category)
    }
    
    func updateCategory(to newCategory: String, from category: String) {
        let key = LedgitUser.current.key
        var categories = LedgitUser.current.categories
        if let index = categories.index(of: category) {
            categories[index] = newCategory
            users.child(key).child("categories").setValue(categories)
            LedgitUser.current.categories = categories
            delegate?.updated(categories)
        }
    }
    
    func remove(_ category: String) {
        guard let index = LedgitUser.current.categories.index(of: category) else { return }
        LedgitUser.current.categories.remove(at: index)
        users.child(LedgitUser.current.key).child("categories").setValue(LedgitUser.current.categories)
    }
    
    func updateUser(name: String, email: String) {
        let changeRequest = auth.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { (error) in
            //MARK:CHANGE FOR REALEASE
            if let error = error {
                print(error.localizedDescription)
            }
            
            let key = LedgitUser.current.key
            LedgitUser.current.name = name
            self.users.child(key).child("name").setValue(name)
        }
        
        auth.currentUser?.updateEmail(to: email, completion: { (error) in
            //MARK:-Change for release
            if let error = error {
                print(error.localizedDescription)
            }
            
            let key = LedgitUser.current.key
            LedgitUser.current.email = email
            self.users.child(key).child("email").setValue(email)
        })
    }
}