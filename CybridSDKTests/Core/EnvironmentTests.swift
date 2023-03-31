//
//  EnvironmentTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 13/07/22.
//

@testable import CybridSDK
import XCTest

class EnvironmentTests: XCTestCase {

    func testEnvironmentPaths() {

        XCTAssertEqual(CybridEnvironment.staging.basePath, "https://bank.staging.cybrid.app")
        XCTAssertEqual(CybridEnvironment.sandbox.basePath, "https://bank.sandbox.cybrid.app")
        XCTAssertEqual(CybridEnvironment.production.basePath, "https://bank.production.cybrid.app")
    }
}
