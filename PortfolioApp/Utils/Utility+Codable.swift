//
//  Utility+Codable.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 18/11/24.
//

import Foundation

extension Utility {
    static func toJson<T: Encodable>(_ entity: T) throws -> String {
        let data = try JSONEncoder().encode(entity)
        guard let json = String(data: data, encoding: .utf8) else { throw DataError.encodingError }
        return json
    }
    
    static func fromJson<T: Decodable>(_ json: String, to type: T.Type = T.self) throws -> T {
        guard let data = json.data(using: .utf8) else { throw DataError.decodingError }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
