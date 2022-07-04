//
//  LocalizationTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 3/07/22.
//

@testable import CybridSDK
import XCTest

class LocalizationTests: XCTestCase {

  func testCybridLocalizationKeyEquatable() {
    // Given
    let keyA = CybridLocalizationKey.cryptoPriceList(.headerCurrency)
    let keyB = CybridLocalizationKey.cryptoPriceList(.headerPrice)

    // When
    let isEqual = keyA == keyB

    // Then
    XCTAssertFalse(isEqual)
  }

  func testCybridLocalizer_withEmptyArguments() {
    // Given
    let key = CybridLocalizationKey.cryptoPriceList(.headerCurrency)
    let localizer = CybridLocalizer()

    // When
    let localizedString = localizer.localize(with: key, arguments: [])

    // Then
    XCTAssertFalse(localizedString.isEmpty)
    XCTAssertNotEqual(localizedString, key.stringValue)
  }

  func testCybridLocalizer_withNoParameters() {
    // Given
    let key = CybridLocalizationKey.cryptoPriceList(.headerCurrency)
    let localizer = CybridLocalizer()

    // When
    let localizedString = localizer.localize(with: key)

    // Then
    XCTAssertFalse(localizedString.isEmpty)
    XCTAssertNotEqual(localizedString, key.stringValue)
  }
}
