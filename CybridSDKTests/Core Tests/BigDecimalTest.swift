//
//  BigDecimalTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 28/09/22.
//

@testable import CybridSDK
import XCTest
import BigNumber

class BigDecimalTest: XCTestCase {

    func test_init_Double() {

        // -- Given
        let double = Double(2)
        let bigDecimalDouble = BigDecimal(double)

        // -- Then
        XCTAssertNotNil(bigDecimalDouble)
        XCTAssertNotNil(bigDecimalDouble.value)
        XCTAssertEqual(bigDecimalDouble.value, BDouble("2"))
    }

    func test_init_String() {

        let bigDecimal = BigDecimal("5")

        XCTAssertNotNil(bigDecimal)
        XCTAssertEqual(bigDecimal.value, BDouble("5"))
    }

    func test_init_String_NaN() {

        let bigDecimal = BigDecimal("NaN")

        XCTAssertNotNil(bigDecimal)
        XCTAssertEqual(bigDecimal.value, BDouble("0"))
    }

    func test_plus() {

        // -- Given
        let bigDecimal = BigDecimal("5")
        let plusDecimal = BigDecimal(8)
        let result = BigDecimal("13").value

        // -- When
        let plus = bigDecimal.plus(augend: plusDecimal)

        // -- Then
        XCTAssertNotNil(plus)
        XCTAssertEqual(plus.value, result)
    }

    func test_minus() {

        // -- Given
        let bigDecimal = BigDecimal("10")
        let minusDecimal = BigDecimal(8)
        let result = BigDecimal("2").value

        // -- When
        let minus = bigDecimal.minus(subtrahend: minusDecimal)

        // -- Then
        XCTAssertNotNil(minus)
        XCTAssertEqual(minus.value, result)
    }

    func test_pow_String() {

        // -- Given
        let bigDecimal = BigDecimal(3)
        let result = BigDecimal(9)

        // -- When
        let pow = bigDecimal.pow(number: "2")

        // -- Then
        XCTAssertNotNil(pow)
        XCTAssertEqual(pow, result)
    }

    func test_pow_String_NaN() {

        // -- Given
        let bigDecimal = BigDecimal(3)
        let result = BigDecimal(1)

        // -- When
        let pow = bigDecimal.pow(number: "NaN")

        // -- Then
        XCTAssertNotNil(pow)
        XCTAssertEqual(pow, result)
    }
}
