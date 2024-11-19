//
//  PortfolioHoldingCellViewModel.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 15/11/24.
//

import Combine

final class PortfolioViewModel {
    
    @Published private(set) var portfolio: [PortfolioHolding] = []
    @Published private(set) var errorMessage: String? = nil
    
    private let portfolioRepository: PortfolioRepository
    
    init(portfolioRepository: PortfolioRepository = MockbinPortfolioRepository()) {
        self.portfolioRepository = portfolioRepository
    }
}

// MARK: - Public methods
extension PortfolioViewModel {
    func fetchPortfolio() {
        Task {
            do {
                let portfolio = try await portfolioRepository.fetchHoldings()
                await updatePortfolio(with: portfolio)
            } catch {
                await showError(message: String(localized: "unableToFetchPortfolio"))
            }
        }
    }
    
    func holding(at index: Int) -> PortfolioHolding? {
        guard portfolio.count > index else { return nil }
        return portfolio[index]
    }
}

// MARK: - Computed properties
extension PortfolioViewModel {
    
    var currentValue: Double {
        portfolio.reduce(0) { $0 + $1.currentValue }
    }
    
    var totalInvestment: Double {
        portfolio.reduce(0) { $0 + $1.totalInvestment }
    }
    
    var todaysProfitLoss: Double {
        portfolio.reduce(0) { $0 + $1.todaysProfitLoss }
    }
    
    var totalProfitLoss: Double {
        currentValue - totalInvestment
    }
}

// MARK: - Main actor updates
private extension PortfolioViewModel {
    @MainActor
    func updatePortfolio(with portfolio: [PortfolioHolding]) {
        self.portfolio = portfolio
    }
    
    @MainActor
    func showError(message: String) {
        self.errorMessage = message
    }
}
