//
//  AccountsViewModelTestError.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 07/03/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class AccountsViewModelErrorTest: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func createViewModel() -> AccountsViewModel {

        return AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")
    }

    func test_getAssetsList_Error() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.getAssetsList { ready in
            XCTAssertTrue(ready)
        }
        dataProvider.didFetchAssetsWithError()

        // -- Then
        XCTAssertEqual(viewModel.assets, [])
    }

    func test_getAccounts_Error() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.assets = AssetBankModel.cryptoAssets
        viewModel.getAccounts()
        dataProvider.didFetchAccountsWithError()

        // -- Then
        XCTAssertNil(viewModel.pricesPolling)
        XCTAssertEqual(viewModel.accounts, [])
    }

    func test_getPricesList_Error() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.getPricesList()
        dataProvider.didFetchPricesWithError()

        // -- Then
        XCTAssertEqual(viewModel.prices, [])
    }
}
