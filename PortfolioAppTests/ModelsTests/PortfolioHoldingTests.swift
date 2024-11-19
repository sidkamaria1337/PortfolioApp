//
//  PortfolioHoldingTests.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 19/11/24.
//

import XCTest
@testable import PortfolioApp

final class PortfolioHoldingTests: XCTestCase {
    
    func testNetQtyString() {
        let holding = PortfolioHolding(symbol: "MAHABANK", quantity: 10, ltp: 150.0, avgPrice: 120.0, close: 140.0)
        XCTAssertEqual(holding.netQtyString, "10")
    }

    func testLtpString() {
        let holding = PortfolioHolding(symbol: "MAHABANK", quantity: 10, ltp: 150.0, avgPrice: 120.0, close: 140.0)
        XCTAssertEqual(holding.ltpString, Utility.formattedAmount(150.0))
    }

    func testTotalProfitLossString() {
        let holding = PortfolioHolding(symbol: "MAHABANK", quantity: 10, ltp: 150.0, avgPrice: 120.0, close: 140.0)
        XCTAssertEqual(holding.totalProfitLossString,  Utility.formattedAmount(300.0))
    }

    func testCurrentValue() {
        let holding = PortfolioHolding(symbol: "MAHABANK", quantity: 10, ltp: 150.0, avgPrice: 120.0, close: 140.0)
        XCTAssertEqual(holding.currentValue, 1500.0)
    }

    func testTotalInvestment() {
        let holding = PortfolioHolding(symbol: "MAHABANK", quantity: 10, ltp: 150.0, avgPrice: 120.0, close: 140.0)
        XCTAssertEqual(holding.totalInvestment, 1200.0)
    }

    func testTotalProfitLoss() {
        let holding = PortfolioHolding(symbol: "MAHABANK", quantity: 10, ltp: 150.0, avgPrice: 120.0, close: 140.0)
        XCTAssertEqual(holding.totalProfitLoss, 300.0)
    }

    func testTodaysProfitLoss() {
        let holding = PortfolioHolding(symbol: "MAHABANK", quantity: 10, ltp: 150.0, avgPrice: 120.0, close: 140.0)
        XCTAssertEqual(holding.todaysProfitLoss, -100.0)
    }
}
