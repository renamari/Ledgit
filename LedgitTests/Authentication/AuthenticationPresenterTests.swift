//
//  AuthenticationPresenterTests.swift
//  LedgitTests
//
//  Created by Marcos Ortiz on 2/8/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import XCTest
import UIKit
@testable import Ledgit
@testable import Firebase

class AuthenticationPresenterTests: XCTestCase {
    var manager: AuthenticationManager!
    var presenter: AuthenticationPresenter!
    var presenterDelegate: AuthenticationPresenterDelegateMock!
    var controller: AuthenticateViewController!
    
    var userData: NSDictionary {
        return [
            "key": "123456789",
            "email": "marcosortiz13@gmail.com",
            "name": "Marcos Ortiz",
            "subscription": "Free",
            "categories": ["Transportation", "Food", "Lodging", "Entertainment", "Emergency", "Miscellaneous"],
            "homeCurrency": "USD"
        ]
    }
    
    override func setUp() {
        super.setUp()
        manager = AuthenticationManager()
        presenter = AuthenticationPresenter(manager: manager)
        presenterDelegate = AuthenticationPresenterDelegateMock()
        
        controller = AuthenticateViewController.instantiate(from: .main)
    }
    
    func testDelegateDidReceiveUser() {
        // Arrange
        let user = LedgitUser(dict: userData)
        
        // Act
        presenterDelegate.successfulAuthentication(of: user)
        
        // Assert
        XCTAssertTrue(presenterDelegate.didAuthenticate)
        XCTAssertEqual(user, presenterDelegate.authenticatedUser)
    }
    
    func testDelegateDidReceiveError() {
        // Arrange
        guard let error = AuthErrorCode(rawValue: 17007) else {
            XCTFail("Error code not generated")
            return
        }
        
        let ledgitError = manager.handleError(with: error)
        
        // Act
        presenterDelegate.displayError(ledgitError)
        
        // Assert
        XCTAssertTrue(presenterDelegate.didReceiveAuthenticationError)
        XCTAssertEqual(ledgitError, presenterDelegate.error)
    }
}
