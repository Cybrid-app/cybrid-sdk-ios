//
//  BundleExtensionsTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 7/07/22.
//

@testable import CybridSDK
import XCTest

class BundleExtensionsTests: XCTestCase {
  func testLocalizationBundle_forSupportedLanguage() {
    // Given: default bundle
    let sdkBundle = Bundle.sdkBundle

    // When: looking for supported language
    let localizationBundle = Bundle.localizationBundle(forLocale: Locale(identifier: "fr"))

    // Then: localizationBundle is not equal to defaultBundle
    XCTAssertNotEqual(localizationBundle, sdkBundle)
  }

  func testLocalizationBundle_forUnsupportedLanguage() {
    // Given: default bundle
    let sdkBundle = Bundle.sdkBundle

    // When: looking for unsupported language
    let localizationBundle = Bundle.localizationBundle(forLocale: Locale(identifier: "jp"))

    // Then: localizationBundle is equal to defaultBundle
    XCTAssertEqual(localizationBundle, sdkBundle)
  }
}
