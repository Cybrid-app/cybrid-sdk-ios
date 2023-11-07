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
            dataProvider: self.dataProvider,
            logger: nil)
    }

    func createBalanceList() -> [BalanceUIModel] {

        let viewModel = self.createViewModel()
        let assets = AssetBankModel.cryptoAssets
        let accounts = AccountBankModel.mock
        let prices: [SymbolPriceBankModel] = .mockPrices
        return viewModel.buildModelList(assets: assets, accounts: accounts, prices: prices)
    }

    func test_init() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.uiState.value, AccountsView.State.LOADING)
    }

    func test_getAccounts_Successfully() async {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        dataProvider.didFetchAssetsSuccessfully()
        dataProvider.didFetchAccountsSuccessfully()
        viewModel.getAccounts()
        dataProvider.didFetchAccountsSuccessfully()

        // -- Then
        XCTAssertFalse(viewModel.accounts.isEmpty)
        XCTAssertNotNil(viewModel.pricesPolling)
    }

    func test_getPricesList() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        dataProvider.didFetchPricesSuccessfully(nil)
        viewModel.getPricesList()
        dataProvider.didFetchPricesSuccessfully(nil)

        // -- Then
        XCTAssertFalse(viewModel.prices.isEmpty)
    }

    func test_createAccountsFormatted() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.assets = AssetBankModel.cryptoAssets
        viewModel.accounts = AccountBankModel.mock
        viewModel.prices = .mockPrices
        viewModel.createAccountsFormatted()

        // -- Then
        XCTAssertFalse(viewModel.balances.value.isEmpty)
    }

    func test_createAccountsFormatted_With_Default_Case() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.assets = AssetBankModel.cryptoAssets
        viewModel.accounts = AccountBankModel.mockWithBackstopped
        viewModel.prices = .mockPrices
        viewModel.createAccountsFormatted()

        // -- Then
        XCTAssertFalse(viewModel.balances.value.isEmpty)
        XCTAssertTrue(viewModel.balances.value.count == 3)
    }

    func test_createAccountsFormatted_Order_Trading_Accounts() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.assets = AssetBankModel.cryptoAssets
        viewModel.accounts = AccountBankModel.mockWithBackstopped
        viewModel.prices = .mockPrices
        viewModel.createAccountsFormatted()

        // -- Then
        XCTAssertFalse(viewModel.balances.value.isEmpty)
        XCTAssertTrue(viewModel.balances.value.count == 3)
        XCTAssertTrue(viewModel.balances.value[0].account.asset == "USD")
        XCTAssertTrue(viewModel.balances.value[1].account.asset == "BTC")
        XCTAssertTrue(viewModel.balances.value[2].account.asset == "ETH")
    }

    func test_buildModelList() {

        // -- When
        let balances = self.createBalanceList()

        // -- Then
        XCTAssertFalse(balances.isEmpty)
    }

    func test_calculateTotalBalance() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.assets = AssetBankModel.mock
        viewModel.accounts = AccountBankModel.mock
        viewModel.prices = .mockPrices
        viewModel.createAccountsFormatted()
        viewModel.calculateTotalBalance()

        // -- Then
        XCTAssertFalse(viewModel.balances.value.isEmpty)
        XCTAssertEqual(viewModel.accountTotalBalance.value, "$40,040,397.82 USD")
    }
}
