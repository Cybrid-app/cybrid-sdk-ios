//
//  ColorThemeTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 22/06/22.
//

@testable import CybridSDK
import XCTest

class ColorThemeTests: XCTestCase {

  func testTheme_onLightMode() {
    // Given
    let testTheme = ColorTheme.makeDefaultColorTheme(overrideUserInterfaceStyle: .light)

    // Then
    XCTAssertEqual(testTheme.primaryBackgroundColor.cgColor, Tokens.lightestColor.cgColor)
    XCTAssertEqual(testTheme.secondaryBackgroundColor.cgColor, Tokens.lightestColor.cgColor)
    XCTAssertEqual(testTheme.tertiaryBackgroundColor.cgColor, Tokens.gray200.cgColor)
    XCTAssertEqual(testTheme.primaryTextColor.cgColor, Tokens.darkestColor.cgColor)
    XCTAssertEqual(testTheme.secondaryTextColor.cgColor, Tokens.gray400.cgColor)
  }

  func testTheme_onDarkMode() {
    // Given
    let testTheme = ColorTheme.makeDefaultColorTheme(overrideUserInterfaceStyle: .dark)

    // Then
    XCTAssertEqual(testTheme.primaryBackgroundColor.cgColor, Tokens.gray800.cgColor)
    XCTAssertEqual(testTheme.secondaryBackgroundColor.cgColor, Tokens.gray900.cgColor)
    XCTAssertEqual(testTheme.tertiaryBackgroundColor.cgColor, Tokens.gray300.cgColor)
    XCTAssertEqual(testTheme.primaryTextColor.cgColor, Tokens.lightestColor.cgColor)
    XCTAssertEqual(testTheme.secondaryTextColor.cgColor, Tokens.gray100.cgColor)
  }

  func testTheme_onUnspecifiedMode() {
    // Given
    let testTheme = ColorTheme.makeDefaultColorTheme(overrideUserInterfaceStyle: .unspecified)

    // Then
    XCTAssertEqual(testTheme.primaryBackgroundColor.cgColor, Tokens.lightestColor.cgColor)
    XCTAssertEqual(testTheme.secondaryBackgroundColor.cgColor, Tokens.lightestColor.cgColor)
    XCTAssertEqual(testTheme.tertiaryBackgroundColor.cgColor, Tokens.gray200.cgColor)
    XCTAssertEqual(testTheme.primaryTextColor.cgColor, Tokens.darkestColor.cgColor)
    XCTAssertEqual(testTheme.secondaryTextColor.cgColor, Tokens.gray400.cgColor)
  }
}
