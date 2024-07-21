//
//  DepositAddressViewModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 28/07/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class DepositAddressViewModelTest: XCTestCase {

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

    func test_init() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.accountBalance)
        XCTAssertEqual(viewModel.accountBalance, balance)
        XCTAssertTrue(viewModel.depositAddresses.isEmpty)
        XCTAssertNil(viewModel.currentDepositAddress)
        XCTAssertNil(viewModel.depositAddressPolling)
        XCTAssertEqual(viewModel.uiState.value, .LOADING)
        XCTAssertEqual(viewModel.loadingLabelUiState.value, .VERIFYING)
        XCTAssertEqual(viewModel.currentAmountForDeposit, "")
        XCTAssertEqual(viewModel.currentMessageForDeposit, "")
    }

    func test_fetchDepositAddresses() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)

        // -- When
        dataProvider.didFetchListDepositAddressSuccessfully()
        viewModel.fetchDepositAddresses()
        dataProvider.didFetchListDepositAddressSuccessfully()

        // -- Then
        XCTAssertFalse(viewModel.depositAddresses.isEmpty)
    }

    func test_fetchDepositAddress() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)

        // -- When
        dataProvider.didFetchDepositAddressSuccessfully()
        viewModel.fetchDepositAddress(depositAddress: DepositAddressBankModel.mock)
        dataProvider.didFetchDepositAddressSuccessfully()

        // -- Then
        XCTAssertEqual(viewModel.uiState.value, .CONTENT)
        XCTAssertEqual(viewModel.loadingLabelUiState.value, .GETTING)
        XCTAssertTrue(viewModel.depositAddresses.isEmpty)
    }

    func test_createDepositAddress() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)

        // -- When
        dataProvider.didCreateDepositAddressSuccessfully()
        viewModel.createDepositAddress()
        dataProvider.didCreateDepositAddressSuccessfully()

        // -- Then
        XCTAssertEqual(viewModel.uiState.value, .CONTENT)
        XCTAssertEqual(viewModel.loadingLabelUiState.value, .CREATING)
        XCTAssertTrue(viewModel.depositAddresses.isEmpty)
    }

    func test_verifyingAtLeastOneAccount_NoAccounts() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)
        viewModel.depositAddresses = [
            DepositAddressBankModel(guid: "_GUID", asset: "BTC")
        ]

        // -- When
        dataProvider.didCreateDepositAddressSuccessfully()
        viewModel.verifyingAtLeastOneAccount()
        dataProvider.didCreateDepositAddressSuccessfully()

        // -- Then
        XCTAssertEqual(viewModel.uiState.value, .CONTENT)
        XCTAssertEqual(viewModel.loadingLabelUiState.value, .CREATING)
        XCTAssertFalse(viewModel.depositAddresses.isEmpty)
    }

    func test_verifyingAtLeastOneAccount() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)
        viewModel.depositAddresses = [
            DepositAddressBankModel(guid: "GUID", accountGuid: "GUID", asset: "BTC")
        ]

        // -- When
        dataProvider.didFetchDepositAddressSuccessfully()
        viewModel.verifyingAtLeastOneAccount()
        dataProvider.didFetchDepositAddressSuccessfully()

        // -- Then
        XCTAssertEqual(viewModel.uiState.value, .CONTENT)
        XCTAssertEqual(viewModel.loadingLabelUiState.value, .GETTING)
        XCTAssertFalse(viewModel.depositAddresses.isEmpty)
    }

    func test_displayDepositAddress() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)
        let depositAddress = DepositAddressBankModel(
            guid: "GUID",
            accountGuid: "GUID",
            asset: "BTC"
        )

        // -- When
        viewModel.displayDepositAddress(depositAddress: depositAddress)

        // -- Then
        XCTAssertEqual(viewModel.currentDepositAddress, depositAddress)
        XCTAssertEqual(viewModel.uiState.value, .CONTENT)
    }

    func test_checkDepositAddressValue_State_Storing() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)
        let depositAddress = DepositAddressBankModel(
            guid: "GUID",
            accountGuid: "GUID",
            asset: "BTC",
            state: .storing
        )

        // -- When
        viewModel.checkDepositAddressValue(depositAddress: depositAddress)

        // -- Then
        XCTAssertNotNil(viewModel.depositAddressPolling)
    }

    func test_checkDepositAddressValue_State_Created() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)
        let depositAddress = DepositAddressBankModel(
            guid: "GUID",
            accountGuid: "GUID",
            asset: "BTC",
            state: .created
        )
        viewModel.depositAddressPolling = Polling {}

        // -- When
        viewModel.checkDepositAddressValue(depositAddress: depositAddress)

        // -- Then
        XCTAssertNil(viewModel.depositAddressPolling)
        XCTAssertEqual(viewModel.currentDepositAddress, depositAddress)
        XCTAssertEqual(viewModel.uiState.value, .CONTENT)
    }

    func test_checkDepositAddressValue_State_Default() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)
        let depositAddress = DepositAddressBankModel(
            guid: "GUID",
            accountGuid: "GUID",
            asset: "BTC",
            state: .unknownDefaultOpenApi
        )
        viewModel.depositAddressPolling = Polling {}

        // -- When
        viewModel.checkDepositAddressValue(depositAddress: depositAddress)

        // -- Then
        XCTAssertNil(viewModel.depositAddressPolling)
    }

    func test_setValuesForDeposit() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)

        // -- When
        viewModel.setValuesForDeposit(amount: "1", message: "Hello world")

        // -- Then
        XCTAssertEqual(viewModel.currentAmountForDeposit, "1")
        XCTAssertEqual(viewModel.currentMessageForDeposit, "Hello world")
    }

    func test_generateQRCode() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)

        // -- When
        let qrImage = viewModel.generateQRCode(assetCode: "BTC", address: "12345")
        let qrImageContent = self.readQRCode(from: qrImage)

        // -- Then
        XCTAssertNotNil(qrImage)
        XCTAssertEqual("bitcoin:12345", qrImageContent ?? "")
    }

    func readQRCode(from image: UIImage?) -> String? {

        guard let image = image else { return nil }
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: nil,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])

        let features = detector?.features(in: ciImage)
        if let feature = features?.first as? CIQRCodeFeature {
            return feature.messageString
        }
        return nil
    }

    func test_getStringAddressForQRCode_BTC() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)

        // -- When
        let btcOne = viewModel.getStringAddressForQRCode(assetCode: "BTC", address: "12345")
        let btcTwo = viewModel.getStringAddressForQRCode(assetCode: "BTC", address: "12345", amount: "2")
        let btcThree = viewModel.getStringAddressForQRCode(assetCode: "BTC", address: "12345", amount: "2", message: "Hello world")

        // -- Then
        XCTAssertEqual(btcOne, "bitcoin:12345")
        XCTAssertEqual(btcTwo, "bitcoin:12345?amount=2")
        XCTAssertEqual(btcThree, "bitcoin:12345?amount=2&message=Hello%20world")
    }

    func test_getStringAddressForQRCode_ETH() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)

        // -- When
        let ethOne = viewModel.getStringAddressForQRCode(assetCode: "ETH", address: "12345")
        let ethTwo = viewModel.getStringAddressForQRCode(assetCode: "ETH", address: "12345", amount: "2")
        let ethThree = viewModel.getStringAddressForQRCode(assetCode: "ETH", address: "12345", amount: "2", gas: "1")
        let ethFour = viewModel.getStringAddressForQRCode(assetCode: "ETH", address: "12345", amount: "2", message: "Hello world", gas: "1")

        // -- Then
        XCTAssertEqual(ethOne, "ethereum:12345")
        XCTAssertEqual(ethTwo, "ethereum:12345?value=2")
        XCTAssertEqual(ethThree, "ethereum:12345?value=2&gas=1")
        XCTAssertEqual(ethFour, "ethereum:12345?value=2&gas=1&data=Hello%20world")
    }

    func test_getStringAddressForQRCode_Default() {

        // -- Given
        let balance = self.createBalance()
        let viewModel = self.createViewModel(balance: balance)

        // -- When
        let def = viewModel.getStringAddressForQRCode(assetCode: "SOL", address: "12345")

        // -- Then
        XCTAssertEqual(def, "12345")
    }
}
