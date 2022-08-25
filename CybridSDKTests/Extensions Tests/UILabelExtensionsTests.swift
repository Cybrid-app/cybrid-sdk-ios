//
//  UILabelExtensionsTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 22/06/22.
//

@testable import CybridSDK
import XCTest

class UILabelExtensionsTests: XCTestCase {

  func testLabelCreation() {
    let testLabel = UILabel.makeLabel(.body) { _ in }

    XCTAssertEqual(testLabel.numberOfLines, 0)
    XCTAssertEqual(testLabel.translatesAutoresizingMaskIntoConstraints, false)
    XCTAssertEqual(testLabel.font, Cybrid.theme.fontTheme.body)
    XCTAssertEqual(testLabel.textColor, Cybrid.theme.colorTheme.primaryTextColor)
  }

  func testLabelFormat() {
    let testLabel = UILabel()
    testLabel.formatLabel(with: .body)

    XCTAssertEqual(testLabel.numberOfLines, 0)
    XCTAssertEqual(testLabel.translatesAutoresizingMaskIntoConstraints, false)
    XCTAssertEqual(testLabel.font, Cybrid.theme.fontTheme.body)
    XCTAssertEqual(testLabel.textColor, Cybrid.theme.colorTheme.primaryTextColor)
  }

  func testLabelUppercased_True() {
    let testLabel = UILabel()
    testLabel.text = "Test"
    testLabel.formatLabel(with: .header4)

    XCTAssertNotEqual(testLabel.text, "Test")
    XCTAssertEqual(testLabel.text, "TEST")
  }

  func testLabelUppercased_False() {
    let testLabel = UILabel()
    testLabel.text = "Test"

    testLabel.formatLabel(with: .header1)
    XCTAssertNotEqual(testLabel.text, "TEST")
    XCTAssertEqual(testLabel.text, "Test")

    testLabel.formatLabel(with: .header2)
    XCTAssertNotEqual(testLabel.text, "TEST")
    XCTAssertEqual(testLabel.text, "Test")

    testLabel.formatLabel(with: .body)
    XCTAssertNotEqual(testLabel.text, "TEST")
    XCTAssertEqual(testLabel.text, "Test")

    testLabel.formatLabel(with: .caption)
    XCTAssertNotEqual(testLabel.text, "TEST")
    XCTAssertEqual(testLabel.text, "Test")

    testLabel.formatLabel(with: .inputPlaceholder)
    XCTAssertNotEqual(testLabel.text, "TEST")
    XCTAssertEqual(testLabel.text, "Test")

  }
}
