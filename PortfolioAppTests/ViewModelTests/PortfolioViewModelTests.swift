//
//  PortfolioViewModelTests.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 19/11/24.
//

import XCTest
import Combine
@testable import PortfolioApp

final class PortfolioViewModelTests: XCTestCase {

    private var viewModel: PortfolioViewModel!
    private var mockRepository: MockPortfolioRepository!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockPortfolioRepository()
        viewModel = PortfolioViewModel(portfolioRepository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - fetchPortfolio Tests

    func testFetchPortfolioSuccess() async {
        let mockPortfolio = [
            PortfolioHolding(symbol: "MAHABANK", quantity: 10, ltp: 150.0, avgPrice: 120.0, close: 140.0),
            PortfolioHolding(symbol: "AXISBANK", quantity: 5, ltp: 300.0, avgPrice: 250.0, close: 290.0)
        ]
        mockRepository.fetchHoldingsResult = .success(mockPortfolio)
        let expectation = XCTestExpectation(description: "Fetch Portfolio Success")
        viewModel.$portfolio
            .dropFirst()
            .sink { portfolio in
                XCTAssertEqual(portfolio, mockPortfolio)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchPortfolio()
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testFetchPortfolioFailure() async {
        mockRepository.fetchHoldingsResult = .failure(URLError(.notConnectedToInternet))
        let expectation = XCTestExpectation(description: "Fetch Portfolio Failure")
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, String(localized: "unableToFetchPortfolio"))
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchPortfolio()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testHolingAtIndex() async {
        let mockPortfolio = [
            PortfolioHolding(symbol: "MAHABANK", quantity: 10, ltp: 150.0, avgPrice: 120.0, close: 140.0),
            PortfolioHolding(symbol: "AXISBANK", quantity: 5, ltp: 300.0, avgPrice: 250.0, close: 290.0)
        ]
        mockRepository.fetchHoldingsResult = .success(mockPortfolio)
        let expectation = XCTestExpectation(description: "Correct Holding At Index")
        viewModel.$portfolio
            .dropFirst()
            .sink { [weak self] _ in
                guard let self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let holding = self.viewModel.holding(at: 1)
                    XCTAssertEqual(holding, mockPortfolio[1])
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchPortfolio()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testHolingAtIndexOutOfBounds() async {
        let mockPortfolio = [
            PortfolioHolding(symbol: "MAHABANK", quantity: 10, ltp: 150.0, avgPrice: 120.0, close: 140.0),
        ]
        mockRepository.fetchHoldingsResult = .success(mockPortfolio)
        let expectation = XCTestExpectation(description: "Correct Holding At Index")
        viewModel.$portfolio
            .dropFirst()
            .sink { [weak self] portfolio in
                guard let self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let holding = self.viewModel.holding(at: 2)
                    XCTAssertNil(holding)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchPortfolio()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testComputedProperties() async {
        let mockPortfolio = [
            PortfolioHolding(symbol: "MAHABANK", quantity: 10, ltp: 150.0, avgPrice: 120.0, close: 140.0),
            PortfolioHolding(symbol: "AXISBANK", quantity: 5, ltp: 300.0, avgPrice: 250.0, close: 290.0)
        ]
        mockRepository.fetchHoldingsResult = .success(mockPortfolio)
        let expectation = XCTestExpectation(description: "Correct Values For Computed Properties")
        viewModel.$portfolio
            .dropFirst()
            .sink { [weak self] portfolio in
                guard let self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    XCTAssertEqual(self.viewModel.currentValue, 1500.0 + 1500.0)
                    XCTAssertEqual(self.viewModel.totalInvestment, 1200.0 + 1250.0)
                    XCTAssertEqual(self.viewModel.todaysProfitLoss, (-10.0 * 10) + (-10.0 * 5))
                    XCTAssertEqual(self.viewModel.totalProfitLoss, 300.0 + 250.0)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchPortfolio()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
