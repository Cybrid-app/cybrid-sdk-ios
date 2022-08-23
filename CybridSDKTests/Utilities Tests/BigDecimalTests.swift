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
    let defaultBigDecimal = SBigDecimal(BigInt(10), precision: 2)
    let bigDecimalFromInt = SBigDecimal(10, precision: 2)
    let bigDecimalFromIntWithDefaultPrecision = SBigDecimal(10)

    // Then
    XCTAssertEqual(bigDecimalFromInt, defaultBigDecimal)
    XCTAssertEqual(bigDecimalFromIntWithDefaultPrecision, defaultBigDecimal)
  }

  func testBigDecimal_fromString() {
    // Given
    let defaultBigDecimal = SBigDecimal(BigInt(10), precision: 2)
    let bigDecimalFromString = SBigDecimal("10", precision: 2)
    let bigDecimalFromStringWithDefaultPrecision = SBigDecimal("10")
    let bigDecimalFromInvalidString = SBigDecimal("ABC")

    // Then
    XCTAssertNotNil(bigDecimalFromString)
    XCTAssertNotNil(bigDecimalFromStringWithDefaultPrecision)
    XCTAssertNil(bigDecimalFromInvalidString)
    XCTAssertEqual(bigDecimalFromString, defaultBigDecimal)
    XCTAssertEqual(bigDecimalFromStringWithDefaultPrecision, defaultBigDecimal)
  }

  func testBigDecimal_zeroFunction() {
    // Given
    let zeroDecimal = SBigDecimal.zero(withPrecision: 2)

    // Then
    XCTAssertEqual(zeroDecimal.value, BigInt(0))
    XCTAssertEqual(zeroDecimal.precision, 2)
  }

  func testBigDecimal_multiplication() {
    // Given
    let firstDecimal = SBigDecimal("112345678", precision: 8)
    XCTAssertNotNil(firstDecimal)
    let secondDecimal = SBigDecimal("2312312", precision: 2)
    XCTAssertNotNil(firstDecimal)

    // When
    let multiplication = try? firstDecimal!.multiply(with: secondDecimal!, targetPrecision: 2)

    // Then
    XCTAssertEqual(multiplication, SBigDecimal("2597783", precision: 2))
  }

  func testBigDecimal_multiplication_withCarryNumbers() {
    // Given
    let firstDecimal = SBigDecimal("169875678", precision: 8)
    XCTAssertNotNil(firstDecimal)
    let secondDecimal = SBigDecimal("2312388", precision: 2)
    XCTAssertNotNil(firstDecimal)

    // When
    let multiplication = try? firstDecimal!.multiply(with: secondDecimal!, targetPrecision: 2)

    // Then
    XCTAssertEqual(multiplication, SBigDecimal("3928185", precision: 2))
  }

  func testBigDecimal_multiplication_withCarryNumbers_2() {
    // Given
    let firstDecimal = SBigDecimal("198999999", precision: 8)
    XCTAssertNotNil(firstDecimal)
    let secondDecimal = SBigDecimal("100", precision: 2)
    XCTAssertNotNil(firstDecimal)

    // When
    let multiplication = try? firstDecimal!.multiply(with: secondDecimal!, targetPrecision: 2)

    // Then
    XCTAssertEqual(multiplication, SBigDecimal("199", precision: 2))
  }

  func testBigDecimal_division() {
    // Given
    let fiatAmount = SBigDecimal("2597783", precision: 2)
    XCTAssertNotNil(fiatAmount)
    let priceAmount = SBigDecimal("2312312", precision: 2)
    XCTAssertNotNil(priceAmount)

    // When
    let result = try? fiatAmount!.divide(by: priceAmount!, targetPrecision: 8)

    // Then
    XCTAssertEqual(result, SBigDecimal("112345696", precision: 8))
  }

  func testBigDecimal_division_withLowAmount() {
    // Given
    let fiatAmount = SBigDecimal("200", precision: 2)
    XCTAssertNotNil(fiatAmount)
    let priceAmount = SBigDecimal("2312312", precision: 2)
    XCTAssertNotNil(priceAmount)

    // When
    let result = try? fiatAmount!.divide(by: priceAmount!, targetPrecision: 8)

    // Then
    XCTAssertEqual(result, SBigDecimal("8649", precision: 8))
  }

  func testBigDecimal_division_withMorePrecisionNeeded() {
    // Given
    let fiatAmount = SBigDecimal("177735", precision: 5)
    XCTAssertNotNil(fiatAmount)
    let priceAmount = SBigDecimal("1230000", precision: 6)
    XCTAssertNotNil(priceAmount)

    // When
    let result = try? fiatAmount!.divide(by: priceAmount!, targetPrecision: 3)

    // Then
    XCTAssertEqual(result, SBigDecimal("145", precision: 3))
  }

  func testBigDecimal_roundUp() {
    let amount = SBigDecimal(BigInt(stringLiteral: "177735"), precision: 5)

    XCTAssertEqual(amount.roundUp(to: 8), amount)
    XCTAssertEqual(amount.roundUp(to: 3), SBigDecimal(BigInt(stringLiteral: "1777"), precision: 3))
    XCTAssertEqual(amount.roundUp(to: 2), SBigDecimal(BigInt(stringLiteral: "178"), precision: 2))

    let lesserAmount = SBigDecimal(BigInt(stringLiteral: "177735"), precision: 7)
    XCTAssertEqual(lesserAmount.roundUp(to: 6), SBigDecimal(BigInt(stringLiteral: "17774"), precision: 6))

    let greaterAmount = SBigDecimal(BigInt(stringLiteral: "9999995"), precision: 5)
    XCTAssertEqual(greaterAmount.roundUp(to: 3), SBigDecimal(BigInt(stringLiteral: "100000"), precision: 3))
  }
}
