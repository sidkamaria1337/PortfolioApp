//
//  Utility+FormatterTests.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 19/11/24.
//

import XCTest
@testable import PortfolioApp

final class Utility_FormatterTests: XCTestCase {

    func testFormattedAmount_withCurrencySymbol() {
        let result = Utility.formattedAmount(1234.56, for: "USD")
        XCTAssertEqual(result, "$ 1,234.56")
    }

    func testFormattedAmount_withInvalidCurrencySymbol() {
        let result = Utility.formattedAmount(1234.00, for: "XYZ")
        XCTAssertEqual(result, "1,234")
    }

    func testFormattedAmount_negativeAmount() {
        let result = Utility.formattedAmount(-123.45, for: "INR")
        XCTAssertEqual(result, "₹ -123.45")
    }

    func testFormattedAmount_zeroAmount() {
        let result = Utility.formattedAmount(0, for: "USD")
        XCTAssertEqual(result, "$ 0")
    }

    func testGetCurrencySymbol_validCurrencyCodes() {
        let usd = Utility.getCurrencySymbol(for: "USD")
        let inr = Utility.getCurrencySymbol(for: "INR")
        let eur = Utility.getCurrencySymbol(for: "EUR")
        let gbp = Utility.getCurrencySymbol(for: "GBP")
        XCTAssertEqual(usd, "$")
        XCTAssertEqual(inr, "₹")
        XCTAssertEqual(eur, "€")
        XCTAssertEqual(gbp, "£")
    }
}
