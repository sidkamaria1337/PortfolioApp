//
//  ConfigError.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 18/11/24.
//

import Foundation

enum ConfigError: Error {
    case missingConfig(message: String)
}
