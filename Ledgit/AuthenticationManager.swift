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
    func userAuthenticated(_ user: User)
    func authenticationError(dict: ErrorDictionary)
}

class AuthenticationManager {
    weak var delegate: AuthenticationManagerDelegate?
    var users = Database.database().reference().child("users")
    var auth = Auth.auth()
    var facebook = LoginManager()
}

extension AuthenticationManager {
    
    func performFirebaseSignUp(with email: String, password: String) {
        guard Reachability.isConnectedToNetwork() == true else{
            self.delegate?.authenticationError(dict: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        guard !email.isEmpty, !password.isEmpty else {
            self.delegate?.authenticationError(dict: Constants.ClientErrorMessages.emptyTextFields)
            return
        }
        
        auth.createUser(withEmail: email, password: password) { [unowned self] (user, error) in
            if let error = error, let code = AuthErrorCode(rawValue: error._code){
                switch code {
                case .emailAlreadyInUse:
                    self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.emailAlreadyInUse)
                    
                case .invalidEmail:
                    self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.invalidEmail)
                    
                default:
                    self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.general)
                }
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
            
            self.delegate?.userAuthenticated(User(dict: data))
        }
    }
    
    func performFirebaseSignIn(with email:String, password: String) {
        guard Reachability.isConnectedToNetwork() == true else{
            self.delegate?.authenticationError(dict: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        guard !email.isEmpty, !password.isEmpty else {
            self.delegate?.authenticationError(dict: Constants.ClientErrorMessages.emptyTextFields)
            return
        }
        
        auth.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error, let code = AuthErrorCode(rawValue: error._code){
                switch code {
                case .emailAlreadyInUse:
                    self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.emailAlreadyInUse)
                    
                case .invalidEmail:
                    self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.invalidEmail)
                    
                default:
                    self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.general)
                }
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
                
                self.delegate?.userAuthenticated(User(dict: snapshot))
            })
        }
    }
    
    func peformFacebookSignUp() {
        guard Reachability.isConnectedToNetwork() == true else{
            self.delegate?.authenticationError(dict: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        facebook.logIn(readPermissions: [ReadPermission.publicProfile,ReadPermission.email, ReadPermission.userFriends], viewController: nil) { [unowned self] (result) in
            switch result{
            case .failed(let error):
                
                if let code = AuthErrorCode(rawValue: error._code){
                    switch code {
                    case .userDisabled:
                        self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.userDisabled)
                        
                    case .invalidEmail:
                        self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.invalidEmail)
                        
                    case .wrongPassword:
                        self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.wrongPassword)
                        
                    case .userNotFound:
                        self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.userNotFound)
                        
                    default:
                        self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.general)
                    }
                }
                
            case .cancelled:
                self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.general)
                
            case .success( _,  _, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                
                self.auth.signIn(with: credential, completion: { (user, error) in
                    if let error = error, let code = AuthErrorCode(rawValue: error._code){
                        switch code {
                        case .userDisabled:
                            self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.userDisabled)
                            
                        case .invalidEmail:
                            self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.invalidEmail)
                            
                        case .wrongPassword:
                            self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.wrongPassword)
                            
                        case .userNotFound:
                            self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.userNotFound)
                            
                        default:
                            self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.general)
                        }
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
                    
                    self.delegate?.userAuthenticated(User(dict: data))
                })
            }
        }
    }
    
    func performFacebookSignIn() {
        guard Reachability.isConnectedToNetwork() == true else{
            self.delegate?.authenticationError(dict: Constants.ClientErrorMessages.noNetworkConnection)
            return
        }
        
        facebook.logIn(readPermissions: [ReadPermission.publicProfile,ReadPermission.email, ReadPermission.userFriends], viewController: nil) { [unowned self] (result) in
            switch result{
            case .failed(let error):
                
                if let code = AuthErrorCode(rawValue: error._code){
                    switch code {
                    case .userDisabled:
                        self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.userDisabled)
                        
                    case .invalidEmail:
                        self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.invalidEmail)
                        
                    case .wrongPassword:
                        self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.wrongPassword)
                        
                    case .userNotFound:
                        self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.userNotFound)
                        
                    default:
                        self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.general)
                    }
                }
                
            case .cancelled:
                self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.general)
                
            case .success( _,  _, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                
                self.auth.signIn(with: credential, completion: { (user, error) in
                    if let error = error, let code = AuthErrorCode(rawValue: error._code){
                        switch code {
                        case .emailAlreadyInUse:
                            self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.emailAlreadyInUse)
                            
                        case .invalidEmail:
                            self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.invalidEmail)
                            
                        default:
                            self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.general)
                        }
                    }
                    
                    guard let user = user else {
                        self.delegate?.authenticationError(dict: Constants.AuthErrorMessages.general)
                        return
                    }
                    
                    self.users.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapshot = snapshot.value as? NSDictionary{
                            UserDefaults.standard.set(user.uid, forKey: Constants.UserDefaultKeys.uid)
                            
                            self.delegate?.userAuthenticated(User(dict: snapshot))
                        }
                    })
                })
            }
        }
    }
}
