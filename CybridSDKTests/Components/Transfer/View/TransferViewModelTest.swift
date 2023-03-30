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
        let modalUIState: Observable<TransferViewController.ModalViewState> = .init(.LOADING)
        let balanceLoading: Observable<TransferViewController.BalanceViewState> = .init(.CONTENT)
        let viewModel = createViewModel()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.uiState)
        XCTAssertEqual(viewModel.uiState.value, uiState.value)
        XCTAssertEqual(viewModel.modalUIState.value, modalUIState.value)
        XCTAssertEqual(viewModel.balanceLoading.value, balanceLoading.value)
        XCTAssertTrue(viewModel.assets.isEmpty)
        XCTAssertTrue(viewModel.accounts.value.isEmpty)
        XCTAssertTrue(viewModel.externalBankAccounts.value.isEmpty)
        XCTAssertTrue(viewModel.fiatBalance.value.isEmpty)
        XCTAssertNil(viewModel.currentQuote.value)
    }

    func test_fetchAccounts_Successfully() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.didFetchAccountsSuccessfully()
        viewModel.fetchAccounts()
        dataProvider.didFetchAccountsSuccessfully()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.accounts.value.isEmpty)
    }

    func test_fetchAccountsInPolling_Successfully() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        viewModel.balanceLoading.value = .LOADING
        dataProvider.didFetchAccountsSuccessfully()
        viewModel.fetchAccountsInPolling()
        dataProvider.didFetchAccountsSuccessfully()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.accounts.value.isEmpty)
        XCTAssertEqual(viewModel.balanceLoading.value, TransferViewController.BalanceViewState.CONTENT)
    }

    func test_fetchExternalAccounts_Successfully() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.fetchExternalBankAccountsSuccessfully()
        viewModel.fetchExternalAccounts()
        dataProvider.fetchExternalBankAccountsSuccessfully()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.accountsPolling)
        XCTAssertFalse(viewModel.externalBankAccounts.value.isEmpty)
        XCTAssertEqual(viewModel.uiState.value, .ACCOUNTS)
        XCTAssertEqual(viewModel.modalUIState.value, .LOADING)
        XCTAssertEqual(viewModel.balanceLoading.value, .CONTENT)
    }

    func test_createQuote_Successfully() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.didCreateQuoteSuccessfully(.buyBitcoin)
        viewModel.createQuote(amount: "0")
        dataProvider.didCreateQuoteSuccessfully(.buyBitcoin)

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.uiState)
        XCTAssertNotNil(viewModel.currentQuote.value)
        XCTAssertEqual(viewModel.modalUIState.value, TransferViewController.ModalViewState.CONFIRM)
    }

    func test_createTransfer_Successfully() {

        // -- Given
        let viewModel = createViewModel()
        viewModel.currentQuote.value = QuoteBankModel(guid: "1234")

        // -- When
        dataProvider.didCreateTransferSuccessfully()
        viewModel.createTransfer()
        dataProvider.didCreateTransferSuccessfully()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.uiState)
        XCTAssertEqual(viewModel.modalUIState.value, TransferViewController.ModalViewState.DETAILS)
        XCTAssertNotNil(viewModel.currentTransfer.value)
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

    func test_segmentedControlValueChanged() {

        // -- Given
        let viewModel = createViewModel()
        let segmented = UISegmentedControl(items: ["Test", "Test"])

        // -- When/Then
        segmented.selectedSegmentIndex = 0
        viewModel.segmentedControlValueChanged(segmented)
        XCTAssertFalse(viewModel.isWithdraw.value)

        segmented.selectedSegmentIndex = 1
        viewModel.segmentedControlValueChanged(segmented)
        XCTAssertTrue(viewModel.isWithdraw.value)
    }

    func test_getAccountNameInFormat() {

        // -- Given
        let viewModel = createViewModel()
        let account = ExternalBankAccountBankModel(plaidInstitutionId: "012", plaidAccountMask: "1234", plaidAccountName: "Test")
        let accountEmpty = ExternalBankAccountBankModel()

        // -- When
        let accountFormatted = viewModel.getAccountNameInFormat(account)
        let accountFormattedEmpety = viewModel.getAccountNameInFormat(accountEmpty)

        // -- Then
        XCTAssertEqual(accountFormatted, "012 - Test (1234)")
        XCTAssertEqual(accountFormattedEmpety, " -  ()")
    }

    func test_getQuoteSide() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        viewModel.isWithdraw.value = true
        let sideWithdraw = viewModel.getQuoteSide()

        viewModel.isWithdraw.value = false
        let sideDeposit = viewModel.getQuoteSide()

        // -- Then
        XCTAssertEqual(sideWithdraw, .withdrawal)
        XCTAssertEqual(sideDeposit, .deposit)
    }
}
