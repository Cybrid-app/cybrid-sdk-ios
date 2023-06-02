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
                           completion: {}
        )

        // -- Then
        XCTAssertEqual(cybridConfig.theme.fontTheme, testTheme.fontTheme)
        XCTAssertNotNil(cybridConfig.dataProvider)
    }

    func testCybrid_configSetup_withoutPassingTheme() {

        let cybridConfig = CybridConfig()
        let sdkConfig = SDKConfig(environment: .staging,
                                  bearer: "TEST-BEARER",
                                  customerGuid: "MOCK_GUID")
        cybridConfig.setup(
            sdkConfig: sdkConfig,
            completion: {}
        )

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
        let cybridConfig = CybridConfig()
        cybridConfig.setup(
            bearer: "TEST-BEARER",
            customerGUID: "MOCK_GUID",
            locale: Locale(identifier: "es-PE"),
            completion: {}
        )
        let preferredLanguages = ["en-US", "fr-CA"]

        // When
        let preferredLocale = cybridConfig.getPreferredLocale(with: preferredLanguages)

        // Then
        XCTAssertEqual(preferredLocale.identifier, "en-US")
    }

    func testCybrid_getPreferredLocale_withNoPreferredLanguages() {

        // Given
        let cybridConfig = CybridConfig()
        cybridConfig.setup(
            bearer: "TEST-BEARER",
            customerGUID: "MOCK_GUID",
            locale: nil,
            completion: {}
        )
        let preferredLanguages: [String] = []

        // When
        let preferredLocale = cybridConfig.getPreferredLocale(with: preferredLanguages)

        // Then
        XCTAssertEqual(preferredLocale.languageCode, "en")
    }

    func testCybrid_startListeners() {

        // Given
        let cybridConfig = CybridConfig()
        cybridConfig.setup(
            bearer: "TEST-BEARER",
            customerGUID: "MOCK_GUID",
            locale: nil,
            completion: {}
        )
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
        let cybridConfig = CybridConfig()
        cybridConfig.setup(
            bearer: "TEST-BEARER",
            customerGUID: "MOCK_GUID",
            locale: nil,
            completion: {}
        )
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
        let cybridConfig = CybridConfig()
        cybridConfig.setup(
            bearer: "TEST-BEARER",
            customerGUID: "MOCK_GUID",
            completion: {}
        )
        XCTAssertEqual(cybridConfig.bearer, "TEST-BEARER")

        // -- When
        cybridConfig.refreshBearer(bearer: "12345")

        // -- Then
        XCTAssertEqual(cybridConfig.bearer, "12345")
    }

    func test_autoLoad() {

        // -- Given
        let cybridConfig = CybridConfig()
        cybridConfig.setup(
            bearer: "TEST-BEARER",
            customerGUID: "MOCK_GUID",
            dataProvider: dataProvider,
            completion: {
                XCTAssertTrue(cybridConfig.customerLoaded)
            }
        )

        // -- When
        self.dataProvider.didFetchCustomerSuccessfully()
        self.dataProvider.didFetchBankSuccessfully()
        self.dataProvider.didFetchAssetsSuccessfully()

        // -- Then
        XCTAssertNotNil(cybridConfig.completion)
    }

    func test_fetchCustomer() {

        // -- Given
        var customer: CustomerBankModel?
        let cybridConfig = CybridConfig()
        cybridConfig.setup(
            bearer: "TEST-BEARER",
            customerGUID: "MOCK_GUID",
            dataProvider: dataProvider,
            completion: {}
        )

        // -- When
        cybridConfig.fetchCustomer {

            XCTAssertNotNil(cybridConfig.customer)
            customer = cybridConfig.customer
        }
        dataProvider.didFetchCustomerSuccessfully()

        // -- When customer setted
        cybridConfig.fetchCustomer {

            XCTAssertNotNil(cybridConfig.customer)
            XCTAssertEqual(customer, cybridConfig.customer)
        }
    }

    func test_fetchCustomer_Error() {

        // -- Given
        let cybridConfig = CybridConfig()
        cybridConfig.setup(
            bearer: "TEST-BEARER",
            customerGUID: "MOCK_GUID",
            dataProvider: dataProvider,
            completion: {}
        )

        // -- When
        cybridConfig.fetchCustomer {

            XCTAssertNil(cybridConfig.customer)
        }
        dataProvider.didFetchCustomerFailed()
    }

    func test_fetchBank() {

        // -- Given
        var bank: BankBankModel?
        let cybridConfig = CybridConfig()
        cybridConfig.setup(
            bearer: "TEST-BEARER",
            customerGUID: "MOCK_GUID",
            dataProvider: dataProvider,
            completion: {}
        )

        // -- When
        cybridConfig.fetchCustomer {

            XCTAssertNotNil(cybridConfig.customer)
            cybridConfig.fetchBank {

                XCTAssertNotNil(cybridConfig.bank)
                bank = cybridConfig.bank
            }
            self.dataProvider.didFetchBankSuccessfully()
        }
        dataProvider.didFetchCustomerSuccessfully()

        // -- When bank setted
        cybridConfig.fetchBank {

            XCTAssertNotNil(cybridConfig.bank)
            XCTAssertEqual(bank, cybridConfig.bank)
        }
    }

    func test_fetchBank_Error() {

        // -- Given
        let cybridConfig = CybridConfig()
        cybridConfig.setup(
            bearer: "TEST-BEARER",
            customerGUID: "MOCK_GUID",
            dataProvider: dataProvider,
            completion: {}
        )

        // -- When
        cybridConfig.fetchCustomer {

            XCTAssertNotNil(cybridConfig.customer)
            cybridConfig.fetchBank {

                XCTAssertNil(cybridConfig.bank)
            }
            self.dataProvider.didFetchBankFailed()
        }
        dataProvider.didFetchCustomerSuccessfully()
    }

    func test_fetchAssets() {

        // -- Given
        var assets: [AssetBankModel] = []
        let cybridConfig = CybridConfig()
        cybridConfig.setup(
            bearer: "TEST-BEARER",
            customerGUID: "MOCK_GUID",
            dataProvider: dataProvider,
            completion: {}
        )

        // -- When
        cybridConfig.fetchCustomer {

            XCTAssertNotNil(cybridConfig.customer)
            cybridConfig.fetchBank {

                XCTAssertNotNil(cybridConfig.bank)
                cybridConfig.fetchAssets {

                    XCTAssertFalse(cybridConfig.assets.isEmpty)
                    XCTAssertEqual(cybridConfig.fiat.code, "USD")
                    assets = cybridConfig.assets
                }
                self.dataProvider.didFetchAssetsSuccessfully()
            }
            self.dataProvider.didFetchBankSuccessfully()
        }
        dataProvider.didFetchCustomerSuccessfully()

        // -- When bank setted
        cybridConfig.fetchAssets {

            XCTAssertFalse(cybridConfig.assets.isEmpty)
            XCTAssertEqual(assets, cybridConfig.assets)
        }
    }

    func test_fetchAssets_Bank_Without_FiatAssets() {

        // -- Given
        var assets: [AssetBankModel] = []
        let cybridConfig = CybridConfig()
        cybridConfig.setup(
            bearer: "TEST-BEARER",
            customerGUID: "MOCK_GUID",
            dataProvider: dataProvider,
            completion: {}
        )

        // -- When
        cybridConfig.fetchCustomer {

            XCTAssertNotNil(cybridConfig.customer)
            cybridConfig.fetchBank {

                XCTAssertNotNil(cybridConfig.bank)
                cybridConfig.fetchAssets {

                    XCTAssertFalse(cybridConfig.assets.isEmpty)
                    XCTAssertEqual(cybridConfig.fiat.code, "USD")
                    assets = cybridConfig.assets
                }
                self.dataProvider.didFetchAssetsSuccessfully()
            }
            self.dataProvider.didFetchBankSuccessfully_Without_Fiat_Assets()
        }
        dataProvider.didFetchCustomerSuccessfully()

        // -- When bank setted
        cybridConfig.fetchAssets {

            XCTAssertFalse(cybridConfig.assets.isEmpty)
            XCTAssertEqual(assets, cybridConfig.assets)
        }
    }

    func test_fetchAssets_Bank_With_MXN_FiatAssets() {

        // -- Given
        var assets: [AssetBankModel] = []
        let cybridConfig = CybridConfig()
        cybridConfig.setup(
            bearer: "TEST-BEARER",
            customerGUID: "MOCK_GUID",
            dataProvider: dataProvider,
            completion: {}
        )

        // -- When
        cybridConfig.fetchCustomer {

            XCTAssertNotNil(cybridConfig.customer)
            cybridConfig.fetchBank {

                XCTAssertNotNil(cybridConfig.bank)
                cybridConfig.fetchAssets {

                    XCTAssertFalse(cybridConfig.assets.isEmpty)
                    XCTAssertEqual(cybridConfig.fiat.code, "USD")
                    assets = cybridConfig.assets
                }
                self.dataProvider.didFetchAssetsSuccessfully()
            }
            self.dataProvider.didFetchBankSuccessfully_With_MXN_Fiat_Assets()
        }
        dataProvider.didFetchCustomerSuccessfully()

        // -- When bank setted
        cybridConfig.fetchAssets {

            XCTAssertFalse(cybridConfig.assets.isEmpty)
            XCTAssertEqual(assets, cybridConfig.assets)
        }
    }

    func test_fetchAssets_Error() {

        // -- Given
        let cybridConfig = CybridConfig()
        cybridConfig.setup(
            bearer: "TEST-BEARER",
            customerGUID: "MOCK_GUID",
            dataProvider: dataProvider,
            completion: {}
        )

        // -- When
        cybridConfig.fetchCustomer {

            XCTAssertNotNil(cybridConfig.customer)
            cybridConfig.fetchBank {

                XCTAssertNotNil(cybridConfig.bank)
                cybridConfig.fetchAssets {

                    XCTAssertTrue(cybridConfig.assets.isEmpty)
                    XCTAssertEqual(cybridConfig.fiat.code, "USD")
                }
                self.dataProvider.didFetchAssetsWithError()
            }
            self.dataProvider.didFetchBankSuccessfully()
        }
        dataProvider.didFetchCustomerSuccessfully()
    }
}
