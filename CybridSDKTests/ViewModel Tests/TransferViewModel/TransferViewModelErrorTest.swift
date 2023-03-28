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

    /*func test_createTrade_Failed() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        viewModel.createTrade()
        dataProvider.didCreateTradeFailed()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.uiState)
        XCTAssertNil(viewModel.currentTrade.value)
    }*/

    func test_createQuote_Failed() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        viewModel.createQuote(amount: BigDecimal(0))
        dataProvider.didCreateQuoteFailed()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.uiState)
        XCTAssertNil(viewModel.currentQuote.value)
    }

    func test_fetchExternalAccounts_Failed() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        viewModel.fetchExternalAccounts()
        dataProvider.fetchExternalBankAccountsFailed()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertTrue(viewModel.externalBankAccounts.value.isEmpty)
        XCTAssertEqual(viewModel.uiState.value, .LOADING)
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
}
