//
//  XCTestCase+expectFailure.swift
//  CybridSDKTests
//
//  Created by Cybrid on 15/06/22.
//

@testable import CybridSDK
import Foundation
import XCTest

extension XCTestCase {
  func expectAssertionFailure(expectedMessage: String, testcase: @escaping () -> Void) {
    let expectation = expectation(description: "expect AssertionFailure")
    var assertionMessage: String?
    let operationQueue = OperationQueue()

    AssertionFailureOverride.replaceAssertionClosure { message in
      assertionMessage = message
      expectation.fulfill()
    }

    operationQueue.addOperation {
      testcase()
    }

    waitForExpectations(timeout: 0.1) { _ in
      XCTAssertEqual(assertionMessage, expectedMessage)
      AssertionFailureOverride.restoreAssertionClosure()
    }
  }
}
