//
//  UIColorExtensionsTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 22/06/22.
//

@testable import CybridSDK
import XCTest

class UIColorExtensionsTests: XCTestCase {

  func testLightModeColor() {
    // Given
    let testColor = UIColor(light: Tokens.gray100, dark: Tokens.gray900)
    let testVC = UIViewController()

    // When
    testVC.view.backgroundColor = testColor

    // Then
    XCTAssertEqual(testVC.view.backgroundColor?.cgColor, Tokens.gray100.cgColor)
  }

  func testDarkModeColor() {
    // Given
    let testColor = UIColor(light: Tokens.gray100,
                            dark: Tokens.gray900,
                            interfaceStyleProvider: MockUIStyleProvider(userInterfaceStyle: .dark))
    let testVC = UIViewController()

    // When
    testVC.view.backgroundColor = testColor

    // Then
    XCTAssertEqual(testVC.view.backgroundColor?.cgColor, Tokens.gray900.cgColor)
  }

  func testUnspecifiedModeColor() {
    // Given
    let testColor = UIColor(light: Tokens.gray100,
                            dark: Tokens.gray900,
                            interfaceStyleProvider: MockUIStyleProvider(userInterfaceStyle: .unspecified))
    let testVC = UIViewController()

    // When
    testVC.view.backgroundColor = testColor

    // Then
    XCTAssertEqual(testVC.view.backgroundColor?.cgColor, Tokens.gray100.cgColor)
  }
}

struct MockUIStyleProvider: InterfaceStyleProvider {
  let userInterfaceStyle: UIUserInterfaceStyle
}
