//
//  CybridSDKTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 2/06/22.
//

import XCTest
@testable import CybridSDK

class CybridSDKTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // Given
        let testCode = TestCode()
        // When
        let result = testCode.addNumbers(a: 1, b: 2)
        // Then
        XCTAssertEqual(result, 3)
    }

}
