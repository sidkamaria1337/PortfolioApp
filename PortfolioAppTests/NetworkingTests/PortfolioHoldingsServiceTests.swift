//
//  PortfolioHoldingsServiceTests.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 19/11/24.
//

import XCTest
@testable import PortfolioApp

final class PortfolioHoldingsServiceTests: XCTestCase {
    func testBuildURL_correctURL() throws {
        let service = PortfolioHoldingsService()
        let url = try service.buildURL()
        XCTAssertEqual(url.absoluteString, "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/")
    }
}
