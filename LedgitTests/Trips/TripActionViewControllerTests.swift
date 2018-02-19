//
//  TripActionViewControllerTests.swift
//  LedgitTests
//
//  Created by Marcos Ortiz on 2/11/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Ledgit

class TripActionViewControllerTests: XCTestCase {
    var tripActionViewController: TripActionViewController!
    
    override func setUp() {
        super.setUp()
        tripActionViewController = TripActionViewController.instantiate(from: .trips)
    }
    
    func testValidateDatesIsSuccessful() {
        // Arrange
        let startDate = Date()
        let endDate = startDate.add(components: 2.days)
        
        // Act
        let result = tripActionViewController.validate(startDate, isBefore: endDate)
        
        // Assert
        XCTAssertTrue(result, "Result was actually \(result)")
    }
    
    func testValidateDatesNotSuccessful() {
        // Arrange
        let endDate = Date()
        let startDate = endDate.add(components: 2.days)
        
        // Act
        let result = tripActionViewController.validate(startDate, isBefore: endDate)
        
        // Assert
        XCTAssertFalse(result, "Result was actually \(result)")
    }
    
    func testSetTripLengthCorrect() {
        // Arrange
        let startDate = Date()
        let endDate = startDate.add(components: 2.days)
        
        // Act
        tripActionViewController.setTripLength(from: startDate, to: endDate)
        
        // Assert
        XCTAssertEqual(tripActionViewController.tripLength, 2)
    }
    
    func testPerformSaveActionFailedWithEmptyField() {
        // Arrange
        // 1. Since a view controller needs a navigation controller to display
        // 2. Calling view causes viewDidLoad to be called
        //    and all IBOutlets to be initialized
        UIApplication.shared.delegate?.window??.rootViewController = tripActionViewController
        let view = tripActionViewController.view
        tripActionViewController.nameTextField.text = ""
        tripActionViewController.startDateTextField.text = ""
        tripActionViewController.endDateTextField.text = ""
        tripActionViewController.budgetTextField.text = ""
        
        // Act
        tripActionViewController.performSaveAction()
        
        // Assert
        XCTAssertNotNil(view)
        XCTAssertTrue(tripActionViewController.presentedViewController is UIAlertController)
    }
    
    func testPerformUpdateActionFailedWithEmptyFields() {
        // Arrange
        // 1. Since a view controller needs a navigation controller to display
        // 2. Calling view causes viewDidLoad to be called
        //    and all IBOutlets to be initialized
        UIApplication.shared.delegate?.window??.rootViewController = tripActionViewController
        let view = tripActionViewController.view
        tripActionViewController.nameTextField.text = ""
        tripActionViewController.startDateTextField.text = ""
        tripActionViewController.endDateTextField.text = ""
        tripActionViewController.budgetTextField.text = ""
        
        // Act
        tripActionViewController.performUpdateAction()
        
        // Assert
        XCTAssertNotNil(view)
        XCTAssertTrue(tripActionViewController.presentedViewController is UIAlertController)
    }
}
