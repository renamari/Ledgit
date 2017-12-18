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
            self.delegate?.authenticationError(dict: Constants.clientErrorMessages.noNetworkConnection)
            return
        }
        
        guard !email.isEmpty, !password.isEmpty else {
            self.delegate?.authenticationError(dict: Constants.clientErrorMessages.emptyTextFields)
            return
        }
        
        auth.createUser(withEmail: email, password: password) { [unowned self] (user, error) in
            if let error = error, let code = AuthErrorCode(rawValue: error._code){
                self.delegate?.authenticationError(dict: self.handleError(with: code))
            }
            
            guard let user = user else {
                self.delegate?.authenticationError(dict: Constants.authErrorMessages.general)
                return
            }
            
            let data: NSDictionary = [
                "provider": user.providerID,
                "email": email,
                "uid": user.uid,
                "profileImageURL": ""
            ]
            
            self.users.child(user.uid).setValue(data)
            UserDefaults.standard.set(user.uid, forKey: Constants.userDefaultKeys.uid)
            UserDefaults.standard.set(true, forKey: Constants.userDefaultKeys.sampleProject)
            guard let authenticatedUser = LedgitUser(dict: data) else { return }
            LedgitUser.current = authenticatedUser
            self.delegate?.userAuthenticated(authenticatedUser)
        }
    }
    
    func performFirebaseSignIn(with email:String, password: String) {
        guard isConnected else {
            self.delegate?.authenticationError(dict: Constants.clientErrorMessages.noNetworkConnection)
            return
        }
        
        guard !email.isEmpty, !password.isEmpty else {
            self.delegate?.authenticationError(dict: Constants.clientErrorMessages.emptyTextFields)
            return
        }
        
        auth.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error, let code = AuthErrorCode(rawValue: error._code){
                self.delegate?.authenticationError(dict: self.handleError(with: code))
            }
            
            guard let user = user else {
                self.delegate?.authenticationError(dict: Constants.authErrorMessages.general)
                return
            }
            
            self.users.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshot = snapshot.value as? NSDictionary else {
                    self.delegate?.authenticationError(dict: Constants.authErrorMessages.general)
                    return
                }
                
                UserDefaults.standard.set(user.uid, forKey: Constants.userDefaultKeys.uid)
                guard let authenticatedUser = LedgitUser(dict: snapshot) else { return }
                LedgitUser.current = authenticatedUser
                self.delegate?.userAuthenticated(authenticatedUser)
            })
        }
    }
    
    func peformFacebookSignUp() {
        guard isConnected else {
            self.delegate?.authenticationError(dict: Constants.clientErrorMessages.noNetworkConnection)
            return
        }
        
        facebook.logIn(readPermissions: [ReadPermission.publicProfile,ReadPermission.email, ReadPermission.userFriends], viewController: nil) { [unowned self] (result) in
            switch result{
            case .failed(let error):
                
                if let code = AuthErrorCode(rawValue: error._code){
                    self.delegate?.authenticationError(dict: self.handleError(with: code))
                }
                
            case .cancelled:
                self.delegate?.authenticationError(dict: Constants.authErrorMessages.general)
                
            case .success( _,  _, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                
                self.auth.signIn(with: credential, completion: { (user, error) in
                    if let error = error, let code = AuthErrorCode(rawValue: error._code){
                        self.delegate?.authenticationError(dict: self.handleError(with: code))
                    }
                    
                    guard let user = user else {
                        self.delegate?.authenticationError(dict: Constants.authErrorMessages.general)
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
                    UserDefaults.standard.set(user.uid, forKey: Constants.userDefaultKeys.uid)
                    UserDefaults.standard.set(true, forKey: Constants.userDefaultKeys.sampleProject)
                    guard let authenticatedUser = LedgitUser(dict: data) else { return }
                    LedgitUser.current = authenticatedUser
                    self.delegate?.userAuthenticated(authenticatedUser)
                })
            }
        }
    }
    
    func performFacebookSignIn() {
        guard isConnected else {
            self.delegate?.authenticationError(dict: Constants.clientErrorMessages.noNetworkConnection)
            return
        }
        
        facebook.logIn(readPermissions: [.publicProfile, .email, .userFriends], viewController: nil) { [unowned self] (result) in
            switch result {
            case .failed(let error):
                
                guard let code = AuthErrorCode(rawValue: error._code) else { return }
                self.delegate?.authenticationError(dict: self.handleError(with: code))
            
            case .cancelled:
                self.delegate?.authenticationError(dict: Constants.authErrorMessages.cancelled)
                
            case .success( _,  _, let result):
                let credential = FacebookAuthProvider.credential(withAccessToken: result.authenticationToken)
                
                self.auth.signIn(with: credential, completion: { (user, error) in
                    if let error = error, let code = AuthErrorCode(rawValue: error._code) {
                        self.delegate?.authenticationError(dict: self.handleError(with: code))
                    }
                    
                    guard let user = user else {
                        self.delegate?.authenticationError(dict: Constants.authErrorMessages.general)
                        return
                    }
                    
                    self.users.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let snapshot = snapshot.value as? NSDictionary else { return }
                        guard let authenticatedUser = LedgitUser(dict: snapshot) else { return }
                        UserDefaults.standard.set(user.uid, forKey: Constants.userDefaultKeys.uid)
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
            return Constants.authErrorMessages.emailAlreadyInUse
            
        case .userDisabled:
            return Constants.authErrorMessages.userDisabled
            
        case .invalidEmail:
            return Constants.authErrorMessages.invalidEmail
            
        case .wrongPassword:
            return Constants.authErrorMessages.wrongPassword
            
        case .userNotFound:
            return Constants.authErrorMessages.userNotFound
            
        default:
            return Constants.authErrorMessages.general
        }
    }
}

extension AuthenticationManager {
    func isAuthenticated() -> Bool{
        guard auth.currentUser != nil else{ return false }
        
        guard UserDefaults.standard.value(forKey: Constants.userDefaultKeys.uid) != nil else { return false }
        
        return true
    }
}
