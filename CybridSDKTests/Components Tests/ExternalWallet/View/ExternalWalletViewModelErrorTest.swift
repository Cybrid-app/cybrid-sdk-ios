//
//  ExternalWalletViewModelErrorTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 23/08/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class ExternalWalletViewModelErrorTest: ExternalWalletTest {

    func test_fetchExternalWallets_Failed() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.fetchExternalWallets()
        dataProvider.didFetchListExternalWalletsFailed()

        // -- Then
        XCTAssertTrue(viewModel.externalWallets.isEmpty)
        XCTAssertTrue(viewModel.externalWalletsActive.isEmpty)
        XCTAssertEqual(viewModel.uiState.value, .ERROR)
    }

    func test_createExternalWallet_Failed() {

        // -- Given
        let viewModel = self.createViewModel()
        let postExternalWalletBankModel = PostExternalWalletBankModel(
            name: "Test",
            asset: "BTC",
            address: "1234567890",
            tag: "")

        // -- When
        viewModel.createExternalWallet(postExternalWalletBankModel: postExternalWalletBankModel)
        dataProvider.didCreateExternalWalletFailed()

        // -- Then
        XCTAssertTrue(viewModel.externalWallets.isEmpty)
        XCTAssertTrue(viewModel.externalWalletsActive.isEmpty)
        XCTAssertEqual(viewModel.uiState.value, .ERROR)
    }

    func test_deleteExternalWallet_Failed() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentWallet = ExternalWalletBankModel.mock

        // -- When
        viewModel.deleteExternalWallet()
        dataProvider.didDeleteExternalWalletFailed()

        // -- Then
        XCTAssertTrue(viewModel.externalWallets.isEmpty)
        XCTAssertTrue(viewModel.externalWalletsActive.isEmpty)
        XCTAssertEqual(viewModel.uiState.value, .ERROR)
    }

    func test_fetchTransfers_Failed() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentWallet = ExternalWalletBankModel(guid: "1234")

        // -- When
        viewModel.fetchTransfers()
        dataProvider.didFetchTransfersListWithError()

        // -- Then
        XCTAssertTrue(viewModel.transfers.isEmpty)
        XCTAssertEqual(viewModel.transfersUiState.value, .EMPTY)
    }
}
