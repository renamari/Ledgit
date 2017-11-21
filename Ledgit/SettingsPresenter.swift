//
//  SettingsPresenter.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 11/20/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation
import Firebase

class SettingsPresenter {
    let users = Database.database().reference().child("users")
    let auth = Auth.auth()
}

extension SettingsPresenter {
    func signout(completion: @escaping (SignoutResult) -> Void) {
        do {
            try auth.signOut()
            
            UserDefaults.standard.set(nil, forKey: Constants.UserDefaultKeys.uid)
            
            completion(.success)
            
        } catch let error as NSError {
            
            completion(.failure(error))
        }
    }
    
    func fetchCategories(completion: @escaping ([String]) -> Void){
        guard let categories = LedgitUser.current?.categories else { return }
        
        completion(categories)
    }
    
    func addCategory(category: String, completion: @escaping (Bool) -> Void){
        guard var currentUser = LedgitUser.current else { return }
        currentUser.categories.append(category)
        users.child(currentUser.key).setValue(currentUser.categories)
        completion(true)
    }
    
    func updateCategory(category: String, with newCategory: String, completion:@escaping (Bool) -> Void){
        guard var currentUser = LedgitUser.current else { return }
        if let index = currentUser.categories.index(where: {$0 == category}){
            currentUser.categories[index] = newCategory
        }
        users.child(currentUser.key).child("categories").setValue(currentUser.categories)
        completion(true)
    }
}
