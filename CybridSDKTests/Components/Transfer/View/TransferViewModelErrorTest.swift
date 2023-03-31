//
//  TransferViewModelErrorTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 27/12/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class TransferViewModelErrorTest: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func createViewModel() -> TransferViewModel {
        return TransferViewModel(dataProvider: self.dataProvider,
                                     logger: nil)
    }

    func test_fetchAccounts_Failed() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        viewModel.fetchAccounts()
        dataProvider.didFetchAccountsWithError()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertTrue(viewModel.accounts.value.isEmpty)
    }

    func test_fetchAccountsInPolling_Failed() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        viewModel.fetchAccountsInPolling()
        dataProvider.didFetchAccountsWithError()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertTrue(viewModel.accounts.value.isEmpty)
    }

    func test_fetchExternalAccounts_Failed() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        viewModel.fetchExternalAccounts()
        dataProvider.fetchExternalBankAccountsFailed()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertNil(viewModel.accountsPolling)
        XCTAssertTrue(viewModel.externalBankAccounts.value.isEmpty)
        XCTAssertEqual(viewModel.uiState.value, .LOADING)
    }

    func test_createQuote_Failed() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        viewModel.createQuote(amount: "0")
        dataProvider.didCreateQuoteFailed()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.uiState)
        XCTAssertNil(viewModel.currentQuote.value)
        XCTAssertEqual(viewModel.modalUIState.value, TransferViewController.ModalViewState.ERROR)
    }

    func test_createTransfer_Failed() {

        // -- Given
        let viewModel = createViewModel()
        viewModel.currentQuote.value = QuoteBankModel(guid: "1234")

        // -- When
        viewModel.createTransfer()
        dataProvider.didCreateTransferFailed()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.uiState)
        XCTAssertEqual(viewModel.modalUIState.value, TransferViewController.ModalViewState.ERROR)
        XCTAssertNil(viewModel.currentTransfer.value)
    }
}
