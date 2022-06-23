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
    XCTAssertEqual(testTheme.primaryBackgroundColor.cgColor, UIConstants.lightestColor.cgColor)
    XCTAssertEqual(testTheme.secondaryBackgroundColor.cgColor, UIConstants.lightestColor.cgColor)
    XCTAssertEqual(testTheme.tertiaryBackgroundColor.cgColor, UIConstants.gray200.cgColor)
    XCTAssertEqual(testTheme.primaryTextColor.cgColor, UIConstants.darkestColor.cgColor)
    XCTAssertEqual(testTheme.secondaryTextColor.cgColor, UIConstants.gray400.cgColor)
  }

  func testTheme_onDarkMode() {
    // Given
    let testTheme = ColorTheme.makeDefaultColorTheme(overrideUserInterfaceStyle: .dark)

    // Then
    XCTAssertEqual(testTheme.primaryBackgroundColor.cgColor, UIConstants.gray800.cgColor)
    XCTAssertEqual(testTheme.secondaryBackgroundColor.cgColor, UIConstants.gray900.cgColor)
    XCTAssertEqual(testTheme.tertiaryBackgroundColor.cgColor, UIConstants.gray300.cgColor)
    XCTAssertEqual(testTheme.primaryTextColor.cgColor, UIConstants.lightestColor.cgColor)
    XCTAssertEqual(testTheme.secondaryTextColor.cgColor, UIConstants.gray100.cgColor)
  }

  func testTheme_onUnspecifiedMode() {
    // Given
    let testTheme = ColorTheme.makeDefaultColorTheme(overrideUserInterfaceStyle: .unspecified)

    // Then
    XCTAssertEqual(testTheme.primaryBackgroundColor.cgColor, UIConstants.lightestColor.cgColor)
    XCTAssertEqual(testTheme.secondaryBackgroundColor.cgColor, UIConstants.lightestColor.cgColor)
    XCTAssertEqual(testTheme.tertiaryBackgroundColor.cgColor, UIConstants.gray200.cgColor)
    XCTAssertEqual(testTheme.primaryTextColor.cgColor, UIConstants.darkestColor.cgColor)
    XCTAssertEqual(testTheme.secondaryTextColor.cgColor, UIConstants.gray400.cgColor)
  }
}
