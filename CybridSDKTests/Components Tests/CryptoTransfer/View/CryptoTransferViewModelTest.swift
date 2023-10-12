//
//  CryptoTransferViewModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 04/10/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class CryptoTransferViewModelTest: CryptoTransferTest {

    func test_init() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.customerGuid.isEmpty)
        XCTAssertFalse(viewModel.assets.isEmpty)
        XCTAssertEqual(viewModel.fiat, Cybrid.fiat)
        XCTAssertTrue(viewModel.accounts.isEmpty)
        XCTAssertTrue(viewModel.externalWallets.isEmpty)
        XCTAssertTrue(viewModel.externalWallets.isEmpty)
        XCTAssertTrue(viewModel.prices.value.isEmpty)
        XCTAssertNil(viewModel.currentAccount.value)
        XCTAssertNil(viewModel.currentAsset)
        XCTAssertNil(viewModel.currentExternalWallet)
        XCTAssertEqual(viewModel.currentAmountInput, "0")
        XCTAssertNil(viewModel.currentQuote.value)
        XCTAssertNil(viewModel.currentTransfer.value)
        XCTAssertFalse(viewModel.isTransferInFiat.value)
        XCTAssertEqual(viewModel.amountInputObservable.value, "")
        XCTAssertEqual(viewModel.amountWithPriceObservable.value, "0.0")
        XCTAssertFalse(viewModel.amountWithPriceErrorObservable.value)
        XCTAssertNil(viewModel.pricesPolling)
        XCTAssertEqual(viewModel.uiState.value, .LOADING)
        XCTAssertEqual(viewModel.modalUiState.value, .LOADING)
    }

    func test_initComponent() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.initComponent()

        // -- Then
        XCTAssertNotNil(viewModel.pricesPolling)
    }

    func test_fetchAccounts() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        dataProvider.didFetchAccountsSuccessfully()
        viewModel.fetchAccounts()
        dataProvider.didFetchAccountsSuccessfully()

        // -- Then
        XCTAssertFalse(viewModel.accounts.isEmpty)
    }

    func test_fetchExternalWallets() {

        // -- Given
        let viewModel = self.createViewModel()
        let mock = ExternalWalletListBankModel.mockWithDeletes

        // -- When
        dataProvider.didFetchListExternalWalletsSuccessfully(mock: mock)
        viewModel.fetchExternalWallets()
        dataProvider.didFetchListExternalWalletsSuccessfully(mock: mock)

        // -- Then
        XCTAssertFalse(viewModel.externalWallets.isEmpty)
        XCTAssertEqual(viewModel.externalWallets[0].state, .completed)
    }

    func test_fetchPrices() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        dataProvider.didFetchPricesSuccessfully()
        viewModel.fetchPrices()
        dataProvider.didFetchPricesSuccessfully()

        // -- Then
        XCTAssertFalse(viewModel.prices.value.isEmpty)
    }

    func test_createQuote_CurrentAsset_Nil() {

        // -- Given
        let amount = "1"
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = nil

        // -- When
        viewModel.createQuote(amount: amount)

        // -- Then
        XCTAssertEqual(viewModel.modalUiState.value, .ERROR)
    }

    func test_createQuote_Asset_Empty() {

        // -- Given
        let amount = "1"
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.mockWithNoAsset

        // -- When
        viewModel.createQuote(amount: amount)

        // -- Then
        XCTAssertEqual(viewModel.modalUiState.value, .ERROR)
    }

    func test_createQuote() {

        // -- Given
        let amount = "1"
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.tradingETH
        let quoteBankModel = QuoteBankModel(guid: "1234")

        // -- When
        dataProvider.didCreateQuoteSuccessfully(quoteBankModel)
        viewModel.createQuote(amount: amount)
        dataProvider.didCreateQuoteSuccessfully(quoteBankModel)

        // -- Then
        XCTAssertNotNil(viewModel.currentQuote.value)
        XCTAssertEqual(viewModel.currentQuote.value, quoteBankModel)
        XCTAssertEqual(viewModel.modalUiState.value, .QUOTE)
    }

    func test_createTransfer_CurrentQuote_Nil() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.createTransfer()

        // -- Then
        XCTAssertNil(viewModel.currentTransfer.value)
        XCTAssertEqual(viewModel.modalUiState.value, .ERROR)
    }

    func test_createTransfer() {

        // -- Given
        let quoteBankModel = QuoteBankModel(guid: "1234")
        let viewModel = self.createViewModel()
        viewModel.currentQuote.value = quoteBankModel

        // -- When
        dataProvider.didCreateTransferSuccessfully()
        viewModel.createTransfer()
        dataProvider.didCreateTransferSuccessfully()

        // -- Then
        XCTAssertNotNil(viewModel.currentTransfer.value)
        XCTAssertEqual(viewModel.modalUiState.value, .DONE)
    }

    func test_switchActionHandler() {

        // -- Given
        let viewModel = self.createViewModel()
        let transferInFiat = viewModel.isTransferInFiat.value

        // -- When
        viewModel.switchActionHandler(UIButton())

        // -- Then
        XCTAssertEqual(viewModel.isTransferInFiat.value, !transferInFiat)
    }

    func test_maxButtonClickHandler() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.trading

        // -- When
        viewModel.maxButtonClickHandler()

        // -- Then
        XCTAssertEqual(viewModel.amountInputObservable.value.removeTrailingZeros(), "2")
    }

    func test_getMaxAmountOfAccount_CurrentAssetAccount_Nil() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.mockWithNilAsset

        // -- When
        let max = viewModel.getMaxAmountOfAccount()

        // -- Then
        XCTAssertEqual(max, "0")
    }

    func test_getMaxAmountOfAccount_CurrentAssetAccount_Empty() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.mockWithNoAsset

        // -- When
        let max = viewModel.getMaxAmountOfAccount()

        // -- Then
        XCTAssertEqual(max, "0")
    }

    func test_getMaxAmountOfAccount_Balance_Undefined() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.tradingBalanceUndefined

        // -- When
        let max = viewModel.getMaxAmountOfAccount()

        // -- Then
        XCTAssertEqual(max, "0")
    }

    func test_getMaxAmountOfAccount() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.trading

        // -- When
        let max = viewModel.getMaxAmountOfAccount()

        // -- Then
        XCTAssertEqual(max.removeTrailingZeros(), "2")
    }

    func test_changeCurrentAccount() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.tradingETH

        // -- When
        viewModel.changeCurrentAccount(nil)
        XCTAssertNotNil(viewModel.currentAccount.value)

        viewModel.changeCurrentAccount(AccountBankModel.trading)

        // -- Then
        XCTAssertEqual(viewModel.currentAccount.value?.guid, AccountBankModel.trading.guid)
        XCTAssertEqual(viewModel.currentAsset?.code, "BTC")
    }

    func test_getPrice() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.prices.value = .mockPrices

        // -- When/Then
        let btc1 = viewModel.getPrice(symbol: "BTC-USD")
        XCTAssertEqual(btc1.symbol, "BTC-USD")

        let btc2 = viewModel.getPrice(symbol: "BTC-MXN")
        XCTAssertNil(btc2.symbol)
    }

    func test_calculatePreQuote_InFiat() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.currentAmountInput = "2"
        viewModel.isTransferInFiat.value = true
        viewModel.currentAsset = AssetBankModel.bitcoin
        viewModel.prices.value = .mockPrices

        // -- When
        viewModel.calculatePreQuote()

        // -- Then
        XCTAssertEqual(viewModel.amountWithPriceObservable.value, "₿0.00009901")
        XCTAssertFalse(viewModel.amountWithPriceErrorObservable.value)
    }

    func test_calculatePreQuote_InFiat_Overdue() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.currentAmountInput = "100000"
        viewModel.isTransferInFiat.value = true
        viewModel.currentAsset = AssetBankModel.bitcoin
        viewModel.prices.value = .mockPrices

        // -- When
        viewModel.calculatePreQuote()

        // -- Then
        XCTAssertEqual(viewModel.amountWithPriceObservable.value, "₿4.95076219")
        XCTAssertTrue(viewModel.amountWithPriceErrorObservable.value)
    }

    func test_calculatePreQuote_NotInFiat() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.currentAmountInput = "0.00002"
        viewModel.isTransferInFiat.value = false
        viewModel.currentAsset = AssetBankModel.bitcoin
        viewModel.prices.value = .mockPrices

        // -- When
        viewModel.calculatePreQuote()

        // -- Then
        XCTAssertEqual(viewModel.amountWithPriceObservable.value, "$0.40 USD")
        XCTAssertFalse(viewModel.amountWithPriceErrorObservable.value)
    }

    func test_calculatePreQuote_NotInFiat_Overdue() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.currentAmountInput = "3"
        viewModel.isTransferInFiat.value = false
        viewModel.currentAsset = AssetBankModel.bitcoin
        viewModel.prices.value = .mockPrices

        // -- When
        viewModel.calculatePreQuote()

        // -- Then
        XCTAssertEqual(viewModel.amountWithPriceObservable.value, "$60,596.73 USD")
        XCTAssertTrue(viewModel.amountWithPriceErrorObservable.value)
    }

    func test_calculatePreQuote_With_PlatformBalance_Nil() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.tradingBalanceNil
        viewModel.currentAmountInput = "2"
        viewModel.isTransferInFiat.value = true
        viewModel.currentAsset = AssetBankModel.bitcoin
        viewModel.prices.value = .mockPrices

        // -- When
        viewModel.calculatePreQuote()

        // -- Then
        XCTAssertEqual(viewModel.amountWithPriceObservable.value, "₿0.00009901")
    }

    func test_calculatePreQuote_Without_Price() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.currentAmountInput = "2"
        viewModel.isTransferInFiat.value = true
        viewModel.currentAsset = AssetBankModel.bitcoin

        // -- When
        viewModel.calculatePreQuote()

        // -- Then
        XCTAssertEqual(viewModel.amountWithPriceObservable.value, "0")
    }

    func test_calculatePreQuote_Zero_Input() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.currentAmountInput = "0"

        // -- When
        viewModel.calculatePreQuote()

        // -- Then
        XCTAssertEqual(viewModel.amountWithPriceObservable.value, "0.00")
    }
}
