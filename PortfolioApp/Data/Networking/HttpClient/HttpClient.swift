//
//  HttpClient.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 18/11/24.
//

import Foundation

protocol HttpClient {
    func fetchData(from service: NetworkService) async throws -> Data
}
