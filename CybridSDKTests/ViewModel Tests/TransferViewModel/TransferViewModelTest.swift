//
//  TransferViewModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 27/12/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class TransferViewModelTest: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func createViewModel() -> TransferViewModel {
        return TransferViewModel(dataProvider: self.dataProvider,
                                     logger: nil)
    }

    func test_init() {

        // -- Given
        let uiState: Observable<TransferViewController.ViewState> = .init(.LOADING)
        let viewModel = createViewModel()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.uiState)
        XCTAssertEqual(viewModel.uiState.value, uiState.value)
        XCTAssertTrue(viewModel.assets.isEmpty)
        XCTAssertTrue(viewModel.accounts.value.isEmpty)
        XCTAssertTrue(viewModel.externalBankAccounts.value.isEmpty)
        XCTAssertTrue(viewModel.fiatBalance.value.isEmpty)
        XCTAssertNil(viewModel.currentQuote.value)
        // XCTAssertNil(viewModel.currentTrade.value)
        // XCTAssertEqual(viewModel.currentFiatCurrency, "USD")
    }

    /*func test_createTrade() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.didCreateTradeSuccessfully(.buyBitcoin)
        viewModel.createTrade()
        dataProvider.didCreateTradeSuccessfully(.buyBitcoin)

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.uiState)
        XCTAssertNotNil(viewModel.currentTrade.value)
    }*/

    func test_createQuote() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.didCreateQuoteSuccessfully(.buyBitcoin)
        viewModel.createQuote(amount: BigDecimal(0))
        dataProvider.didCreateQuoteSuccessfully(.buyBitcoin)

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.uiState)
        XCTAssertNotNil(viewModel.currentQuote.value)
    }

    func test_calculateFiatBalance() {

        // -- Given
        let viewModel = createViewModel()
        viewModel.assets = AssetBankModel.fiatAssets
        viewModel.accounts.value = AccountBankModel.mock

        // -- When
        viewModel.calculateFiatBalance()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.fiatBalance.value.isEmpty)
        XCTAssertEqual(viewModel.fiatBalance.value, "$2,000,000.00 USD")
    }

    func test_calculateFiatBalance_Assets_Empty() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        viewModel.calculateFiatBalance()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertTrue(viewModel.fiatBalance.value.isEmpty)
    }

    func test_calculateFiatBalance_Asset_NotFound() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        viewModel.calculateFiatBalance()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertTrue(viewModel.fiatBalance.value.isEmpty)
    }

    func test_calculateFiatBalance_Accounts_Empty() {

        // -- Given
        let viewModel = createViewModel()
        viewModel.assets = AssetBankModel.fiatAssets

        // -- When
        viewModel.calculateFiatBalance()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.fiatBalance.value.isEmpty)
        XCTAssertEqual(viewModel.fiatBalance.value, "$0.00 USD")
    }

    func test_fetchExternalAccounts() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.fetchExternalBankAccountsSuccessfully()
        viewModel.fetchExternalAccounts()
        dataProvider.fetchExternalBankAccountsSuccessfully()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.externalBankAccounts.value.isEmpty)
        XCTAssertEqual(viewModel.uiState.value, .ACCOUNTS)
    }

    func test_fetchAccounts() {

        // -- Given
        let viewModel = createViewModel()
        Cybrid.session.setupSession(authToken: "TEST-TOKEN")

        // -- When
        dataProvider.didFetchAccountsSuccessfully()
        viewModel.fetchAccounts()
        dataProvider.didFetchAccountsSuccessfully()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.accounts.value.isEmpty)
    }
}
