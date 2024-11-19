//
//  Utility+ConfigTests.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 19/11/24.
//

import XCTest
@testable import PortfolioApp

final class Utility_ConfigTests: XCTestCase {
    func testGetOpenExchangeBaseURL_Success() throws {
        let baseURL = try Utility.getPortfolioServiceeBaseURL()
        XCTAssertEqual(baseURL.absoluteString, "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io")
    }
}
