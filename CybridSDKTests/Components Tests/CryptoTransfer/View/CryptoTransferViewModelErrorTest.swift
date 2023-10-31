//
//  CryptoTransferViewModelErrorTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 05/10/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class CryptoTransferViewModelErrorTest: CryptoTransferTest {

    func test_fetchAccounts_Error() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.fetchAccounts()
        dataProvider.didFetchAccountsWithError()

        // -- Then
        XCTAssertTrue(viewModel.accounts.isEmpty)
        XCTAssertEqual(viewModel.uiState.value, .ERROR)
    }

    func test_fetchExternalWallets_Error() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.fetchExternalWallets()
        dataProvider.didFetchListExternalWalletsFailed()

        // -- Then
        XCTAssertTrue(viewModel.wallets.isEmpty)
    }

    func test_fetchPrices_Error() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.fetchPrices()
        dataProvider.didFetchPricesWithError()

        // -- Then
        XCTAssertTrue(viewModel.prices.value.isEmpty)
    }

    func test_createQuote_Error() {

        // -- Given
        let amount = "1"
        let viewModel = self.createViewModel()
        viewModel.currentAmountInput = "1"
        viewModel.currentAccount.value = AccountBankModel.tradingETH

        // -- When
        viewModel.createQuote()
        dataProvider.didCreateQuoteFailed()

        // -- Then
        XCTAssertNil(viewModel.currentQuote.value)
        XCTAssertEqual(viewModel.modalUiState.value, .ERROR)
    }

    func test_createTransfer_Error() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentQuote.value = QuoteBankModel(guid: "1234")
        viewModel.currentWallet.value = ExternalWalletBankModel.mock

        // -- When
        viewModel.createTransfer()
        dataProvider.didCreateTransferFailed()

        // -- Then
        XCTAssertNil(viewModel.currentQuote.value)
        XCTAssertNil(viewModel.currentTransfer.value)
        XCTAssertEqual(viewModel.modalUiState.value, .ERROR)
    }
}
