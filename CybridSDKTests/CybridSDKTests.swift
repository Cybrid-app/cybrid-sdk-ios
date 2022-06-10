//
//  CybridSDKTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 2/06/22.
//

@testable import CybridSDK
import XCTest

class CybridSDKTests: XCTestCase {

    func testExample() throws {
        // Given
        let testCode = TestCode()
        // When
        let result = testCode.addNumbers(1, 2)
        // Then
        XCTAssertEqual(result, 3)
    }

}
