//
//  CybridSDKTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 22/06/22.
//

@testable import CybridSDK
import XCTest

class CybridConfigTests: XCTestCase {

  func testGlobal_ConfigSetup() {
    XCTAssertEqual(Cybrid.theme.fontTheme, CybridTheme.default.fontTheme)

    let testTheme = CybridTheme(
      colorTheme: .default,
      fontTheme: FontTheme(bodyLarge: .systemFont(ofSize: 20), body: .systemFont(ofSize: 16), caption: .systemFont(ofSize: 12)))
      Cybrid.setup(testTheme)

    XCTAssertEqual(Cybrid.theme.fontTheme, testTheme.fontTheme)
  }
}
