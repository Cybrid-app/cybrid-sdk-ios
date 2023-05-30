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

        XCTAssertEqual(CybridEnvironment.staging.baseBankPath, "https://bank.staging.cybrid.app")
        XCTAssertEqual(CybridEnvironment.sandbox.baseBankPath, "https://bank.sandbox.cybrid.app")
        XCTAssertEqual(CybridEnvironment.production.baseBankPath, "https://bank.production.cybrid.app")
    }
}
