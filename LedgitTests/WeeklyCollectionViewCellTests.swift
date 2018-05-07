//
//  WeeklyCollectionViewCellTests.swift
//  LedgitTests
//
//  Created by Marcos Ortiz on 2/19/18.
//  Copyright © 2018 Camden Developers. All rights reserved.
//

import XCTest
@testable import Ledgit

class WeeklyCollectionViewCellTests: XCTestCase {
    var weeklyCollectionCell: WeeklyCollectionViewCell!
    
    override func setUp() {
        super.setUp()
        weeklyCollectionCell = WeeklyCollectionViewCell()
        let view = weeklyCollectionCell.contentView
    }
    
    func testClearValuesFunction() {
        // Arrange
        weeklyCollectionCell.costToday = 10
        weeklyCollectionCell.totalCost = 12
        weeklyCollectionCell.averageCost = 6
        weeklyCollectionCell.dates = [Date(), Date().add(components: 1.day)]
        weeklyCollectionCell.amounts = [1, 2, 3, 4, 5, 6, 7]
        
        // Act
        weeklyCollectionCell.resetValues()
        
        // Assert
        XCTAssertEqual(weeklyCollectionCell.costToday, 0)
        XCTAssertEqual(weeklyCollectionCell.totalCost, 0)
        XCTAssertEqual(weeklyCollectionCell.averageCost, 0)
        XCTAssertEqual(weeklyCollectionCell.dates, [])
        XCTAssertEqual(weeklyCollectionCell.amounts, [0, 0, 0, 0, 0, 0, 0])
    }
    
    func testGenerateTextFunction() {
        // Arrange
        let dayAmount: Double = 70
        
        // Act
        let formattedAmount = dayAmount.currencyFormat()
        
        // Assert
        XCTAssertEqual(formattedAmount, "$70.00")
    }
    
}
