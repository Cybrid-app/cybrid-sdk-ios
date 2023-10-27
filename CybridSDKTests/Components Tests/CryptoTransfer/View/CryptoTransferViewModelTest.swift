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
        XCTAssertTrue(viewModel.wallets.isEmpty)
        XCTAssertTrue(viewModel.prices.value.isEmpty)
        XCTAssertNil(viewModel.pricesPolling)
        XCTAssertNil(viewModel.currentAccount.value)
        XCTAssertTrue(viewModel.currentWallets.value.isEmpty)
        XCTAssertNil(viewModel.currentAsset.value)
        XCTAssertNil(viewModel.currentWallet.value)
        XCTAssertEqual(viewModel.currentAmountInput, "0")
        XCTAssertEqual(viewModel.amountInputObservable.value, "")
        XCTAssertFalse(viewModel.isAmountInFiat.value)
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "0.0")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "0")
        XCTAssertFalse(viewModel.preQuoteValueHasErrorState.value)
        XCTAssertNil(viewModel.currentQuote.value)
        XCTAssertNil(viewModel.currentTransfer.value)
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

        // -- Case: Accounts trading and fiat
        dataProvider.didFetchAccountsSuccessfully()
        viewModel.fetchAccounts()
        dataProvider.didFetchAccountsSuccessfully()
        XCTAssertFalse(viewModel.accounts.isEmpty)
        XCTAssertEqual(viewModel.accounts.count, 1)
        XCTAssertEqual(viewModel.accounts.first?.type, .trading)
        XCTAssertEqual(viewModel.currentAccount.value, viewModel.accounts.first)

        // -- Case: Accounts only fiat
        viewModel.currentAccount.value = nil
        let mockAccounts = AccountListBankModel(total: 1, page: 1, perPage: 1, objects: [AccountBankModel.fiat])
        dataProvider.didFetchAccountsSuccessfully(mock: mockAccounts)
        viewModel.fetchAccounts()
        dataProvider.didFetchAccountsSuccessfully(mock: mockAccounts)
        XCTAssertTrue(viewModel.accounts.isEmpty)
        XCTAssertEqual(viewModel.currentAccount.value, nil)
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
        XCTAssertFalse(viewModel.wallets.isEmpty)
        XCTAssertEqual(viewModel.wallets[0].state, .completed)
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
        viewModel.currentAmountInput = amount

        // -- When
        viewModel.createQuote()

        // -- Then
        XCTAssertEqual(viewModel.modalUiState.value, .ERROR)
    }

    func test_createQuote_Asset_Empty() {

        // -- Given
        let amount = "1"
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.mockWithNoAsset
        viewModel.currentAmountInput = amount

        // -- When
        viewModel.createQuote()

        // -- Then
        XCTAssertEqual(viewModel.modalUiState.value, .ERROR)
    }

    func test_createQuote() {

        // -- Given
        let amount = "1"
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.tradingETH
        viewModel.currentAmountInput = amount
        let quoteBankModel = QuoteBankModel(guid: "1234")

        // -- When
        dataProvider.didCreateQuoteSuccessfully(quoteBankModel)
        viewModel.createQuote()
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

    // -- MARK: View Functions
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

    func test_textFieldDidChangeSelection() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.isTransferInFiat.value = true
        viewModel.currentAsset = AssetBankModel.bitcoin
        viewModel.prices.value = .mockPrices

        // -- Case: Input text change equl to nul
        viewModel.textFieldDidChangeSelection(nil)
        XCTAssertEqual(viewModel.currentAmountInput, "0")
        XCTAssertEqual(viewModel.amountWithPriceObservable.value, "0.00")
        XCTAssertFalse(viewModel.amountWithPriceErrorObservable.value)

        // -- Case: Input text change equl to ""
        viewModel.textFieldDidChangeSelection("")
                XCTAssertEqual(viewModel.currentAmountInput, "")
        XCTAssertEqual(viewModel.amountWithPriceObservable.value, "0.00")
        XCTAssertFalse(viewModel.amountWithPriceErrorObservable.value)

        // -- Case: Input text change equl to "Hello"
        viewModel.textFieldDidChangeSelection("Hello")
        XCTAssertEqual(viewModel.currentAmountInput, "Hello")
        XCTAssertEqual(viewModel.amountWithPriceObservable.value, "0.00")
        XCTAssertFalse(viewModel.amountWithPriceErrorObservable.value)

        // -- Case: Input text change equl to "2"
        viewModel.textFieldDidChangeSelection("2")
        XCTAssertEqual(viewModel.currentAmountInput, "2")
        XCTAssertEqual(viewModel.amountWithPriceObservable.value, "₿0.00009901")
        XCTAssertFalse(viewModel.amountWithPriceErrorObservable.value)

        // -- Case: Input text change equl to "3.5"
        viewModel.textFieldDidChangeSelection("3.5")
        XCTAssertEqual(viewModel.currentAmountInput, "3.5")
        XCTAssertEqual(viewModel.amountWithPriceObservable.value, "₿0.00017327")
        XCTAssertFalse(viewModel.amountWithPriceErrorObservable.value)

        // -- Case: Input text change equl to "0.5"
        viewModel.textFieldDidChangeSelection(".5")
        XCTAssertEqual(viewModel.currentAmountInput, "0.5")
        XCTAssertEqual(viewModel.amountWithPriceObservable.value, "₿0.00002475")
        XCTAssertFalse(viewModel.amountWithPriceErrorObservable.value)

        // -- Case: Input text change equl to "1."
        viewModel.textFieldDidChangeSelection("1.")
        XCTAssertEqual(viewModel.currentAmountInput, "1.00")
        XCTAssertEqual(viewModel.amountWithPriceObservable.value, "₿0.00004950")
        XCTAssertFalse(viewModel.amountWithPriceErrorObservable.value)
    }

    // -- MARK: Accounts Functions
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
