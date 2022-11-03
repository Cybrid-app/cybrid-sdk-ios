//
//  PollingTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 03/11/22.
//

@testable import CybridSDK
import XCTest

class PollingTest: XCTestCase {

    func test_init() {

        // -- Given
        var num = 1
        let polling = Polling { num = num + 1 }

        // -- Tthen
        XCTAssertNotNil(polling)
        XCTAssertNotNil(polling.timer)
        XCTAssertNotNil(polling.runner)
        XCTAssertNotNil(polling.queue)
    }

    func test_stop() {

        // -- Given
        var num = 1
        let polling = Polling { num = num + 1 }

        // -- When
        polling.stop()

        // -- Then
        XCTAssertTrue(polling.timer.isCancelled)
    }
}
