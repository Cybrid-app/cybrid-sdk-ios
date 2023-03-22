//
//  Cybrid.swift
//  CybridSDK
//
//  Created by Cybrid on 22/06/22.
//

import CybridApiBankSwift
import Foundation

public final class CybridConfig {

    static let baseUrl: String = "https://bank.%@.cybrid.app"

    // MARK: Internal Static Properties
    internal static var shared = CybridConfig()

    // MARK: Internal Properties
    internal var logger: CybridLogger?
    internal var refreshRate: TimeInterval = 5
    internal lazy var session: CybridSession = .current
    internal var theme: Theme = CybridTheme.default
    internal let assetsURL: String = "https://images.cybrid.xyz/sdk/assets/"

    // MARK: Interal Properties + Private Set
    internal private(set) var customerGUID: String = ""
    internal private(set) var bearer: String = ""

    // MARK: Propertis for Auto Init
    internal private(set) weak var delegate: CybridDelegate?
    internal private(set) var fiat: AssetBankModel = FiatConfig.usd.defaultAsset
    internal var dataProvider: (CustomersRepoProvider & BankProvider & AssetsRepoProvider)?
    internal private(set) var customer: CustomerBankModel?
    internal private(set) var bank: BankBankModel?
    internal var assets: [AssetBankModel] = []

    // MARK: Private Properties
    private var _preferredLocale: Locale?

    // MARK: Public Methods
    public func setup(bearer: String,
                      customerGUID: String,
                      environment: CybridEnvironment = .sandbox,
                      locale: Locale? = nil,
                      logger: CybridLogger? = nil,
                      refreshRate: TimeInterval = 5,
                      theme: Theme? = nil,
                      delegate: CybridDelegate) {

        self.bearer = bearer
        self.customerGUID = customerGUID
        self.theme = theme ?? CybridTheme.default
        self.refreshRate = refreshRate
        self._preferredLocale = locale
        self.logger = logger
        self.dataProvider = CybridSession.current
        self.delegate = delegate
        self.session.setupSession(authToken: self.bearer)
        CybridApiBankSwiftAPI.basePath = environment.basePath
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

// MARK: CybridConfig + Auto Init

extension CybridConfig {

    public func refreshBearer(bearer: String) {
        self.bearer = bearer
    }

    internal func overrideDataProvider(dataProvider: CustomersRepoProvider & BankProvider & AssetsRepoProvider) {
        self.dataProvider = dataProvider
    }

    private func autoLoad() {

        // -- 1. Fetch Customer or check if exists
        self.fetchCustomer { [self] _ in

            // -- 2. Fetch Bank or check if exists
            self.fetchBank { _ in

                // -- 3. Fetch Assets
                self.fetchAssets { _ in

                    // -- 4. SDK Ready
                    self.delegate?.onSDKReady()
                }
            }
        }
    }

    private func fetchCustomer(_ completion: @escaping (_ ready: Bool) -> Void) {

        if self.customer == nil {
            self.dataProvider!.getCustomer(customerGuid: self.customerGUID) { [self] customerResponse in
                switch customerResponse {
                case .success(let customer):
                    self.customer = customer
                    completion(true)
                case .failure:
                    self.logger?.log(.component(.accounts(.pricesDataError)))
                }
            }
        } else {
            completion(true)
        }
    }

    private func fetchBank(_ completion: @escaping (_ ready: Bool) -> Void) {

        if self.bank == nil {
            self.dataProvider!.fetchBank(guid: (self.customer?.bankGuid)!) { [self] bankResponse in
                switch bankResponse {
                case .success(let bank):
                    self.bank = bank
                    completion(true)
                case .failure:
                    self.logger?.log(.component(.accounts(.pricesDataError)))
                }
            }
        } else {
            completion(true)
        }
    }

    private func fetchAssets(_ completion: @escaping (_ ready: Bool) -> Void) {

        if self.assets.isEmpty {
            self.dataProvider!.fetchAssetsList { [self] assetsResponse in
                switch assetsResponse {
                case .success(let assets):

                    let defaultAssetCode = self.bank?.supportedFiatAccountAssets![0] ?? "USD"
                    self.assets = assets
                    self.fiat = assets.first(where: { $0.code == defaultAssetCode }) ?? FiatConfig.usd.defaultAsset
                    completion(true)

                case .failure:
                    self.logger?.log(.component(.accounts(.pricesDataError)))
                }
            }
        } else {
            completion(true)
        }
    }
}

// MARK: Protocol
public protocol CybridDelegate: AnyObject {
    func onSDKReady()
}
