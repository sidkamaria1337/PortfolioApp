//
//  NetworkService.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 18/11/24.
//

import Foundation

protocol NetworkService {
    func buildURL() throws -> URL
}
