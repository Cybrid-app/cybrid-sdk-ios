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

    func test_handleQRScanned_Without_Dots() {

        // -- Given
        let viewModel = self.createViewModel()
        let code = "123456"

        // -- When
        viewModel.handleQRScanned(code: code)

        // -- Then
        XCTAssertEqual(viewModel.addressScannedValue.value, code)
    }

    func test_handleQRScanned_With_Dots() {

        // -- Given
        let viewModel = self.createViewModel()
        let codeOne = "bitcoin:123456"
        let codeTwo = "bitcoin:98765&tag=234"

        // -- When Case 1
        viewModel.handleQRScanned(code: codeOne)
        XCTAssertEqual(viewModel.addressScannedValue.value, "123456")

        // -- When Case 2
        viewModel.handleQRScanned(code: codeTwo)
        XCTAssertEqual(viewModel.addressScannedValue.value, "98765")
        XCTAssertEqual(viewModel.tagScannedValue.value, "234")
    }

    func test_handleError_WithData_nil() {

        // -- Given
        let viewModel = self.createViewModel()
        let error = ErrorResponse.error(1, nil, nil, CybridError.serviceError)

        // -- When
        viewModel.handleError(error)

        // -- Then
        XCTAssertEqual(viewModel.serverError, "")
        XCTAssertEqual(viewModel.uiState.value, .ERROR)
    }

    func test_handleError_WithData_No_Json() {

        // -- Given
        let viewModel = self.createViewModel()
        let data = "Cybrid".data(using: .utf8)
        let error = ErrorResponse.error(1, data, nil, CybridError.serviceError)

        // -- When
        viewModel.handleError(error)

        // -- Then
        XCTAssertEqual(viewModel.serverError, "")
        XCTAssertEqual(viewModel.uiState.value, .ERROR)
    }

    func test_handleError() {

        // -- Given
        let viewModel = self.createViewModel()
        let data = "{\"status\":400,\"error_message\":\"tag must not be empty\",\"message_code\":\"invalid_parameter\"}".data(using: .utf8)
        let error = ErrorResponse.error(1, data, nil, CybridError.serviceError)

        // -- When
        viewModel.handleError(error)

        // -- Then
        XCTAssertEqual(viewModel.serverError, "Tag must not be empty")
    }
}
