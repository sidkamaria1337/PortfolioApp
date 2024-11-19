//
//  MockService.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 19/11/24.
//

import Foundation
@testable import PortfolioApp

final class MockService: NetworkService {
    func buildURL() throws -> URL {
        guard let url = URL(string: "https://example.com") else { throw URLError(.badURL) }
        return url
    }
}
