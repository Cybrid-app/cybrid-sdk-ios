//
//  EnvironmentTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 13/07/22.
//

@testable import CybridSDK
import XCTest

class EnvironmentTests: XCTestCase {

    func testBankEnvironmentPaths() {

        XCTAssertEqual(CybridEnvironment.staging.baseBankPath, "https://bank.staging.cybrid.app")
        XCTAssertEqual(CybridEnvironment.sandbox.baseBankPath, "https://bank.sandbox.cybrid.app")
        XCTAssertEqual(CybridEnvironment.production.baseBankPath, "https://bank.production.cybrid.app")
    }

    func testIdpEnvironmentPaths() {

        XCTAssertEqual(CybridEnvironment.staging.baseIdpPath, "https://id.staging.cybrid.app")
        XCTAssertEqual(CybridEnvironment.sandbox.baseIdpPath, "https://id.sandbox.cybrid.app")
        XCTAssertEqual(CybridEnvironment.production.baseIdpPath, "https://id.production.cybrid.app")
    }
}
