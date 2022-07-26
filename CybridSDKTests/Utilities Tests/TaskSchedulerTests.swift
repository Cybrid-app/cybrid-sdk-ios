//
//  TaskSchedulerTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 26/07/22.
//

@testable import CybridSDK
import Foundation
import XCTest

final class TaskSchedulerTests: XCTestCase {
  func testRunLoop() {
    // Given
    let expectation = expectation(description: "Finish running 3 times")
    let expectedLoops = 3
    expectation.expectedFulfillmentCount = expectedLoops

    let scheduler = makeTaskScheduler()
    var loopCount = 0
    let block = {
      expectation.fulfill()
      loopCount += 1
      if loopCount == expectedLoops {
        scheduler.cancel()
      }
    }

    // When
    scheduler.start(block: block)
    (scheduler as? TaskSchedulerMock)?.runLoop()

    // Then
    waitForExpectations(timeout: 3)
    XCTAssertEqual(loopCount, expectedLoops)
    XCTAssertEqual(scheduler.state, .cancelled)
  }
}

extension TaskSchedulerTests {
  func makeTaskScheduler() -> TaskScheduler {
    TaskSchedulerMock(timer: TimerMock())
  }
}
