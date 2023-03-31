//
//  DecimalTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 28/03/23.
//

@testable import CybridSDK
import XCTest
import BigInt

class CDecimalTest: XCTestCase {

    func test_init_String_2() {

        // -- Given
        let valueToConvert = "2"
        let decimalIntValue = BigInt(2)
        let decimalDecimalValue = "00"
        let decimalnewValue = "2.00"

        // -- When
        let decimal = CDecimal(valueToConvert)

        // -- Then
        XCTAssertEqual(decimal.originalValue, valueToConvert)
        XCTAssertEqual(decimal.intValue, decimalIntValue)
        XCTAssertEqual(decimal.decimalValue, decimalDecimalValue)
        XCTAssertEqual(decimal.newValue, decimalnewValue)
    }

    func test_init_String_2_5() {

        // -- Given
        let valueToConvert = "2.5"
        let decimalIntValue = BigInt(2)
        let decimalDecimalValue = "50"
        let decimalnewValue = "2.50"

        // -- When
        let decimal = CDecimal(valueToConvert)

        // -- Then
        XCTAssertEqual(decimal.originalValue, valueToConvert)
        XCTAssertEqual(decimal.intValue, decimalIntValue)
        XCTAssertEqual(decimal.decimalValue, decimalDecimalValue)
        XCTAssertEqual(decimal.newValue, decimalnewValue)
    }

    func test_init_String_3_43() {

        // -- Given
        let valueToConvert = "3.43"
        let decimalIntValue = BigInt(3)
        let decimalDecimalValue = "43"
        let decimalnewValue = "3.43"

        // -- When
        let decimal = CDecimal(valueToConvert)

        // -- Then
        XCTAssertEqual(decimal.originalValue, valueToConvert)
        XCTAssertEqual(decimal.intValue, decimalIntValue)
        XCTAssertEqual(decimal.decimalValue, decimalDecimalValue)
        XCTAssertEqual(decimal.newValue, decimalnewValue)
    }

    func test_init_String_123456789_0987654321() {

        // -- Given
        let valueToConvert = "123456789.0987654321"
        let decimalIntValue = BigInt(123456789)
        let decimalDecimalValue = "0987654321"
        let decimalnewValue = "123456789.0987654321"

        // -- When
        let decimal = CDecimal(valueToConvert)

        // -- Then
        XCTAssertEqual(decimal.originalValue, valueToConvert)
        XCTAssertEqual(decimal.intValue, decimalIntValue)
        XCTAssertEqual(decimal.decimalValue, decimalDecimalValue)
        XCTAssertEqual(decimal.newValue, decimalnewValue)
    }

    func test_init_String_Int_Error_With_Decimal() {

        // -- Given
        let valueToConvert = "Hola.12"
        let decimalIntValue = BigInt(0)
        let decimalDecimalValue = "12"
        let decimalnewValue = "0.12"

        // -- When
        let decimal = CDecimal(valueToConvert)

        // -- Then
        XCTAssertEqual(decimal.originalValue, valueToConvert)
        XCTAssertEqual(decimal.intValue, decimalIntValue)
        XCTAssertEqual(decimal.decimalValue, decimalDecimalValue)
        XCTAssertEqual(decimal.newValue, decimalnewValue)
    }

    func test_init_String_Int_Error_Without_Decimal() {

        // -- Given
        let valueToConvert = "Hola"
        let decimalIntValue = BigInt(0)
        let decimalDecimalValue = "00"
        let decimalnewValue = "0.00"

        // -- When
        let decimal = CDecimal(valueToConvert)

        // -- Then
        XCTAssertEqual(decimal.originalValue, valueToConvert)
        XCTAssertEqual(decimal.intValue, decimalIntValue)
        XCTAssertEqual(decimal.decimalValue, decimalDecimalValue)
        XCTAssertEqual(decimal.newValue, decimalnewValue)
    }

    func test_init_Int_2() {

        // -- Given
        let valueToConvert: Int = 2
        let decimalIntValue = BigInt(2)
        let decimalDecimalValue = "00"
        let decimalnewValue = "2.00"

        // -- When
        let decimal = CDecimal(valueToConvert)

        // -- Then
        XCTAssertEqual(decimal.originalValue, "2")
        XCTAssertEqual(decimal.intValue, decimalIntValue)
        XCTAssertEqual(decimal.decimalValue, decimalDecimalValue)
        XCTAssertEqual(decimal.newValue, decimalnewValue)
    }

    func test_changeValue_String_From_2_to_10() {

        // -- Given
        let valueToConvert = "2"
        let decimalIntValue = BigInt(2)
        let decimalDecimalValue = "00"
        let decimalnewValue = "2.00"

        // -- When
        var decimal = CDecimal(valueToConvert)
        XCTAssertEqual(decimal.originalValue, valueToConvert)
        XCTAssertEqual(decimal.intValue, BigInt(2))
        XCTAssertEqual(decimal.decimalValue, "00")
        XCTAssertEqual(decimal.newValue, "2.00")
        decimal.changeValue("10.56")

        // -- Then
        XCTAssertEqual(decimal.originalValue, "10.56")
        XCTAssertEqual(decimal.intValue, BigInt(10))
        XCTAssertEqual(decimal.decimalValue, "56")
        XCTAssertEqual(decimal.newValue, "10.56")
    }
}
