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

        testLabel.formatLabel(with: .disclaimer)
        XCTAssertNotEqual(testLabel.text, "TEST")
        XCTAssertEqual(testLabel.text, "Test")

        testLabel.formatLabel(with: .caption)
        XCTAssertNotEqual(testLabel.text, "TEST")
        XCTAssertEqual(testLabel.text, "Test")

        testLabel.formatLabel(with: .inputPlaceholder)
        XCTAssertNotEqual(testLabel.text, "TEST")
        XCTAssertEqual(testLabel.text, "Test")
    }

    func testLocalizedText() {

        // -- Given
        let testLabel = UILabel()

        // -- When
        testLabel.setLocalizedText(key: "cybrid.cryptoPriceList.headerCurrency", localizer: CybridLocalizer())

        // -- Then
        XCTAssertEqual(testLabel.text, "Currency")
    }

    func testMakeBasic() {

        // -- Given
        let font = UIFont.make(ofSize: 17)
        let testLabel = UILabel.makeBasic(font: font, color: .blue, aligment: .center)

        // -- Then
        XCTAssertEqual(testLabel.font, font)
        XCTAssertEqual(testLabel.textColor, UIColor.blue)
        XCTAssertEqual(testLabel.textAlignment, .center)
    }

    func testLabelAttributtedLeft() {

        // -- Given
        let font = UIFont.make(ofSize: 17)
        let testLabel = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let text = NSMutableAttributedString(
                string: "Hello world",
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.foregroundColor: UIColor.blue,
                    NSAttributedString.Key.font: font
                ]
            )
        text.addAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.red,
                NSAttributedString.Key.font: font
            ],
            range: NSRange(location: 6, length: 5)
        )

        // -- When
        testLabel.setAttributedText(
            mainText: "Hello",
            mainTextFont: font,
            mainTextColor: UIColor.blue,
            attributedText: "world",
            attributedTextFont: font,
            attributedTextColor: UIColor.red,
            side: .left)

        // -- Then
        XCTAssertEqual(testLabel.font, font)
        XCTAssertEqual(testLabel.attributedText, text)
    }

    func testLabelAttributtedCenter() {

        // -- Given
        let font = UIFont.make(ofSize: 17)
        let testLabel = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let text = NSMutableAttributedString(
                string: "Hello world",
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.foregroundColor: UIColor.blue,
                    NSAttributedString.Key.font: font
                ]
            )
        text.addAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.red,
                NSAttributedString.Key.font: font
            ],
            range: NSRange(location: 6, length: 5)
        )

        // -- When
        testLabel.setAttributedText(
            mainText: "Hello",
            mainTextFont: font,
            mainTextColor: UIColor.blue,
            attributedText: "world",
            attributedTextFont: font,
            attributedTextColor: UIColor.red,
            side: .center)

        // -- Then
        XCTAssertEqual(testLabel.font, font)
        XCTAssertEqual(testLabel.attributedText, text)
    }

    func testLabelAttributtedRight() {

        // -- Given
        let font = UIFont.make(ofSize: 17)
        let testLabel = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let text = NSMutableAttributedString(
                string: "Hello world",
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.foregroundColor: UIColor.blue,
                    NSAttributedString.Key.font: font
                ]
            )
        text.addAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.red,
                NSAttributedString.Key.font: font
            ],
            range: NSRange(location: 6, length: 5)
        )

        // -- When
        testLabel.setAttributedText(
            mainText: "Hello",
            mainTextFont: font,
            mainTextColor: UIColor.blue,
            attributedText: "world",
            attributedTextFont: font,
            attributedTextColor: UIColor.red,
            side: .right)

        // -- Then
        XCTAssertEqual(testLabel.font, font)
        XCTAssertEqual(testLabel.attributedText, text)
    }
}
