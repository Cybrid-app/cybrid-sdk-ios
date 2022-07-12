//
//  Cybrid.swift
//  CybridSDK
//
//  Created by Cybrid on 22/06/22.
//

import CybridApiBankSwift
import Foundation

// swiftlint:disable identifier_name
/// Reference to `CybridConfig.shared` for quick bootstrapping.
public let Cybrid = CybridConfig.shared

public final class CybridConfig {
  // MARK: Internal Static Properties
  static var shared = CybridConfig()

  // MARK: Internal Properties
  var authenticator: CybridAuthenticator?
  var theme: Theme = CybridTheme.default
  let assetsURL: String = "https://images.cybrid.xyz/sdk/assets/"

  // MARK: Private Properties
  private var _preferredLocale: Locale?

  // MARK: Public Methods
  public func setup(environment: CybridEnvironment = .sandbox,
                    authenticator: CybridAuthenticator,
                    _ theme: Theme? = nil,
                    locale: Locale? = nil) {
    self.authenticator = authenticator
    self.theme = theme ?? CybridTheme.default
    self._preferredLocale = locale
    CybridApiBankSwiftAPI.basePath = environment.basePath
  }
}
// swiftlint:enable identifier_name

// MARK: - CybridConfig + Locale

extension CybridConfig {
  func getPreferredLocale(with preferredLanguages: [String]? = nil) -> Locale {
    /// If developer overrides the Locale,
    /// And the locale is supported by our SDK
    /// We pick the developer's locale
    if
      let preferredLocale = _preferredLocale,
      self.supportsLocale(preferredLocale)
    {
      return preferredLocale
    }
    let languages = preferredLanguages ?? Locale.preferredLanguages
    guard let preferredId = languages.first else {
      return .current
    }
    return Locale(identifier: preferredId)
  }

  func supportsLocale(_ locale: Locale) -> Bool {
    return supportsLanguage(locale.languageCode)
  }

  func supportsLanguage(_ languageCode: String?) -> Bool {
    guard let languageCode = languageCode else { return false }
    let sdkBundle = Bundle(for: CybridConfig.self)
    let localeBundlePath = sdkBundle.path(
      forResource: languageCode,
      ofType: "lproj"
    )
    return localeBundlePath != nil
  }
}
