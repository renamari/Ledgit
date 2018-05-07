//
//  AuthenticationManagerTests.swift
//  LedgitTests
//
//  Created by Marcos Ortiz on 2/10/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import XCTest
import Firebase
@testable import Ledgit

class AuthenticationManagerTests: XCTestCase {
    var manager: AuthenticationManager!
    var managerDelegate: AuthenticationManagerDelegateMock!
    var presenter: AuthenticationPresenter!
    
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
        managerDelegate = AuthenticationManagerDelegateMock()
        presenter = AuthenticationPresenter(manager: manager)
    }

    func testManagerErrorHandling() {
        // Arrange
        guard let code = AuthErrorCode(rawValue: 17007) else {
            XCTFail("Error code not generated")
            return
        }
        
        // Act
        let error = manager.handleError(with: code)
        
        // Assert
        XCTAssertEqual(error, LedgitError.emailAlreadyInUse)
    }
    
    func testDelegateDidReceiveUser() {
        // Arrange
        let user = LedgitUser(dict: userData)
        
        // Act
        managerDelegate.userAuthenticated(user)
        
        // Assert
        XCTAssertTrue(managerDelegate.didAuthenticate)
        XCTAssertEqual(user, managerDelegate.authenticatedUser)
    }
    
    func testDelegateDidReceiveError() {
        // Arrange
        guard let code = AuthErrorCode(rawValue: 17007) else {
            XCTFail("Error code not generated")
            return
        }
        
        let error = manager.handleError(with: code)
        
        // Act
        managerDelegate.authenticationError(error)
        
        // Assert
        XCTAssertTrue(managerDelegate.didReceiveAuthenticationError)
        XCTAssertEqual(error, managerDelegate.error)
    }
    
    func testAuthenticationFailedWithNoNetwork() {
        // Arrange
        manager.delegate = managerDelegate
        manager.isConnected = false
        
        // Act
        manager.performFirebaseSignIn(with: "marcos@gmail.com", password: "password")
        
        // Assert
        XCTAssertTrue(managerDelegate.didReceiveAuthenticationError)
        XCTAssertEqual(managerDelegate.error, LedgitError.noNetworkConnection)
    }
    
    func testAuthenticationFailedWithEmptyValues() {
        // Arrange
        manager.delegate = managerDelegate
        manager.isConnected = true
        
        // Act
        manager.performFirebaseSignIn(with: "", password: "")
        
        // Assert
        XCTAssertTrue(managerDelegate.didReceiveAuthenticationError)
        XCTAssertEqual(managerDelegate.error, LedgitError.emptyTextFields)
    }
}
