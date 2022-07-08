//
//  BigDecimalTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 8/07/22.
//

import BigInt
@testable import CybridSDK
import XCTest

class BigDecimalTests: XCTestCase {
  func testBigDecimal_fromInt() {
    // Given
    let defaultBigDecimal = BigDecimal(BigInt(10), precision: 2)
    let bigDecimalFromInt = BigDecimal(10, precision: 2)
    let bigDecimalFromIntWithDefaultPrecision = BigDecimal(10)

    // Then
    XCTAssertEqual(bigDecimalFromInt, defaultBigDecimal)
    XCTAssertEqual(bigDecimalFromIntWithDefaultPrecision, defaultBigDecimal)
  }

  func testBigDecimal_fromString() {
    // Given
    let defaultBigDecimal = BigDecimal(BigInt(10), precision: 2)
    let bigDecimalFromString = BigDecimal("10", precision: 2)
    let bigDecimalFromStringWithDefaultPrecision = BigDecimal("10")
    let bigDecimalFromInvalidString = BigDecimal("ABC")

    // Then
    XCTAssertNotNil(bigDecimalFromString)
    XCTAssertNotNil(bigDecimalFromStringWithDefaultPrecision)
    XCTAssertNil(bigDecimalFromInvalidString)
    XCTAssertEqual(bigDecimalFromString, defaultBigDecimal)
    XCTAssertEqual(bigDecimalFromStringWithDefaultPrecision, defaultBigDecimal)
  }

  func testBigDecimal_zeroFunction() {
    // Given
    let zeroDecimal = BigDecimal.zero(withPrecision: 2)

    // Then
    XCTAssertEqual(zeroDecimal.value, BigInt(0))
    XCTAssertEqual(zeroDecimal.precision, 2)
  }
}
