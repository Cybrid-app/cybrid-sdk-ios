//
//  TradeViewModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 01/11/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class TradeViewModelTest: TradeViewTest {

    func test_init() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.customerGuid.isEmpty)
        XCTAssertNil(viewModel.currentAsset.value)
        XCTAssertNil(viewModel.currentCounterAsset.value)
        XCTAssertNil(viewModel.currentAccountToTrade.value)
        XCTAssertNil(viewModel.currentAccountCounterToTrade.value)
        XCTAssertEqual(viewModel.currentAmountInput, "0")
        XCTAssertEqual(viewModel.currentAmountObservable.value, "")
        XCTAssertEqual(viewModel.currentAmountWithPrice.value, "0.0")
        XCTAssertEqual(viewModel.currentAmountWithPriceError.value, false)
        XCTAssertEqual(viewModel.currentMaxButtonHide.value, true)
        XCTAssertEqual(viewModel.uiState.value, .PRICES)
        XCTAssertEqual(viewModel.modalState.value, .LOADING)
        XCTAssertNil(viewModel.listPricesViewModel)
        XCTAssertTrue(viewModel.accountsOriginal.isEmpty)
        XCTAssertTrue(viewModel.accounts.isEmpty)
        XCTAssertTrue(viewModel.fiatAccounts.isEmpty)
        XCTAssertTrue(viewModel.tradingAccounts.isEmpty)
        XCTAssertNil(viewModel.quotePolling)
        XCTAssertNil(viewModel.currentQuote.value)
        XCTAssertNil(viewModel.currentTrade.value)
        XCTAssertEqual(viewModel.segmentSelection.value, .buy)
    }

    func test_onSelected() {

        // -- Given
        let viewModel = self.createViewModel()
        let asset = AssetBankModel.bitcoin
        let counterAsset = AssetBankModel.usd

        // -- When
        viewModel.onSelected(asset: asset, counterAsset: counterAsset)

        // -- Then
        XCTAssertEqual(viewModel.currentAsset.value, asset)
        XCTAssertEqual(viewModel.currentCounterAsset.value, counterAsset)
    }

    func test_fetchAccounts() {

        // -- Given
        let pricesViewModel = ListPricesViewModel(
            cellProvider: CryptoPriceMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            taskScheduler: TaskSchedulerMock())
        let viewModel = self.createViewModel()
        let asset = AssetBankModel.bitcoin
        let counterAsset = AssetBankModel.usd
        let accounts = [AccountBankModel.fiat, AccountBankModel.trading, AccountBankModel.tradingETH]
        let mockAccounts = AccountListBankModel(total: 3, page: 1, perPage: 3, objects: accounts)

        // -- Case: listPricesViewModel nil
        viewModel.listPricesViewModel = nil
        self.dataProvider.didFetchAccountsSuccessfully(mock: mockAccounts)
        viewModel.fetchAccounts()
        self.dataProvider.didFetchAccountsSuccessfully(mock: mockAccounts)
        XCTAssertEqual(viewModel.accountsOriginal, accounts)
        XCTAssertEqual(viewModel.accounts, [])

        // -- Case: [AccountAssetUIModel] are nil (ListPricesViewModel->assets are empty)
        pricesViewModel.assets = []
        viewModel.listPricesViewModel = pricesViewModel
        self.dataProvider.didFetchAccountsSuccessfully(mock: mockAccounts)
        viewModel.fetchAccounts()
        self.dataProvider.didFetchAccountsSuccessfully(mock: mockAccounts)
        XCTAssertEqual(viewModel.accountsOriginal, accounts)
        XCTAssertEqual(viewModel.accounts, [])

        // -- Case: [AccountAssetUIModel] are nil (account->asset as MXN)
        pricesViewModel.assets = AssetBankModel.mock
        viewModel.listPricesViewModel = pricesViewModel
        self.dataProvider.didFetchAccountsSuccessfully(mock: AccountListBankModel(total: 3, page: 1, perPage: 3, objects: [AccountBankModel.mockMxn]))
        viewModel.fetchAccounts()
        self.dataProvider.didFetchAccountsSuccessfully(mock: AccountListBankModel(total: 3, page: 1, perPage: 3, objects: [AccountBankModel.mockMxn]))
        XCTAssertEqual(viewModel.accountsOriginal, [AccountBankModel.mockMxn])
        XCTAssertEqual(viewModel.accounts, [])

        // -- Case: Good
        pricesViewModel.assets = AssetBankModel.mock
        viewModel.listPricesViewModel = pricesViewModel
        self.dataProvider.didFetchAccountsSuccessfully(mock: mockAccounts)
        viewModel.fetchAccounts()
        self.dataProvider.didFetchAccountsSuccessfully(mock: mockAccounts)
        XCTAssertEqual(viewModel.accountsOriginal, accounts)
        // XCTAssertEqual(viewModel.accounts, [])
        XCTAssertEqual(viewModel.accounts.count, 3)
        XCTAssertEqual(viewModel.fiatAccounts.count, 1)
        XCTAssertEqual(viewModel.tradingAccounts.count, 2)
        XCTAssertEqual(viewModel.uiState.value, .CONTENT)
    }

    func test_createTrade() {

        // -- Given
        let viewModel = self.createViewModel()
        let mockQuote = QuoteBankModel(guid: "1234")
        let mockTrade = TradeBankModel(guid: "1234")

        // -- When
        viewModel.currentQuote.value = mockQuote
        viewModel.currentAmountObservable.value = "1"
        self.dataProvider.didCreateTradeSuccessfully(mockTrade)
        viewModel.createTrade()
        self.dataProvider.didCreateTradeSuccessfully(mockTrade)

        // -- Then
        XCTAssertEqual(viewModel.currentTrade.value, mockTrade)
        XCTAssertEqual(viewModel.modalState.value, .SUCCESS)
        XCTAssertEqual(viewModel.currentAmountObservable.value, "")
    }
}
