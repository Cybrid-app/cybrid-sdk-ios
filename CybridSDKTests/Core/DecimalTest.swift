//
//  DecimalTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 28/03/23.
//

@testable import CybridSDK
import XCTest
import BigInt

class DecimalTest: XCTestCase {

    func test_init_String_2() {

        // -- Given
        let valueToConvert = "2"
        let decimalIntValue = BigInt(2)
        let decimalDecimalValue = "00"
        let decimalnewValue = "2.00"

        // -- When
        let decimal = Decimal(valueToConvert)

        // -- Then
        XCTAssertEqual(decimal.originalValue, valueToConvert)
        XCTAssertEqual(decimal.intValue, decimalIntValue)
        XCTAssertEqual(decimal.decimalValue, decimalDecimalValue)
        XCTAssertEqual(decimal.newValue, decimalnewValue)
    }
}
