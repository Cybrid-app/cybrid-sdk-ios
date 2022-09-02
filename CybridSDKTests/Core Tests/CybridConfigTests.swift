//
//  CybridSDKTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 22/06/22.
//

@testable import CybridSDK
import XCTest

class CybridConfigTests: XCTestCase {

  func testCybrid_configSetup() {
    let cybridConfig = CybridConfig()
    XCTAssertEqual(cybridConfig.theme.fontTheme, CybridTheme.default.fontTheme)

    let testTheme = CybridTheme(
      colorTheme: .default,
      fontTheme: FontTheme(header1: .systemFont(ofSize: 32),
                           header2: .systemFont(ofSize: 20),
                           body: .systemFont(ofSize: 16),
                           body2: .systemFont(ofSize: 16),
                           caption: .systemFont(ofSize: 12))
    )
    cybridConfig.setup(authenticator: MockAuthenticator(), customerGUID: "MOCK_GUID", theme: testTheme)

    XCTAssertEqual(cybridConfig.theme.fontTheme, testTheme.fontTheme)
  }

  func testCybrid_configSetup_withoutPassingTheme() {
    let cybridConfig = CybridConfig()
    cybridConfig.setup(authenticator: MockAuthenticator(), customerGUID: "MOCK_GUID")

    XCTAssertEqual(cybridConfig.theme.colorTheme, CybridTheme.default.colorTheme)
    XCTAssertEqual(cybridConfig.theme.fontTheme, CybridTheme.default.fontTheme)
  }

  func testCybrid_supportsLanguage() {
    // Given
    let cybridConfig = CybridConfig()
    let supportsFrench = cybridConfig.supportsLanguage("fr")
    let supportsEnglish = cybridConfig.supportsLanguage("en")
    let supportsSpanish = cybridConfig.supportsLanguage("es")
    let supportsJapanese = cybridConfig.supportsLanguage("jp")
    let supportsNilLanguage = cybridConfig.supportsLanguage(nil)

    // Then
    XCTAssertTrue(supportsEnglish)
    XCTAssertTrue(supportsFrench)
    XCTAssertFalse(supportsSpanish)
    XCTAssertFalse(supportsJapanese)
    XCTAssertFalse(supportsNilLanguage)
  }

  func testCybrid_supportsLocale() {
    // Given
    let cybridConfig = CybridConfig()
    let frenchCanadian = Locale(identifier: "fr_CA")
    let frenchFrench = Locale(identifier: "fr_FR")
    let englishUS = Locale(identifier: "en_US")
    let englishUK = Locale(identifier: "en_GB")
    let spanishSpain = Locale(identifier: "es_ES")
    let spanishPeru = Locale(identifier: "es_PE")

    // Then
    XCTAssertTrue(cybridConfig.supportsLocale(frenchCanadian))
    XCTAssertTrue(cybridConfig.supportsLocale(frenchFrench))
    XCTAssertTrue(cybridConfig.supportsLocale(englishUS))
    XCTAssertTrue(cybridConfig.supportsLocale(englishUK))
    XCTAssertFalse(cybridConfig.supportsLocale(spanishSpain))
    XCTAssertFalse(cybridConfig.supportsLocale(spanishPeru))
  }

  func testCybrid_getPreferredLocale_Default() {
    // Given
    let cybridConfig = CybridConfig()
    cybridConfig.setup(authenticator: MockAuthenticator(), customerGUID: "MOCK_GUID", locale: nil, theme: cybridConfig.theme)
    /// Default locale in local Simulator is `en-US`, while in CI it's `en`
    let possiblePreferredLocales = ["en", "en-US", "en-CA"]

    // When
    let preferredLocale = cybridConfig.getPreferredLocale()

    // Then
    XCTAssertTrue(possiblePreferredLocales.contains(preferredLocale.identifier))
  }

  func testCybrid_getPreferredLocale_withoutCustomLocale() {
    // Given
    let cybridConfig = CybridConfig()
    cybridConfig.setup(authenticator: MockAuthenticator(), customerGUID: "MOCK_GUID", locale: nil)
    let preferredLanguages = ["en-US", "fr-CA"]

    // When
    let preferredLocale = cybridConfig.getPreferredLocale(with: preferredLanguages)

    // Then
    XCTAssertEqual(preferredLocale.identifier, "en-US")
  }

  func testCybrid_getPreferredLocale_withCustomLocale_Supported() {
    // Given
    let cybridConfig = CybridConfig()
    cybridConfig.setup(authenticator: MockAuthenticator(), customerGUID: "MOCK_GUID", locale: Locale(identifier: "fr-CA"))
    let preferredLanguages = ["en-US", "fr-CA"]

    // When
    let preferredLocale = cybridConfig.getPreferredLocale(with: preferredLanguages)

    // Then
    XCTAssertEqual(preferredLocale.identifier, "fr-CA")
  }

  func testCybrid_getPreferredLocale_withCustomLocale_Unsupported() {
    // Given
    let cybridConfig = CybridConfig()
    cybridConfig.setup(authenticator: MockAuthenticator(), customerGUID: "MOCK_GUID", locale: Locale(identifier: "es-PE"))
    let preferredLanguages = ["en-US", "fr-CA"]

    // When
    let preferredLocale = cybridConfig.getPreferredLocale(with: preferredLanguages)

    // Then
    XCTAssertEqual(preferredLocale.identifier, "en-US")
  }

  func testCybrid_getPreferredLocale_withNoPreferredLanguages() {
    // Given
    let cybridConfig = CybridConfig()
    cybridConfig.setup(authenticator: MockAuthenticator(), customerGUID: "MOCK_GUID", locale: nil)
    let preferredLanguages: [String] = []

    // When
    let preferredLocale = cybridConfig.getPreferredLocale(with: preferredLanguages)

    // Then
    XCTAssertEqual(preferredLocale.languageCode, "en")
  }

  func testCybrid_getFiat() {
    // Given
    let cybridConfig = CybridConfig()
    cybridConfig.setup(authenticator: MockAuthenticator(), customerGUID: "MOCK_GUID", fiat: .cad, locale: nil)

    // Then
    XCTAssertEqual(cybridConfig.fiat.defaultAsset.code, "CAD")

    // When
    cybridConfig.setup(authenticator: MockAuthenticator(), customerGUID: "MOCK_GUID", fiat: .usd, locale: nil)

    // Then
    XCTAssertEqual(cybridConfig.fiat.defaultAsset.code, "USD")
  }

  func testCybrid_startListeners() {
    // Given
    let cybridConfig = CybridConfig()
    let authenticator = MockAuthenticator()
    cybridConfig.setup(authenticator: authenticator, customerGUID: "MOCK_GUID", locale: nil)
    let notificationManager = NotificationCenterMock()
    cybridConfig.session = CybridSession(authenticator: authenticator,
                                         apiManager: MockAPIManager.self,
                                         notificationManager: notificationManager)

    // When
    cybridConfig.startListeners()

    // Then
    XCTAssertEqual(notificationManager.observers.count, 2)
  }

  func testCybrid_stopListeners() {
    // Given
    let cybridConfig = CybridConfig()
    let authenticator = MockAuthenticator()
    cybridConfig.setup(authenticator: authenticator, customerGUID: "MOCK_GUID", locale: nil)
    let notificationManager = NotificationCenterMock()
    cybridConfig.session = CybridSession(authenticator: authenticator,
                                         apiManager: MockAPIManager.self,
                                         notificationManager: notificationManager)

    // When
    cybridConfig.startListeners()
    cybridConfig.stopListeners()

    // Then
    XCTAssertTrue(notificationManager.observers.isEmpty)
  }
}
