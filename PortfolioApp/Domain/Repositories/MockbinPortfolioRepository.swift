//
//  MockbinPortfolioRepository.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 18/11/24.
//

import Foundation

final class MockbinPortfolioRepository: PortfolioRepository {
    
    private let userDefaultsCache: UserDefaults
    private let httpClient: HttpClient
    
    init(userDefaultsCache: UserDefaults = .standard, httpClient: HttpClient = URLSessionHttpClient()) {
        self.userDefaultsCache = userDefaultsCache
        self.httpClient = httpClient
    }
    
    /// Returns cached portfolio if API call was recently made, or fetches the latest data
    func fetchHoldings() async throws -> [PortfolioHolding] {
        let cachedPortfolio = fetchCachedPortfolio()
        guard shouldFetchLatest || cachedPortfolio.isEmpty else { return cachedPortfolio }
        do {
            return try await fetchLatestPortfolio()
        } catch {
            // Show cached portfolio as fallback
            if cachedPortfolio.isEmpty { throw error }
            return cachedPortfolio
        }
    }
}

private extension MockbinPortfolioRepository {
    
    /// Check if the value in cache is expired or not
    var shouldFetchLatest: Bool {
        guard let lastFetchTime else { return true }
        return lastFetchTime.addingTimeInterval(Constants.cacheRefreshInterval) <= Date()
    }
    
    /// Check when was last API call made
    var lastFetchTime: Date? {
        return userDefaultsCache.object(forKey: UserDefaultKeys.lastUpdatedAt) as? Date
    }
    
    /// Update last time when the cache was refreshed
    func updateLastFetchTime(to time: Date) {
        userDefaultsCache.setValue(time, forKey: UserDefaultKeys.lastUpdatedAt)
    }
    
    /// Get cached portfolio
    func fetchCachedPortfolio() -> [PortfolioHolding] {
        guard let json = userDefaultsCache.object(forKey: UserDefaultKeys.portfolioHoldings) as? String else { return [] }
        do {
            return try Utility.fromJson(json)
        } catch {
            debugPrint("Error parsing cached portfolio: \(error)")
            return []
        }
    }
    
    /// Update cached portfolio
    func updateCachedPortfolio(with holdings: [PortfolioHolding]) {
        do {
            let json = try Utility.toJson(holdings)
            userDefaultsCache.setValue(json, forKey: UserDefaultKeys.portfolioHoldings)
        } catch {
            debugPrint("Error updating cached portfolio: \(error)")
        }
    }
    
    /// Fetch latest portfolio from service
    func fetchLatestPortfolio() async throws -> [PortfolioHolding] {
        let data = try await httpClient.fetchData(from: PortfolioHoldingsService())
        let holdings = try JSONDecoder().decode(PortfolioServiceResponse.self, from: data).holdings
        updateCachedPortfolio(with: holdings)
        updateLastFetchTime(to: Date())
        return holdings
    }
}


