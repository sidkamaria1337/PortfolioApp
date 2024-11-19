//
//  MockbinPortfolioRepositoryTests.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 19/11/24.
//

import XCTest
@testable import PortfolioApp

final class MockbinPortfolioRepositoryTests: XCTestCase {
    
    private var userDefaults: UserDefaults!
    private var httpClient: MockHttpClient!
    
    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "Test")
        httpClient = MockHttpClient()
    }

    override func tearDown() {
        userDefaults?.removePersistentDomain(forName: "Test")
        userDefaults = nil
        httpClient = nil
        super.tearDown()
    }
    
    func testFetchHoldings_fromRemote_emptyCache() async throws {
        let json = """
            {
                "data": {
                    "userHolding": [
                      {
                        "symbol": "MAHABANK",
                        "quantity": 990,
                        "ltp": 38.05,
                        "avgPrice": 35,
                        "close": 40
                      }
                    ]
                }
            }
        """
        httpClient.mockData = json.data(using: .utf8)
        let repository = MockbinPortfolioRepository(userDefaultsCache: userDefaults, httpClient: httpClient)
        let portfolio = try await repository.fetchHoldings()
        XCTAssertFalse(portfolio.isEmpty)
        XCTAssertEqual(portfolio.first?.symbol, "MAHABANK")
    }
    
    func testFetchHoldings_fromCache_validCache() async throws {
        let remoteJson = """
            {
                "data": {
                    "userHolding": [
                      {
                        "symbol": "MAHABANK",
                        "quantity": 990,
                        "ltp": 38.05,
                        "avgPrice": 35,
                        "close": 40
                      }
                    ]
                }
            }
        """
        let cacheJson = """
            [
              {
                "symbol": "AXISBANK",
                "quantity": 990,
                "ltp": 38.05,
                "avgPrice": 35,
                "close": 40
              }
            ]
        """
        httpClient.mockData = remoteJson.data(using: .utf8)
        userDefaults.setValue(Date(), forKey: UserDefaultKeys.lastUpdatedAt) // valid cache
        userDefaults.setValue(cacheJson, forKey: UserDefaultKeys.portfolioHoldings)
        let repository = MockbinPortfolioRepository(userDefaultsCache: userDefaults, httpClient: httpClient)
        let portfolio = try await repository.fetchHoldings()
        XCTAssertFalse(portfolio.isEmpty)
        XCTAssertEqual(portfolio.first?.symbol, "AXISBANK")
    }
    
    func testFetchHoldings_fromRemote_invalidCache() async throws {
        let remoteJson = """
            {
                "data": {
                    "userHolding": [
                      {
                        "symbol": "MAHABANK",
                        "quantity": 990,
                        "ltp": 38.05,
                        "avgPrice": 35,
                        "close": 40
                      }
                    ]
                }
            }
        """
        let cacheJson = """
            [
              {
                "symbol": "AXISBANK",
                "quantity": 990,
                "ltp": 38.05,
                "avgPrice": 35,
                "close": 40
              }
            ]
        """
        httpClient.mockData = remoteJson.data(using: .utf8)
        let lastFetchTime = Date().addingTimeInterval(-Constants.cacheRefreshInterval-1) // stale cache
        userDefaults.setValue(lastFetchTime, forKey: UserDefaultKeys.lastUpdatedAt) // invalid cache
        userDefaults.setValue(cacheJson, forKey: UserDefaultKeys.portfolioHoldings)
        let repository = MockbinPortfolioRepository(userDefaultsCache: userDefaults, httpClient: httpClient)
        let portfolio = try await repository.fetchHoldings()
        XCTAssertFalse(portfolio.isEmpty)
        XCTAssertEqual(portfolio.first?.symbol, "MAHABANK")
    }
    
    func testFetchHoldings_fallbackToCacheOnApiErrorOrOffline() async throws {
        let cacheJson = """
            [
              {
                "symbol": "AXISBANK",
                "quantity": 990,
                "ltp": 38.05,
                "avgPrice": 35,
                "close": 40
              }
            ]
        """
        httpClient.mockError = URLError(.notConnectedToInternet)
        let lastFetchTime = Date().addingTimeInterval(-Constants.cacheRefreshInterval-1) // stale cache
        userDefaults.setValue(lastFetchTime, forKey: UserDefaultKeys.lastUpdatedAt) // invalid cache
        userDefaults.setValue(cacheJson, forKey: UserDefaultKeys.portfolioHoldings)
        let repository = MockbinPortfolioRepository(userDefaultsCache: userDefaults, httpClient: httpClient)
        let portfolio = try await repository.fetchHoldings()
        XCTAssertFalse(portfolio.isEmpty) // stills returns value as a fallback
        XCTAssertEqual(portfolio.first?.symbol, "AXISBANK")
    }
}
