//
//  AuthenticationManagerDelegateMock.swift
//  LedgitTests
//
//  Created by Marcos Ortiz on 2/8/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import Foundation
@testable import Ledgit

class AuthenticationManagerDelegateMock: AuthenticationManagerDelegate {
    var didAuthenticate = false
    var didReceiveAuthenticationError = false
    var errorDictionary: [String:String] = [:]
    var authenticatedUser: LedgitUser = LedgitUser()
    
    func userAuthenticated(_ user: LedgitUser) {
        didAuthenticate = true
        authenticatedUser = user
    }
    
    func authenticationError(dict: ErrorDictionary) {
        didReceiveAuthenticationError = true
        errorDictionary = dict
    }
}
