//
//  MockHttpClient.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 19/11/24.
//

import Foundation
@testable import PortfolioApp

final class MockHttpClient: HttpClient {
    
    var mockData: Data?
    var mockError: Error?
    
    func fetchData(from service: NetworkService) async throws -> Data {
        if let mockError { throw mockError }
        return mockData ?? Data()
    }
}
