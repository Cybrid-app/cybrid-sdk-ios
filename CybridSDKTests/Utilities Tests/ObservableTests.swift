//
//  ObservableTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 29/06/22.
//

@testable import CybridSDK
import XCTest

class ObservableTests: XCTestCase {
  func testObservable() {
    // Given
    let observedString = Observable("")
    let expectedUpdates = [
      "",
      "A",
      "BC",
      "DEF"
    ]
    var actualUpdates: [String] = []

    // When
    observedString.bind { newString in
      actualUpdates.append(newString)
    }
    observedString.value = "A"
    observedString.value = "BC"
    observedString.value = "DEF"

    XCTAssertEqual(actualUpdates, expectedUpdates)
  }
}
