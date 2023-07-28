//
//  DepositAddressViewModelErrorTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 28/07/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class DepositAddressViewModelErrorTest: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    private func createViewModel(balance: BalanceUIModel) -> DepositAddressViewModel {
        return DepositAddressViewModel(
            dataProvider: self.dataProvider,
            logger: nil,
            accountBalance: balance)
    }

    private func createBalance() -> BalanceUIModel {
        return BalanceUIModel(
            account: AccountBankModel.trading,
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            price: SymbolPriceBankModel.btcUSD1)
    }

    func test_fetchDepositAddresses_Failed() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)

        // -- When
        viewModel.fetchDepositAddresses()
        dataProvider.didFetchListDepositAddressFailed()

        // -- Then
        XCTAssertTrue(viewModel.depositAddresses.isEmpty)
        XCTAssertEqual(viewModel.uiState.value, .ERROR)
    }

    func test_fetchDepositAddress_Failes() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)

        // -- When
        viewModel.fetchDepositAddress(depositAddress: DepositAddressBankModel.mock)
        dataProvider.didFetchDepositAddressFailed()

        // -- Then
        XCTAssertEqual(viewModel.uiState.value, .ERROR)
        XCTAssertEqual(viewModel.loadingLabelUiState.value, .GETTING)
        XCTAssertTrue(viewModel.depositAddresses.isEmpty)
    }

    func test_createDepositAddress_Failed() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)

        // -- When
        viewModel.createDepositAddress()
        dataProvider.didCreateDepositAddressFailed()

        // -- Then
        XCTAssertEqual(viewModel.uiState.value, .ERROR)
        XCTAssertEqual(viewModel.loadingLabelUiState.value, .CREATING)
        XCTAssertTrue(viewModel.depositAddresses.isEmpty)
    }
}
