//
//  CybridSDKTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 22/06/22.
//

@testable import CybridSDK
import CybridApiBankSwift
import XCTest

class CybridConfigTests: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func test_setup() {

        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID")
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
        cybridConfig.setup(sdkConfig: sdkConfig,
                           theme: testTheme,
                           completion: {})
        XCTAssertEqual(cybridConfig.theme.fontTheme, testTheme.fontTheme)
    }

    func test_setup_internal() {

        let cybridConfig = CybridConfig()
        XCTAssertEqual(cybridConfig.theme.fontTheme, CybridTheme.default.fontTheme)

        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID")
        let testTheme = CybridTheme(
            colorTheme: .default,
            fontTheme: FontTheme(header1: .systemFont(ofSize: 32),
                                 header2: .systemFont(ofSize: 20),
                                 body: .systemFont(ofSize: 16),
                                 body2: .systemFont(ofSize: 16),
                                 caption: .systemFont(ofSize: 12))
        )

        // -- When
        cybridConfig.setup(sdkConfig: sdkConfig,
                           theme: testTheme,
                           dataProvider: dataProvider,
                           completion: {})

        // -- Then
        XCTAssertEqual(cybridConfig.theme.fontTheme, testTheme.fontTheme)
        XCTAssertNotNil(cybridConfig.dataProvider)
    }

    func testCybrid_configSetup_withoutPassingTheme() {

        let cybridConfig = CybridConfig()
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID")
        cybridConfig.setup(sdkConfig: sdkConfig,
                           completion: {})

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
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID")
        let cybridConfig = CybridConfig()
        cybridConfig.setup(sdkConfig: sdkConfig,
                           locale: nil,
                           theme: cybridConfig.theme,
                           completion: {})

        /// Default locale in local Simulator is `en-US`, while in CI it's `en`
        let possiblePreferredLocales = ["en", "en-US", "en-CA"]

        // When
        let preferredLocale = cybridConfig.getPreferredLocale()

        // Then
        XCTAssertTrue(possiblePreferredLocales.contains(preferredLocale.identifier))
    }

    func testCybrid_getPreferredLocale_withoutCustomLocale() {

        // Given
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID")
        let cybridConfig = CybridConfig()
        cybridConfig.setup(sdkConfig: sdkConfig,
                           locale: nil,
                           completion: {})
        let preferredLanguages = ["en-US", "fr-CA"]

        // When
        let preferredLocale = cybridConfig.getPreferredLocale(with: preferredLanguages)

        // Then
        XCTAssertEqual(preferredLocale.identifier, "en-US")
    }

    func testCybrid_getPreferredLocale_withCustomLocale_Supported() {

        // Given
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID")
        let cybridConfig = CybridConfig()
        cybridConfig.setup(sdkConfig: sdkConfig,
                           locale: Locale(identifier: "fr-CA"),
                           completion: {})
        let preferredLanguages = ["en-US", "fr-CA"]

        // When
        let preferredLocale = cybridConfig.getPreferredLocale(with: preferredLanguages)

        // Then
        XCTAssertEqual(preferredLocale.identifier, "fr-CA")
    }

    func testCybrid_getPreferredLocale_withCustomLocale_Unsupported() {

        // Given
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID")
        let cybridConfig = CybridConfig()
        cybridConfig.setup(sdkConfig: sdkConfig,
                           locale: Locale(identifier: "es-PE"),
                           completion: {})
        let preferredLanguages = ["en-US", "fr-CA"]

        // When
        let preferredLocale = cybridConfig.getPreferredLocale(with: preferredLanguages)

        // Then
        XCTAssertEqual(preferredLocale.identifier, "en-US")
    }

    func testCybrid_getPreferredLocale_withNoPreferredLanguages() {

        // Given
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID")
        let cybridConfig = CybridConfig()
        cybridConfig.setup(sdkConfig: sdkConfig,
                           locale: nil,
                           completion: {})
        let preferredLanguages: [String] = []

        // When
        let preferredLocale = cybridConfig.getPreferredLocale(with: preferredLanguages)

        // Then
        XCTAssertEqual(preferredLocale.languageCode, "en")
    }

    func testCybrid_startListeners() {

        // Given
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID")
        let cybridConfig = CybridConfig()
        cybridConfig.setup(sdkConfig: sdkConfig,
                           locale: nil,
                           completion: {})
        let notificationManager = NotificationCenterMock()
        cybridConfig.session = CybridSession(apiManager: MockAPIManager.self,
                                             notificationManager: notificationManager)

        // When
        cybridConfig.startListeners()

        // Then
        XCTAssertEqual(notificationManager.observers.count, 2)
    }

    func testCybrid_stopListeners() {

        // Given
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID")
        let cybridConfig = CybridConfig()
        cybridConfig.setup(sdkConfig: sdkConfig,
                           locale: nil,
                           completion: {})
        let notificationManager = NotificationCenterMock()
        cybridConfig.session = CybridSession(apiManager: MockAPIManager.self,
                                             notificationManager: notificationManager)

        // When
        cybridConfig.startListeners()
        cybridConfig.stopListeners()

        // Then
        XCTAssertTrue(notificationManager.observers.isEmpty)
    }

    // MARK: Auto Init tests
    func test_refreshBearer() {

        // -- Given
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID")
        let cybridConfig = CybridConfig()
        cybridConfig.setup(sdkConfig: sdkConfig,
                           completion: {})
        XCTAssertEqual(cybridConfig.bearer, "TEST-BEARER")

        // -- When
        cybridConfig.refreshBearer(bearer: "12345")

        // -- Then
        XCTAssertEqual(cybridConfig.bearer, "12345")
    }

    func test_autoLoad() {

        // -- Given
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID")
        let cybridConfig = CybridConfig()
        cybridConfig.setup(sdkConfig: sdkConfig,
                           dataProvider: dataProvider) {
            XCTAssertTrue(cybridConfig.autoLoadComplete)
        }

        // -- When
        self.dataProvider.didFetchAssetsSuccessfully()

        // -- Then
        XCTAssertNotNil(cybridConfig.completion)
    }

    func test_setCustomer() {

        // -- Given
        let customer = CustomerBankModel.mock
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID",
                                  customer: customer)
        let cybridConfig = CybridConfig()

        // -- When
        cybridConfig.setup(sdkConfig: sdkConfig,
                           dataProvider: dataProvider,
                           completion: {})

        // -- Then
        XCTAssertNotNil(cybridConfig.customer)
        XCTAssertEqual(customer, cybridConfig.customer)
    }

    func test_setBank() {

        // -- Given
        let bank = BankBankModel.mock()
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID",
                                  bank: bank)
        let cybridConfig = CybridConfig()

        // -- When
        cybridConfig.setup(sdkConfig: sdkConfig,
                           dataProvider: dataProvider,
                           completion: {})

        // -- Then
        XCTAssertNotNil(cybridConfig.bank)
        XCTAssertEqual(bank, cybridConfig.bank)
    }

    func test_setAssetsForCreateDepositAddres() {

        // -- Given
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID")
        let cybridConfig = CybridConfig()

        // -- When
        cybridConfig.setup(sdkConfig: sdkConfig,
                           dataProvider: dataProvider,
                           completion: {})

        // -- Then
        XCTAssertFalse(cybridConfig.assetsForDepositAddress.isEmpty)
        XCTAssertEqual(cybridConfig.assetsForDepositAddress.count, 7)
        XCTAssertTrue(cybridConfig.assetsForDepositAddress.contains("BTC"))
        XCTAssertTrue(cybridConfig.assetsForDepositAddress.contains("USDC"))
    }

    func test_setAssetsForCreateDepositAddre_Empty() {

        // -- Given
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID")
        let cybridConfig = CybridConfig()

        // -- When
        cybridConfig.setup(sdkConfig: sdkConfig,
                           dataProvider: dataProvider,
                           completion: {})

        // -- Then
        XCTAssertFalse(cybridConfig.assetsForDepositAddress.isEmpty)
        XCTAssertEqual(cybridConfig.assetsForDepositAddress.count, 7)
        XCTAssertTrue(cybridConfig.assetsForDepositAddress.contains("BTC"))
        XCTAssertTrue(cybridConfig.assetsForDepositAddress.contains("ETH"))
        XCTAssertTrue(cybridConfig.assetsForDepositAddress.contains("USDC"))
    }

    func test_fetchAssets() {

        // -- Given
        var assets: [AssetBankModel] = []
        let bank = BankBankModel.mock()
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID",
                                  bank: bank)
        let cybridConfig = CybridConfig()
        cybridConfig.setup(sdkConfig: sdkConfig,
                           dataProvider: dataProvider,
                           completion: {})

        // -- When/Then
        XCTAssertNotNil(cybridConfig.bank)
        cybridConfig.fetchAssets {

            assets = cybridConfig.assets
            XCTAssertFalse(cybridConfig.assets.isEmpty)
            XCTAssertEqual(cybridConfig.fiat.code, "USD")
            XCTAssertEqual(assets, cybridConfig.assets)
        }
        self.dataProvider.didFetchAssetsSuccessfully()
    }

    func test_fetchAssets_Bank_Without_FiatAssets() {

        // -- Given
        var assets: [AssetBankModel] = []
        let bank = BankBankModel.mock_without_fiat_assets()
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID",
                                  bank: bank)
        let cybridConfig = CybridConfig()
        cybridConfig.setup(sdkConfig: sdkConfig,
                           dataProvider: dataProvider,
                           completion: {})

        // -- When/Then
        cybridConfig.fetchAssets {

            assets = cybridConfig.assets
            XCTAssertFalse(cybridConfig.assets.isEmpty)
            XCTAssertEqual(cybridConfig.fiat.code, "USD")
            XCTAssertEqual(assets, cybridConfig.assets)
        }
        self.dataProvider.didFetchAssetsSuccessfully()
    }

    func test_fetchAssets_Bank_With_MXN_FiatAssets() {

        // -- Given
        var assets: [AssetBankModel] = []
        let bank = BankBankModel.mock_with_mxn_fiat_assets()
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID",
                                  bank: bank)
        let cybridConfig = CybridConfig()
        cybridConfig.setup(sdkConfig: sdkConfig,
                           dataProvider: dataProvider,
                           completion: {})

        // -- When/Then
        cybridConfig.fetchAssets {

            assets = cybridConfig.assets
            XCTAssertFalse(cybridConfig.assets.isEmpty)
            XCTAssertEqual(cybridConfig.fiat.code, "USD")
            XCTAssertEqual(assets, cybridConfig.assets)
        }
        self.dataProvider.didFetchAssetsSuccessfully()
    }

    func test_fetchAssets_Error() {

        // -- Given
        let bank = BankBankModel.mock()
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID",
                                  bank: bank)
        let cybridConfig = CybridConfig()

        // -- When
        cybridConfig.setup(sdkConfig: sdkConfig,
                           dataProvider: dataProvider,
                           completion: {})

        // -- Then
        XCTAssertNotNil(cybridConfig.bank)
        cybridConfig.fetchAssets {

            XCTAssertTrue(cybridConfig.assets.isEmpty)
            XCTAssertEqual(cybridConfig.fiat.code, "USD")
        }
        self.dataProvider.didFetchAssetsWithError()
    }

    func test_findAsset() {

        // -- Given
        let bank = BankBankModel.mock()
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID",
                                  bank: bank)
        let cybridConfig = CybridConfig()
        cybridConfig.setup(sdkConfig: sdkConfig,
                           dataProvider: dataProvider,
                           completion: {})
        let codeToFind = "USD"
        cybridConfig.assets = AssetBankModel.mock

        // -- When/Then
        do {
            let foundAsset = try cybridConfig.findAsset(code: codeToFind)
            XCTAssertEqual(foundAsset.code, codeToFind)
        } catch {
            XCTFail("Shouldn't have error: \(error)")
        }
    }

    func test_findAsset_Throw() {

        // -- Given
        let bank = BankBankModel.mock()
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID",
                                  bank: bank)
        let cybridConfig = CybridConfig()
        cybridConfig.setup(sdkConfig: sdkConfig,
                           dataProvider: dataProvider,
                           completion: {})
        let codeToFind = "MXN"
        cybridConfig.assets = AssetBankModel.mock

        // -- When/Then
        XCTAssertThrowsError(try cybridConfig.findAsset(code: codeToFind)) { error in
            XCTAssertTrue(error is AssetNotFoundError, "The error type should be AssetNotFoundError")
        }
    }
}
