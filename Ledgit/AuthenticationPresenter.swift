//
//  AuthenticationPresenter.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 10/19/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import Foundation

enum Platform {
    case firebase
    case facebook
}

protocol AuthenticationPresenterDelegate: class {
    func successfulAuthentication(of user: User)
    func displayError(_ dict: ErrorDictionary)
}

class AuthenticationPresenter {
    weak var delegate: AuthenticationPresenterDelegate?
    var manager: AuthenticationManager!
    
    init(manager: AuthenticationManager){
        self.manager = manager
        self.manager.delegate = self
    }
    
    func authenticateUser(platform: Platform, method: AuthenticationMethod, email: String, password: String) {
        switch method {
        case .signin:
            platform == .firebase ? manager.performFirebaseSignIn(with: email, password: password) : manager.performFacebookSignIn()

        case .signup:
            platform == .firebase ? manager.performFirebaseSignUp(with: email, password: password) : manager.peformFacebookSignUp()
        }
    }
}

extension AuthenticationPresenter: AuthenticationManagerDelegate {
    func userAuthenticated(_ user: User) {
        delegate?.successfulAuthentication(of: user)
    }
    
    func authenticationError(dict: ErrorDictionary) {
        delegate?.displayError(dict)
    }
}

