//
//  Utility.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 18/11/24.
//

import Foundation

struct Utility {
    static func getPortfolioServiceeBaseURL(from bundle: Bundle = .main) throws -> URL {
        guard let baseUrlString = bundle.infoDictionary?["Portfolio Holdings Base URL"] as? String, let baseUrl = URL(string: baseUrlString) else {
            throw ConfigError.missingConfig(message: String(localized: "missingBaseURLMessage"))
        }
        return baseUrl
    }
}
