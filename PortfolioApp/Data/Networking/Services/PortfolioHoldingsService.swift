//
//  PortfolioHoldingsService.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 18/11/24.
//

import Foundation

final class PortfolioHoldingsService: NetworkService {
    
    private let path = ""
    
    func buildURL() throws -> URL {
        let baseUrl = try Utility.getPortfolioServiceeBaseURL()
        return baseUrl.appending(path: path)
    }
}
