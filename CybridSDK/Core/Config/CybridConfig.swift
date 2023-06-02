//
//  Cybrid.swift
//  CybridSDK
//
//  Created by Cybrid on 22/06/22.
//

import CybridApiBankSwift
import Foundation

public final class CybridConfig {

    // MARK: Base URL's for API's
    static let baseBankApiUrl: String = "https://bank.%@.cybrid.app"
    static let baseIdpApiUrl: String = "https://id.%@.cybrid.app"

    // MARK: Internal Static Properties
    internal static var shared = CybridConfig()

    // MARK: Internal Properties
    internal var logger: CybridLogger?
    internal var refreshRate: TimeInterval = 5
    internal lazy var session: CybridSession = .current
    internal var theme: Theme = CybridTheme.default
    internal let assetsURL: String = "https://images.cybrid.xyz/sdk/assets/"

    // MARK: Interal Properties + Private Set
    internal private(set) var customerGuid: String = ""
    internal private(set) var bearer: String = ""

    // MARK: Propertis for Auto Init
    internal var dataProvider: (AssetsRepoProvider)?
    internal private(set) var fiat: AssetBankModel = FiatConfig.usd.defaultAsset
    internal private(set) var customer: CustomerBankModel?
    internal private(set) var bank: BankBankModel?
    internal var assets: [AssetBankModel] = []
    internal private(set) var autoLoadComplete = false
    internal private(set) var completion: (() -> Void)?

    // MARK: Private Properties
    private var _preferredLocale: Locale?

    // MARK: Public Methods
    public func setup(sdkConfig: SDKConfig,
                      locale: Locale? = nil,
                      logger: CybridLogger? = nil,
                      refreshRate: TimeInterval = 5,
                      theme: Theme? = nil,
                      completion: (() -> Void)?
    ) {

        self.bearer = sdkConfig.bearer
        self.customerGuid = sdkConfig.customerGuid
        self.customer = sdkConfig.customer
        self.bank = sdkConfig.bank
        self.theme = theme ?? CybridTheme.default
        self.refreshRate = refreshRate
        self._preferredLocale = locale
        self.logger = logger
        self.dataProvider = CybridSession.current
        self.completion = completion
        self.session.setupSession(authToken: self.bearer)
        CybridApiBankSwiftAPI.basePath = sdkConfig.environment.baseBankPath
        CodableHelper.jsonDecoder = CybridJSONDecoder()
        self.autoLoad()
    }

    internal func setup(sdkConfig: SDKConfig,
                        locale: Locale? = nil,
                        logger: CybridLogger? = nil,
                        refreshRate: TimeInterval = 5,
                        theme: Theme? = nil,
                        dataProvider: AssetsRepoProvider,
                        completion: (() -> Void)?
    ) {

        self.bearer = sdkConfig.bearer
        self.customerGuid = sdkConfig.customerGuid
        self.customer = sdkConfig.customer
        self.bank = sdkConfig.bank
        self.theme = theme ?? CybridTheme.default
        self.refreshRate = refreshRate
        self._preferredLocale = locale
        self.logger = logger
        self.dataProvider = dataProvider
        self.completion = completion
        self.session.setupSession(authToken: self.bearer)
        CybridApiBankSwiftAPI.basePath = sdkConfig.environment.baseBankPath
        CodableHelper.jsonDecoder = CybridJSONDecoder()
        self.autoLoad()
    }

    public func startListeners() {
        session.setupEventListeners()
    }

    public func stopListeners() {
        session.stopListeners()
    }
}

// MARK: CybridConfig + Auto Init
extension CybridConfig {

    public func refreshBearer(bearer: String) {
        self.bearer = bearer
    }

    internal func autoLoad() {

        // -- Fetch assets
        self.fetchAssets {

            self.autoLoadComplete = true
            self.completion?()
        }
    }

    internal func fetchAssets(_ completion: @escaping () -> Void) {

        if self.assets.isEmpty {
            self.dataProvider!.fetchAssetsList { [self] assetsResponse in
                switch assetsResponse {
                case .success(let assets):

                    let defaultAssetCode = self.bank?.supportedFiatAccountAssets?.first
                    self.assets = assets
                    self.fiat = assets.first(where: { $0.code == defaultAssetCode }) ?? FiatConfig.usd.defaultAsset
                    completion()

                case .failure:
                    self.logger?.log(.component(.accounts(.pricesDataError)))
                }
            }
        } else {
            completion()
        }
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
