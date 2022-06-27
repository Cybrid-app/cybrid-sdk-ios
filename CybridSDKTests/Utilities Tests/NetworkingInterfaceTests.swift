//
//  NetworkingInterfaceTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 16/06/22.
//

@testable import CybridSDK
import XCTest

class NetworkingInterfaceTests: XCTestCase {

  /// This test is intended to reach 100% coverage
  func testRealURLSessionCall() {
    self.measure {
      var callFinished = false
      let expectation = expectation(description: "")
      // URL
      let url = URL(string: "https://images.cybrid.xyz/sdk/assets/pdf/color/btc.pdf")
      XCTAssertNotNil(url)

      let session = URLSession.shared

        session.dataTaskWithURL(url!) { _, _, _ in
          callFinished.toggle()
          expectation.fulfill()
        }
        .resume()

      /// Beware, this test could take more time than needed, or even fail.
      /// That's because it's using a real URLSession instance to make a real call.
      waitForExpectations(timeout: 30.0)
      XCTAssertTrue(callFinished)
    }
  }
}
