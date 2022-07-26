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
    XCTAssertEqual(CybridEnvironment.sandbox.basePath, "https://bank.demo.cybrid.app")
    XCTAssertEqual(CybridEnvironment.development.basePath, "https://bank.demo.cybrid.app")
    XCTAssertEqual(CybridEnvironment.production.basePath, "https://bank.demo.cybrid.app")
  }
}
