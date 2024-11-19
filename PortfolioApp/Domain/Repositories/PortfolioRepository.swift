//
//  PortfolioRepository.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 18/11/24.
//

import Foundation

protocol PortfolioRepository {
    func fetchHoldings() async throws -> [PortfolioHolding]
}
