//
//  LedgitUserTests.swift
//  LedgitTests
//
//  Created by Marcos Ortiz on 2/10/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import XCTest
@testable import Ledgit

class LedgitUserTests: XCTestCase {
    var incompleteUserData: NSDictionary {
        return [
            "uid": "123456789",
            "categories": ["Transportation", "Food", "Lodging", "Entertainment", "Emergency", "Miscellaneous"],
            "homeCurrency": "USD"
        ]
    }
    
    var completeUserData: NSDictionary {
        return [
            "uid": "123456789",
            "email": "marcosortiz13@gmail.com",
            "name": "Marcos Ortiz",
            "subscription": "Paid",
            "categories": ["Transportation", "Food", "Lodging", "Entertainment", "Emergency", "Miscellaneous", "Test Category"],
            "homeCurrency": "AUD"
        ]
    }
    
    func testUserWithNoData() {
        let user = LedgitUser()
        XCTAssertEqual(user.key, "")
        XCTAssertEqual(user.name, "")
        XCTAssertEqual(user.email, "")
        XCTAssertEqual(user.subscription, .free)
        XCTAssertEqual(user.homeCurrency, .USD)
        XCTAssertEqual(user.categories, ["Transportation",
                                         "Food",
                                         "Lodging",
                                         "Entertainment",
                                         "Emergency",
                                         "Miscellaneous"])
    }
    
    func testUserWithCompleteData() {
        let user = LedgitUser(dict: completeUserData)
        XCTAssertEqual(user.key, "123456789")
        XCTAssertEqual(user.name, "Marcos Ortiz")
        XCTAssertEqual(user.email, "marcosortiz13@gmail.com")
        XCTAssertEqual(user.subscription, .paid)
        XCTAssertEqual(user.homeCurrency, .AUD)
        XCTAssertTrue(user.categories.contains("Test Category"))
        
    }
    
    func testUserWithIncompleteData() {
        let user = LedgitUser(dict: incompleteUserData)
        XCTAssertEqual(user.key, "123456789")
        XCTAssertEqual(user.name, "")
        XCTAssertEqual(user.email, "")
        XCTAssertEqual(user.subscription, .free)
        XCTAssertEqual(user.homeCurrency, .USD)
        XCTAssertEqual(user.categories, ["Transportation", "Food", "Lodging", "Entertainment", "Emergency", "Miscellaneous"])
    }
}
