//
//  PortfolioServiceResponse.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 18/11/24.
//

struct PortfolioServiceResponse: Decodable {
    
    let holdings: [PortfolioHolding]
    
    private enum ContainerCodingKeys: String, CodingKey {
        case data
    }
    
    private enum CodingKeys: String, CodingKey {
        case holdings = "userHolding"
    }
    
    /// Unwrapping one level of extra nesting because the actual holdings in the response json are inside "data" > "userHolding" key.
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
        let holdingsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        self.holdings = try holdingsContainer.decode([PortfolioHolding].self, forKey: .holdings)
    }
}
