//
//  MockPortfolioRepository.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 19/11/24.
//


import XCTest
import Combine
@testable import PortfolioApp

final class MockPortfolioRepository: PortfolioRepository {
    
    var fetchHoldingsResult: Result<[PortfolioHolding], Error> = .success([])

    func fetchHoldings() async throws -> [PortfolioHolding] {
        switch fetchHoldingsResult {
        case .success(let portfolio):
            return portfolio
        case .failure(let error):
            throw error
        }
    }
}
