//
//  AuthenticationPresenterTests.swift
//  LedgitTests
//
//  Created by Marcos Ortiz on 2/8/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import XCTest
@testable import Ledgit
@testable import Firebase

class AuthenticationPresenterTests: XCTestCase {
    var manager: AuthenticationManager!
    var managerDelegate: AuthenticationManagerDelegateMock!
    var presenter: AuthenticationPresenter!
    
    override func setUp() {
        super.setUp()
        managerDelegate = AuthenticationManagerDelegateMock()
        manager = AuthenticationManager()
        
        manager.delegate = managerDelegate
        presenter = AuthenticationPresenter(manager: manager)
    }
    
    func testManagerErrorHandling() {
        // Arrange
        guard let error = AuthErrorCode(rawValue: 17007) else {
            XCTFail("Error code not generated")
            return
        }
        
        // Act
        let dictionary = manager.handleError(with: error)
        
        // Assert
        XCTAssertEqual(dictionary, Constants.authErrorMessages.emailAlreadyInUse)
    }
    
    func testPresenterReceivedUser() {
        // Arrange
        let data: NSDictionary = [
            "key": "123456789",
            "email": "marcosortiz13@gmail.com",
            "name": "Marcos Ortiz",
            "subscription": "Free",
            "categories": ["Transportation", "Food", "Lodging", "Entertainment", "Emergency", "Miscellaneous"],
            "homeCurrency": "USD"
        ]
        let user = LedgitUser(dict: data)
        
        // Act
        managerDelegate.userAuthenticated(user)
        
        // Assert
        XCTAssertTrue(managerDelegate.didAuthenticate)
        XCTAssertEqual(user, LedgitUser.current)
    }
    
    func testPresenterReceivedError() {
        // Arrange
        guard let error = AuthErrorCode(rawValue: 17007) else {
            XCTFail("Error code not generated")
            return
        }
        
        let dictionary = manager.handleError(with: error)
        
        // Act
        managerDelegate.authenticationError(dict: dictionary)
        
        // Assert
        XCTAssertTrue(managerDelegate.didReceiveAuthenticationError)
    }
}
