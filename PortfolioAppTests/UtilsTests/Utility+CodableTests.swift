//
//  Untitled.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 19/11/24.
//

import XCTest
@testable import PortfolioApp

final class Utility_CodableTests: XCTestCase {
    
    func testToJson_encodesSuccessfully() throws {
        let holding = PortfolioHolding(symbol: "ABC", quantity: 10, ltp: 1.2, avgPrice: 2.4, close: 2.1)
        let json = try Utility.toJson(holding)
        XCTAssertTrue(json.contains("symbol"))
        XCTAssertTrue(json.contains("ABC"))
        XCTAssertTrue(json.contains("quantity"))
        XCTAssertTrue(json.contains("10"))
        XCTAssertTrue(json.contains("ltp"))
        XCTAssertTrue(json.contains("1.2"))
        XCTAssertTrue(json.contains("avgPrice"))
        XCTAssertTrue(json.contains("2.4"))
        XCTAssertTrue(json.contains("close"))
        XCTAssertTrue(json.contains("2.1"))
    }
    
    func testFromJson_decodesSuccessfully() throws {
        let json = """
          {
            "symbol": "MAHABANK",
            "quantity": 990,
            "ltp": 38.05,
            "avgPrice": 35,
            "close": 40
          }
        """
        let holding: PortfolioHolding = try Utility.fromJson(json)
        XCTAssertEqual(holding.symbol, "MAHABANK")
        XCTAssertEqual(holding.quantity, 990)
        XCTAssertEqual(holding.ltp, 38.05)
        XCTAssertEqual(holding.avgPrice, 35)
        XCTAssertEqual(holding.close, 40)
    }
    
    func testFromJson_decodingError() throws {
        let json = """
          {
            "symbol": "MAHABANK"
          }
        """
        XCTAssertThrowsError(try Utility.fromJson(json, to: PortfolioHolding.self)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
}
