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
    internal var customerGUID: String = ""
    internal var logger: CybridLogger?
    internal var refreshRate: TimeInterval = 5
    internal lazy var session: CybridSession = .current
    internal var theme: Theme = CybridTheme.default
    internal let assetsURL: String = "https://images.cybrid.xyz/sdk/assets/"
    internal var fiat: FiatConfig = .usd
    internal var bearer: String = ""

    // MARK: Private Properties
    private var _preferredLocale: Locale?

    // MARK: Public Methods
    public func setup(bearer: String,
                      customerGUID: String,
                      environment: CybridEnvironment = .sandbox,
                      fiat: FiatConfig = .cad,
                      locale: Locale? = nil,
                      logger: CybridLogger? = nil,
                      refreshRate: TimeInterval = 5,
                      theme: Theme? = nil) {

        self.bearer = bearer
        self.customerGUID = customerGUID
        self.fiat = fiat
        self.theme = theme ?? CybridTheme.default
        self.refreshRate = refreshRate
        self._preferredLocale = locale
        self.logger = logger
        self.session.setupSession(authToken: self.bearer)
        CybridApiBankSwiftAPI.basePath = environment.basePath
        CodableHelper.jsonDecoder = CybridJSONDecoder()
    }

    public func startListeners() {
        session.setupEventListeners()
    }

    public func stopListeners() {
        session.stopListeners()
    }
}

// MARK: - CybridConfig + Locale

extension CybridConfig {

    func getPreferredLocale(with preferredLanguages: [String]? = nil) -> Locale {
        if
            let preferredLocale = _preferredLocale,
            self.supportsLocale(preferredLocale) {
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
