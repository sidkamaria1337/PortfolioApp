//
//  Utility+Formatter.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 18/11/24.
//

import Foundation

extension Utility {
    
    static func formattedAmount(_ amount: Double, for currencyCode: String = "INR") -> String {
        let amountString = "\(amount.formatted(.number.precision(.fractionLength(0...2))))"
        if let currencySymbol = getCurrencySymbol(for: currencyCode), currencySymbol != currencyCode {
            return "\(currencySymbol) \(amountString)"
        } else {
            return amountString
        }
    }
    
    static func getCurrencySymbol(for currencyCode: String, localeIdentifier: String = Locale.current.identifier) -> String? {
        var components = Locale.Components(identifier: localeIdentifier)
        components.currency = Locale.Currency(currencyCode)
        let locale = Locale(components: components)
        return locale.currencySymbol
    }
}
