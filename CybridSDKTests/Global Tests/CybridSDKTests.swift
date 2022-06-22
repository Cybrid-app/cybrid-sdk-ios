//
//  CybridSDKTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 22/06/22.
//

@testable import CybridSDK
import XCTest

class CybridSDKTests: XCTestCase {

  func testGlobal_ConfigSetup() {
    XCTAssertEqual(CybridSDK.global.theme.fontTheme, CybridTheme.default.fontTheme)

    let testTheme = CybridTheme(
      colorTheme: .default,
      fontTheme: FontTheme(bodyLarge: .systemFont(ofSize: 20), body: .systemFont(ofSize: 16), caption: .systemFont(ofSize: 12)))
    CybridSDK.setup(testTheme)

    XCTAssertEqual(CybridSDK.global.theme.fontTheme, testTheme.fontTheme)
  }
}
