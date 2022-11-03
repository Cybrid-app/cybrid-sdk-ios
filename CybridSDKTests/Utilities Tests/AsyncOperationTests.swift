//
//  AsyncOperationTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 15/06/22.
//

@testable import CybridSDK
import XCTest

class AsyncOperationTests: XCTestCase {

  private var operationQueue = OperationQueue()

  override func setUpWithError() throws {
    operationQueue = OperationQueue()
  }

  override func tearDownWithError() throws {
    operationQueue.cancelAllOperations()
  }

  func testReadyState() throws {
    let operation = MockAsyncOperation()
    XCTAssertEqual(operation.state, .ready)
  }

  func testExecutingState() throws {
    let expectation = expectation(description: "Operation did start Execution")
    let operation = MockAsyncOperation()
    operation.onStart {
      expectation.fulfill()
    }
    operationQueue.addOperation(operation)
    waitForExpectations(timeout: 1.2)
    XCTAssertEqual(operation.state, .executing)
  }

  func testFinishedState() throws {
    let expectation = expectation(description: "Operation did finish Execution")
    let operation = MockAsyncOperation()
    operation.completionBlock = {
      expectation.fulfill()
    }
    operationQueue.addOperation(operation)
    waitForExpectations(timeout: 3.2)
    XCTAssertEqual(operation.state, .finished)
  }

  func testIsAsynchronous() {
    let operation = MockAsyncOperation()
    XCTAssertTrue(operation.isAsynchronous)
  }

  func testInvalidUseOfAsyncOperation() {
    expectAssertionFailure(expectedMessage: AsyncOperation.unimplementedErrorMessage) { [weak self] in
      let operation = AsyncOperation()
      self?.operationQueue.addOperation(operation)
    }
  }
}
