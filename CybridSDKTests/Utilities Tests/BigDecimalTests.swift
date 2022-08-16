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

  func testBigDecimal_multiplication() {
    // Given
    let firstDecimal = BigDecimal("112345678", precision: 8)
    XCTAssertNotNil(firstDecimal)
    let secondDecimal = BigDecimal("2312312", precision: 2)
    XCTAssertNotNil(firstDecimal)

    // When
    let multiplication = try? firstDecimal!.multiply(with: secondDecimal!, targetPrecision: 2)

    // Then
    XCTAssertEqual(multiplication, BigDecimal("2597783", precision: 2))
  }

  func testBigDecimal_multiplication_withCarryNumbers() {
    // Given
    let firstDecimal = BigDecimal("169875678", precision: 8)
    XCTAssertNotNil(firstDecimal)
    let secondDecimal = BigDecimal("2312388", precision: 2)
    XCTAssertNotNil(firstDecimal)

    // When
    let multiplication = try? firstDecimal!.multiply(with: secondDecimal!, targetPrecision: 2)

    // Then
    XCTAssertEqual(multiplication, BigDecimal("3928185", precision: 2))
  }

  func testBigDecimal_multiplication_withCarryNumbers_2() {
    // Given
    let firstDecimal = BigDecimal("198999999", precision: 8)
    XCTAssertNotNil(firstDecimal)
    let secondDecimal = BigDecimal("100", precision: 2)
    XCTAssertNotNil(firstDecimal)

    // When
    let multiplication = try? firstDecimal!.multiply(with: secondDecimal!, targetPrecision: 2)

    // Then
    XCTAssertEqual(multiplication, BigDecimal("199", precision: 2))
  }

  func testBigDecimal_division() {
    // Given
    let fiatAmount = BigDecimal("2597783", precision: 2)
    XCTAssertNotNil(fiatAmount)
    let priceAmount = BigDecimal("2312312", precision: 2)
    XCTAssertNotNil(priceAmount)

    // When
    let result = try? fiatAmount!.divide(by: priceAmount!, targetPrecision: 8)

    // Then
    XCTAssertEqual(result, BigDecimal("112345696", precision: 8))
  }

  func testBigDecimal_division_withLowAmount() {
    // Given
    let fiatAmount = BigDecimal("200", precision: 2)
    XCTAssertNotNil(fiatAmount)
    let priceAmount = BigDecimal("2312312", precision: 2)
    XCTAssertNotNil(priceAmount)

    // When
    let result = try? fiatAmount!.divide(by: priceAmount!, targetPrecision: 8)

    // Then
    XCTAssertEqual(result, BigDecimal("8649", precision: 8))
  }

  func testBigDecimal_division_withMorePrecisionNeeded() {
    // Given
    let fiatAmount = BigDecimal("177735", precision: 5)
    XCTAssertNotNil(fiatAmount)
    let priceAmount = BigDecimal("1230000", precision: 6)
    XCTAssertNotNil(priceAmount)

    // When
    let result = try? fiatAmount!.divide(by: priceAmount!, targetPrecision: 3)

    // Then
    XCTAssertEqual(result, BigDecimal("145", precision: 3))
  }

  func testBigDecimal_roundUp() {
    let amount = BigDecimal(BigInt(stringLiteral: "177735"), precision: 5)

    XCTAssertEqual(amount.roundUp(to: 8), amount)
    XCTAssertEqual(amount.roundUp(to: 3), BigDecimal(BigInt(stringLiteral: "1777"), precision: 3))
    XCTAssertEqual(amount.roundUp(to: 2), BigDecimal(BigInt(stringLiteral: "178"), precision: 2))

    let lesserAmount = BigDecimal(BigInt(stringLiteral: "177735"), precision: 7)
    XCTAssertEqual(lesserAmount.roundUp(to: 6), BigDecimal(BigInt(stringLiteral: "17774"), precision: 6))

    let greaterAmount = BigDecimal(BigInt(stringLiteral: "9999995"), precision: 5)
    XCTAssertEqual(greaterAmount.roundUp(to: 3), BigDecimal(BigInt(stringLiteral: "100000"), precision: 3))
  }
}
