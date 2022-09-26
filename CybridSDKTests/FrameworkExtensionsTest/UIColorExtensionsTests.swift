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
        let testColor = UIColor(light: UIConstants.gray100, dark: UIConstants.gray900)
        let testVC = UIViewController()

        // When
        testVC.view.backgroundColor = testColor

        // Then
        XCTAssertEqual(testVC.view.backgroundColor?.cgColor, UIConstants.gray100.cgColor)
    }

    func testDarkModeColor() {

        // Given
        let testColor = UIColor(light: UIConstants.gray100,
        dark: UIConstants.gray900,
        overrideUserInterfaceStyle: .dark)
        let testVC = UIViewController()

        // When
        testVC.view.backgroundColor = testColor

        // Then
        XCTAssertEqual(testVC.view.backgroundColor?.cgColor, UIConstants.gray900.cgColor)
    }

    func testUnspecifiedModeColor() {

        // Given
        let testColor = UIColor(light: UIConstants.gray100,
        dark: UIConstants.gray900,
        overrideUserInterfaceStyle: .unspecified)
        let testVC = UIViewController()

        // When
        testVC.view.backgroundColor = testColor

        // Then
        XCTAssertEqual(testVC.view.backgroundColor?.cgColor, UIConstants.gray100.cgColor)
    }

    func testHexInit() {

        // -- Given
        let color = UIColor(hex: "#FFFFFF")
        let colorAlpha = UIColor(hex: "#FFFFFF", alpha: 0.8)
        let testVC = UIViewController()
        let testVCAlpha = UIViewController()

        // -- When
        testVC.view.backgroundColor = color
        testVCAlpha.view.backgroundColor = colorAlpha

        // -- Then
        XCTAssertEqual(testVC.view.backgroundColor, color)
        XCTAssertEqual(testVCAlpha.view.backgroundColor?.cgColor.alpha, 0.8)
    }
}
