//
//  ExternalWalletViewModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 23/08/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class ExternalWalletViewModelTest: ExternalWalletTest {

    func test_init() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.customerGuig.isEmpty)
        XCTAssertTrue(viewModel.externalWallets.isEmpty)
        XCTAssertTrue(viewModel.externalWalletsActive.isEmpty)
        XCTAssertTrue(viewModel.transfers.isEmpty)
        XCTAssertEqual(viewModel.uiState.value, .LOADING)
        XCTAssertEqual(viewModel.transfersUiState.value, .LOADING)
        XCTAssertNil(viewModel.currentWallet)
    }

    func test_fetchExternalWallets() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        dataProvider.didFetchListExternalWalletsSuccessfully()
        viewModel.fetchExternalWallets()
        dataProvider.didFetchListExternalWalletsSuccessfully()

        // -- Then
        XCTAssertFalse(viewModel.externalWallets.isEmpty)
        XCTAssertFalse(viewModel.externalWalletsActive.isEmpty)
        XCTAssertEqual(viewModel.uiState.value, .WALLETS)
    }

    func test_createExternalWallet() {

        // -- Given
        let viewModel = self.createViewModel()
        let postExternalWalletBankModel = PostExternalWalletBankModel(
            name: "Test",
            asset: "BTC",
            address: "1234567890",
            tag: "")

        // -- When
        dataProvider.didCreateExternalWalletSuccessfully()
        viewModel.createExternalWallet(postExternalWalletBankModel: postExternalWalletBankModel)
        dataProvider.didCreateExternalWalletSuccessfully()
        dataProvider.didFetchListExternalWalletsSuccessfully()

        // -- Then
        XCTAssertFalse(viewModel.externalWallets.isEmpty)
        XCTAssertFalse(viewModel.externalWalletsActive.isEmpty)
        XCTAssertEqual(viewModel.uiState.value, .WALLETS)
    }

    func test_deleteExternalWallet() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentWallet = ExternalWalletBankModel.mock

        // -- When
        dataProvider.didDeleteExternalWalletSuccessfully()
        viewModel.deleteExternalWallet()
        dataProvider.didDeleteExternalWalletSuccessfully()
        dataProvider.didFetchListExternalWalletsSuccessfully()

        // -- Then
        XCTAssertFalse(viewModel.externalWallets.isEmpty)
        XCTAssertFalse(viewModel.externalWalletsActive.isEmpty)
        XCTAssertNil(viewModel.currentWallet)
        XCTAssertEqual(viewModel.uiState.value, .WALLETS)
    }

    func test_goToWalletDetail() {

        // -- Given
        let viewModel = self.createViewModel()
        let wallet = ExternalWalletBankModel(guid: "987")

        // -- When
        XCTAssertNil(viewModel.currentWallet)
        viewModel.goToWalletDetail(wallet)

        // -- Then
        XCTAssertNotNil(viewModel.currentWallet)
        XCTAssertTrue(viewModel.transfers.isEmpty)
        XCTAssertEqual(viewModel.uiState.value, .WALLET)
    }

    func test_fetchTransfers() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentWallet = ExternalWalletBankModel(guid: "1234")

        // -- When
        dataProvider.didFetchTransfersListSuccessfully()
        viewModel.fetchTransfers()
        dataProvider.didFetchTransfersListSuccessfully()

        // -- Then
        XCTAssertFalse(viewModel.transfers.isEmpty)
        XCTAssertEqual(viewModel.transfersUiState.value, .EMPTY)
    }
}
