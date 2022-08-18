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
    XCTAssertEqual(Cybrid.theme.fontTheme, CybridTheme.default.fontTheme)

    let testTheme = CybridTheme(
      colorTheme: .default,
      fontTheme: FontTheme(header: .systemFont(ofSize: 32),
                           bodyLarge: .systemFont(ofSize: 20),
                           body: .systemFont(ofSize: 16),
                           bodyStrong: .systemFont(ofSize: 16),
                           caption: .systemFont(ofSize: 12))
    )
    Cybrid.setup(authenticator: MockAuthenticator(), theme: testTheme)

    XCTAssertEqual(Cybrid.theme.fontTheme, testTheme.fontTheme)
  }

  func testCybrid_configSetup_withoutPassingTheme() {
    Cybrid.setup(authenticator: MockAuthenticator())

    XCTAssertEqual(Cybrid.theme.colorTheme, CybridTheme.default.colorTheme)
    XCTAssertEqual(Cybrid.theme.fontTheme, CybridTheme.default.fontTheme)
  }

  func testCybrid_supportsLanguage() {
    // Given
    let supportsFrench = Cybrid.supportsLanguage("fr")
    let supportsEnglish = Cybrid.supportsLanguage("en")
    let supportsSpanish = Cybrid.supportsLanguage("es")
    let supportsJapanese = Cybrid.supportsLanguage("jp")
    let supportsNilLanguage = Cybrid.supportsLanguage(nil)

    // Then
    XCTAssertTrue(supportsEnglish)
    XCTAssertTrue(supportsFrench)
    XCTAssertFalse(supportsSpanish)
    XCTAssertFalse(supportsJapanese)
    XCTAssertFalse(supportsNilLanguage)
  }

  func testCybrid_supportsLocale() {
    // Given
    let frenchCanadian = Locale(identifier: "fr_CA")
    let frenchFrench = Locale(identifier: "fr_FR")
    let englishUS = Locale(identifier: "en_US")
    let englishUK = Locale(identifier: "en_GB")
    let spanishSpain = Locale(identifier: "es_ES")
    let spanishPeru = Locale(identifier: "es_PE")

    // Then
    XCTAssertTrue(Cybrid.supportsLocale(frenchCanadian))
    XCTAssertTrue(Cybrid.supportsLocale(frenchFrench))
    XCTAssertTrue(Cybrid.supportsLocale(englishUS))
    XCTAssertTrue(Cybrid.supportsLocale(englishUK))
    XCTAssertFalse(Cybrid.supportsLocale(spanishSpain))
    XCTAssertFalse(Cybrid.supportsLocale(spanishPeru))
  }

  func testCybrid_getPreferredLocale_Default() {
    // Given
    Cybrid.setup(authenticator: MockAuthenticator(), locale: nil, theme: Cybrid.theme)
    /// Default locale in local Simulator is `en-US`, while in CI it's `en`
    let possiblePreferredLocales = ["en", "en-US", "en-CA"]

    // When
    let preferredLocale = Cybrid.getPreferredLocale()

    // Then
    XCTAssertTrue(possiblePreferredLocales.contains(preferredLocale.identifier))
  }

  func testCybrid_getPreferredLocale_withoutCustomLocale() {
    // Given
    Cybrid.setup(authenticator: MockAuthenticator(), locale: nil, theme: Cybrid.theme)
    let preferredLanguages = ["en-US", "fr-CA"]

    // When
    let preferredLocale = Cybrid.getPreferredLocale(with: preferredLanguages)

    // Then
    XCTAssertEqual(preferredLocale.identifier, "en-US")
  }

  func testCybrid_getPreferredLocale_withCustomLocale_Supported() {
    // Given
    Cybrid.setup(authenticator: MockAuthenticator(), locale: Locale(identifier: "fr-CA"), theme: Cybrid.theme)
    let preferredLanguages = ["en-US", "fr-CA"]

    // When
    let preferredLocale = Cybrid.getPreferredLocale(with: preferredLanguages)

    // Then
    XCTAssertEqual(preferredLocale.identifier, "fr-CA")
  }

  func testCybrid_getPreferredLocale_withCustomLocale_Unsupported() {
    // Given
    Cybrid.setup(authenticator: MockAuthenticator(), locale: Locale(identifier: "es-PE"), theme: Cybrid.theme)
    let preferredLanguages = ["en-US", "fr-CA"]

    // When
    let preferredLocale = Cybrid.getPreferredLocale(with: preferredLanguages)

    // Then
    XCTAssertEqual(preferredLocale.identifier, "en-US")
  }

  func testCybrid_getPreferredLocale_withNoPreferredLanguages() {
    // Given
    Cybrid.setup(authenticator: MockAuthenticator(), locale: nil, theme: Cybrid.theme)
    let preferredLanguages: [String] = []

    // When
    let preferredLocale = Cybrid.getPreferredLocale(with: preferredLanguages)

    // Then
    XCTAssertEqual(preferredLocale.languageCode, "en")
  }

  func testCybrid_startListeners() {
    // Given
    let authenticator = MockAuthenticator()
    Cybrid.setup(authenticator: authenticator, locale: nil, theme: Cybrid.theme)
    let notificationManager = NotificationCenterMock()
    Cybrid.session = CybridSession(authenticator: authenticator,
                                   apiManager: MockAPIManager.self,
                                   notificationManager: notificationManager)

    // When
    Cybrid.startListeners()

    // Then
    XCTAssertEqual(notificationManager.observers.count, 2)
  }

  func testCybrid_stopListeners() {
    // Given
    let authenticator = MockAuthenticator()
    Cybrid.setup(authenticator: authenticator, locale: nil, theme: Cybrid.theme)
    let notificationManager = NotificationCenterMock()
    Cybrid.session = CybridSession(authenticator: authenticator,
                                   apiManager: MockAPIManager.self,
                                   notificationManager: notificationManager)

    // When
    Cybrid.startListeners()
    Cybrid.stopListeners()

    // Then
    XCTAssertTrue(notificationManager.observers.isEmpty)
  }
}
