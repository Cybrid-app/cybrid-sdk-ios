//
//  AssertionFailureOverrideTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 15/06/22.
//

@testable import CybridSDK
import XCTest

class AssertionFailureOverrideTests: XCTestCase {
  func testAssertFailureWithMessage() {
    let expectedMessage = "HelloWorld"
    expectAssertionFailure(expectedMessage: expectedMessage) {
      assertionFailure(expectedMessage)
    }
  }

  func testAssertFailureEmptyMessage() {
    expectAssertionFailure(expectedMessage: "") {
      assertionFailure()
    }
  }
}
