//
//  AuthenticationManagerDelegateMock.swift
//  LedgitTests
//
//  Created by Marcos Ortiz on 2/8/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import UIKit
@testable import Ledgit

class AuthenticationManagerDelegateMock: AuthenticationManagerDelegate {
    var didAuthenticate = false
    var didReceiveAuthenticationError = false
    var error = LedgitError(title: "Mock", message: "Message")
    var authenticatedUser: LedgitUser = LedgitUser()
    
    func userAuthenticated(_ user: LedgitUser) {
        didAuthenticate = true
        authenticatedUser = user
    }
    
    func authenticationError(_ error: LedgitError) {
        didReceiveAuthenticationError = true
        self.error = error
    }
}
