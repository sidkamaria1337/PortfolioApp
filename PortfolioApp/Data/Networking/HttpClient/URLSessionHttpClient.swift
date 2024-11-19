//
//  URLSessionHttpClient.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 18/11/24.
//

import Foundation

final class URLSessionHttpClient: HttpClient {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchData(from service: NetworkService) async throws -> Data {
        let url = try service.buildURL()
        let (data, _) = try await urlSession.data(from: url)
        return data
    }
}
