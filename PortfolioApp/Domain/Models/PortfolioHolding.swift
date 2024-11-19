//
//  PortfolioHolding.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 15/11/24.
//

struct PortfolioHolding: Codable {
    let symbol: String
    let quantity: Int
    let ltp: Double
    let avgPrice: Double
    let close: Double
}

extension PortfolioHolding: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.symbol == rhs.symbol
    }
}

extension PortfolioHolding {
    
    var netQtyString: String {
        "\(quantity)"
    }
    
    var ltpString: String {
        Utility.formattedAmount(ltp)
    }
    
    var totalProfitLossString: String {
        Utility.formattedAmount(totalProfitLoss)
    }
}

extension PortfolioHolding {
    
    var currentValue: Double {
        ltp * Double(quantity)
    }

    var totalInvestment: Double {
        avgPrice * Double(quantity)
    }
        
    var totalProfitLoss: Double {
        currentValue - totalInvestment
    }
    
    var todaysProfitLoss: Double {
        (close - ltp) * Double(quantity)
    }
}
