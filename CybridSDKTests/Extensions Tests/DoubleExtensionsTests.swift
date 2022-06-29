//
//  DoubleExtensionsTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 29/06/22.
//

@testable import CybridSDK
import XCTest

class DoubleExtensionsTests: XCTestCase {
  func testDouble_toCurrencyString() {
    // Given
    let doubleAmount: Double = 1.123_45

    // When
    let currencyString = doubleAmount.currencyString(with: "USD")

    // Then
    XCTAssertEqual(currencyString, "$1.12345")
  }
}
