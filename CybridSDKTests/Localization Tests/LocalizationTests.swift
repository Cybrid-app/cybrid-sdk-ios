//
//  LocalizationTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 3/07/22.
//

@testable import CybridSDK
import XCTest

class LocalizationTests: XCTestCase {

    func testCybridLocalizationKeyEquatable() {

        // Given
        let keyA = CybridLocalizationKey.cryptoPriceList(.headerCurrency)
        let keyB = CybridLocalizationKey.cryptoPriceList(.headerPrice)

        // When
        let isEqual = keyA == keyB

        // Then
        XCTAssertFalse(isEqual)
    }

    func testCybridLocalizer_withNoParameters() {

        // Given
        let key = CybridLocalizationKey.cryptoPriceList(.headerCurrency)
        let localizer = CybridLocalizer()

        // When
        let localizedString = localizer.localize(with: key)

        // Then
        XCTAssertFalse(localizedString.isEmpty)
        XCTAssertNotEqual(localizedString, key.stringValue)
    }

    func testCybridLocalizer_String_Key_withNoParameters() {

        // Given
        let key = "cybrid.cryptoPriceList.headerCurrency"
        let localizer = CybridLocalizer()

        // When
        let localizedString = localizer.localize(with: key)

        // Then
        XCTAssertFalse(localizedString.isEmpty)
        XCTAssertNotEqual(localizedString, key.stringValue)
    }

    func testCybridLocalizer_inEnglish() {

        // Given
        let key = CybridLocalizationKey.cryptoPriceList(.headerCurrency)
        let localizer = CybridLocalizer(locale: Locale(identifier: "en_US"))

        // When
        let localizedString = localizer.localize(with: key)

        // Then
        XCTAssertEqual(localizedString.stringValue, "Currency")
    }

    func testCybridLocalizer_inFrench() {

        // Given
        let key = CybridLocalizationKey.cryptoPriceList(.headerCurrency)
        let localizer = CybridLocalizer(locale: Locale(identifier: "fr_CA"))

        // When
        let localizedString = localizer.localize(with: key)

        // Then
        XCTAssertEqual(localizedString.stringValue, "Devise")
    }

    func testCybridLocalizer_keys() {

        XCTAssertEqual(CybridLocalizationKey.cryptoPriceList(.headerCurrency).stringValue, "cybrid.cryptoPriceList.headerCurrency")
        XCTAssertEqual(CybridLocalizationKey.trade(.buy(.amount)).stringValue, "cybrid.trade.buy.amount")
        XCTAssertEqual(CybridLocalizationKey.trade(.sell(.title)).stringValue, "cybrid.trade.sell.title")
        XCTAssertEqual(CybridLocalizationKey.trade(.confirmationModal(.title)).stringValue, "cybrid.trade.confirmationModal.title")
        XCTAssertEqual(CybridLocalizationKey.trade(.successModal(.title)).stringValue, "cybrid.trade.successModal.title")
        XCTAssertEqual(CybridLocalizationKey.trade(.loadingModal(.processingMessage)).stringValue, "cybrid.trade.loadingModal.processingMessage")
        XCTAssertNotEqual(CybridLocalizationKey.trade(.successModal(.title)),
        CybridLocalizationKey.trade(.confirmationModal(.title)))
    }
}
