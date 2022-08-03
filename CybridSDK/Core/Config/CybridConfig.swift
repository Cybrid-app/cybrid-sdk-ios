//
//  Cybrid.swift
//  CybridSDK
//
//  Created by Cybrid on 22/06/22.
//

import CybridApiBankSwift
import Foundation

public final class CybridConfig {
  // MARK: Internal Static Properties
  internal static var shared = CybridConfig()

  // MARK: Internal Properties
  internal var authenticator: CybridAuthenticator?
  internal var logger: CybridLogger?
  internal var refreshRate: TimeInterval = 5
  internal lazy var session: CybridSession = .current
  internal var theme: Theme = CybridTheme.default
  internal let assetsURL: String = "https://images.cybrid.xyz/sdk/assets/"

  // MARK: Private Properties
  private var _preferredLocale: Locale?

  // MARK: Public Methods
  /// Setup CybridSDK Configuration
  public func setup(environment: CybridEnvironment = .sandbox,
                    authenticator: CybridAuthenticator,
                    theme: Theme? = nil,
                    locale: Locale? = nil,
                    refreshRate: TimeInterval = 5,
                    logger: CybridLogger? = nil) {
    self.authenticator = authenticator
    self.theme = theme ?? CybridTheme.default
    self.refreshRate = refreshRate
    self._preferredLocale = locale
    self.logger = logger
    CybridApiBankSwiftAPI.basePath = environment.basePath
    CodableHelper.jsonDecoder = CybridJSONDecoder()
  }

  /// Setup NotificationCenter Observers.
  /// This is meant for manual use only. Observers are initialized by default with Cybrid's Session.
  public func startListeners() {
    session.setupEventListeners()
  }

  /// Removes NotificationCenter Observers.
  public func stopListeners() {
    session.stopListeners()
  }
}

// MARK: - CybridConfig + Locale

extension CybridConfig {
  /// Returns user preferred locale
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
