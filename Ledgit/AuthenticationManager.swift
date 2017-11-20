//
//  AuthenticationManager.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 10/19/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation
import Firebase
import FacebookCore
import FacebookLogin

typealias ErrorDictionary = [String:String]

protocol AuthenticationManagerDelegate: class {
    // MANAGER -> INTERACTOR
    func userAuthenticated(_ user: LedgitUser)
    func authenticationError(dict: ErrorDictionary)
}

class AuthenticationManager {
    static let shared = AuthenticationManager()
    weak var delegate: AuthenticationManagerDelegate?
    let users = Database.database().reference().child("users")
    let facebook = LoginManager()
    let auth = Auth.auth()
    var isConnected: Bool { return Reachability.isConnectedToNetwork() }
}

extension AuthenticationManager {
    
    func performFirebaseSignUp(with email: String, password: String) {
        
        guard isConnected else {
            self.delegate?.authenticationError(dict: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        guard !email.isEmpty, !password.isEmpty else {
            self.delegate?.authenticationError(dict: Constants.ClientErrorMessages.emptyTextFields)
            return
        }
        
        auth.createUser(withEmail: email, password: password) { [unowned self] (user, error) in
            if let error = error, let code = AuthErrorCode(rawValue: error._code){
                self.delegate?.authenticationError(dict: self.handleError(with: code))
            }
            
            guard let user = user else {
                self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.general)
                return
            }
            
            let data: NSDictionary = [
                "provider": user.providerID,
                "email": email,
                "uid": user.uid,
                "profileImageURL": ""
            ]
            
            self.users.child(user.uid).setValue(data)
            UserDefaults.standard.set(user.uid, forKey: Constants.UserDefaultKeys.uid)
            UserDefaults.standard.set(true, forKey: Constants.UserDefaultKeys.sampleProject)
            guard let authenticatedUser = LedgitUser(dict: data) else { return }
            LedgitUser.current = authenticatedUser
            self.delegate?.userAuthenticated(authenticatedUser)
        }
    }
    
    func performFirebaseSignIn(with email:String, password: String) {
        guard isConnected else {
            self.delegate?.authenticationError(dict: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        guard !email.isEmpty, !password.isEmpty else {
            self.delegate?.authenticationError(dict: Constants.ClientErrorMessages.emptyTextFields)
            return
        }
        
        auth.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error, let code = AuthErrorCode(rawValue: error._code){
                self.delegate?.authenticationError(dict: self.handleError(with: code))
            }
            
            guard let user = user else {
                self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.general)
                return
            }
            
            self.users.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshot = snapshot.value as? NSDictionary else {
                    self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.general)
                    return
                }
                
                UserDefaults.standard.set(user.uid, forKey: Constants.UserDefaultKeys.uid)
                guard let authenticatedUser = LedgitUser(dict: snapshot) else { return }
                LedgitUser.current = authenticatedUser
                self.delegate?.userAuthenticated(authenticatedUser)
            })
        }
    }
    
    func peformFacebookSignUp() {
        guard isConnected else {
            self.delegate?.authenticationError(dict: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        facebook.logIn(readPermissions: [ReadPermission.publicProfile,ReadPermission.email, ReadPermission.userFriends], viewController: nil) { [unowned self] (result) in
            switch result{
            case .failed(let error):
                
                if let code = AuthErrorCode(rawValue: error._code){
                    self.delegate?.authenticationError(dict: self.handleError(with: code))
                }
                
            case .cancelled:
                self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.general)
                
            case .success( _,  _, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                
                self.auth.signIn(with: credential, completion: { (user, error) in
                    if let error = error, let code = AuthErrorCode(rawValue: error._code){
                        self.delegate?.authenticationError(dict: self.handleError(with: code))
                    }
                    
                    guard let user = user else {
                        self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.general)
                        return
                    }
                    
                    let data: NSDictionary = [
                        "provider": user.providerID,
                        "email": user.email!,
                        "name": user.displayName!,
                        "uid": user.uid,
                        "profileImageURL": (user.photoURL?.absoluteString)!
                    ]
                    
                    self.users.child(user.uid).setValue(data)
                    UserDefaults.standard.set(user.uid, forKey: Constants.UserDefaultKeys.uid)
                    UserDefaults.standard.set(true, forKey: Constants.UserDefaultKeys.sampleProject)
                    guard let authenticatedUser = LedgitUser(dict: data) else { return }
                    LedgitUser.current = authenticatedUser
                    self.delegate?.userAuthenticated(authenticatedUser)
                })
            }
        }
    }
    
    func performFacebookSignIn() {
        guard isConnected else {
            self.delegate?.authenticationError(dict: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        facebook.logIn(readPermissions: [.publicProfile, .email, .userFriends], viewController: nil) { [unowned self] (result) in
            switch result {
            case .failed(let error):
                
                guard let code = AuthErrorCode(rawValue: error._code) else { return }
                self.delegate?.authenticationError(dict: self.handleError(with: code))
            
            case .cancelled:
                self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.cancelled)
                
            case .success( _,  _, let result):
                let credential = FacebookAuthProvider.credential(withAccessToken: result.authenticationToken)
                
                self.auth.signIn(with: credential, completion: { (user, error) in
                    if let error = error, let code = AuthErrorCode(rawValue: error._code) {
                        self.delegate?.authenticationError(dict: self.handleError(with: code))
                    }
                    
                    guard let user = user else {
                        self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.general)
                        return
                    }
                    
                    self.users.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let snapshot = snapshot.value as? NSDictionary else { return }
                        guard let authenticatedUser = LedgitUser(dict: snapshot) else { return }
                        UserDefaults.standard.set(user.uid, forKey: Constants.UserDefaultKeys.uid)
                        LedgitUser.current = authenticatedUser
                        self.delegate?.userAuthenticated(authenticatedUser)
                    })
                })
            }
        }
    }
    
    func handleError(with code: AuthErrorCode) -> ErrorDictionary {
        switch code {
            
        case .emailAlreadyInUse:
            return Constants.AuthErrorMessages.emailAlreadyInUse
            
        case .userDisabled:
            return Constants.AuthErrorMessages.userDisabled
            
        case .invalidEmail:
            return Constants.AuthErrorMessages.invalidEmail
            
        case .wrongPassword:
            return Constants.AuthErrorMessages.wrongPassword
            
        case .userNotFound:
            return Constants.AuthErrorMessages.userNotFound
            
        default:
            return Constants.AuthErrorMessages.general
        }
    }
}

extension AuthenticationManager {
    func isAuthenticated() -> Bool{
        guard auth.currentUser != nil else{ return false }
        
        guard UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.uid) != nil else { return false }
        
        return true
    }
    
    func updateUser(name: String, email:String, completion: @escaping(Bool) -> Void){
        
        let changeRequest = auth.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { (error) in
            //MARK:CHANGE FOR REALEASE
            if let error = error {
                print(error.localizedDescription)
            }
            
            if var user = LedgitUser.current  {
                user.name = name
                self.users.child(user.key).child("name").setValue(name)
            }
        }
        
        auth.currentUser?.updateEmail(to: email, completion: { (error) in
            //MARK:-Change for release
            if let error = error{
                print(error.localizedDescription)
            }
            
            if var user = LedgitUser.current  {
                user.email = email
                self.users.child(user.key).child("email").setValue(email)
            }
        })
        
        completion(true)
    }
    
    func signout(completion: @escaping (SignoutResult) -> Void){
        do {
            try auth.signOut()
            
            UserDefaults.standard.set(nil, forKey: Constants.UserDefaultKeys.uid)
            
            LedgitUser.current = nil
            
            completion(.success)
            
        } catch let error as NSError {
            
            completion(.failure(error))
        }
    }
}
