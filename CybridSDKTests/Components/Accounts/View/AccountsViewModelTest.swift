//
//  AccountsViewModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 07/03/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class AccountsViewModelTest: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func createViewModel() -> AccountsViewModel {

        return AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")
    }

    func test_init() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.currentCurrency, "USD")
        XCTAssertEqual(viewModel.uiState.value, AccountsViewController.ViewState.LOADING)
    }

    func test_getAssetsList_Successfully() async {

        // -- Given
        let viewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")

        // -- When
        dataProvider.didFetchAssetsSuccessfully()
        let assets = await viewModel.getAssetsList()

        // -- Then
        XCTAssertNotEqual(assets, [])
    }

    func test_getAccounts_Successfully() async {
        
        runAsync

        // -- Given
        let viewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")

        // -- When
        dataProvider.didFetchAssetsSuccessfully()
        dataProvider.didFetchAccountsSuccessfully()
        dataProvider.didFetchPricesSuccessfully()
        viewModel.getAccounts()

        // -- Then
        XCTAssertFalse(viewModel.balances.value.isEmpty)
    }
}
