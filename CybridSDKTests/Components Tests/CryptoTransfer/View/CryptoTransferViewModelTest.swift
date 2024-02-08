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
        let accountsFetched = AccountListBankModel(total: 1, page: 1, perPage: 1, objects: [AccountBankModel.fiat, AccountBankModel.fiat, AccountBankModel.trading, AccountBankModel.tradingETH])
        dataProvider.didFetchAccountsSuccessfully(mock: accountsFetched)
        viewModel.fetchAccounts()
        dataProvider.didFetchAccountsSuccessfully(mock: accountsFetched)
        XCTAssertFalse(viewModel.accounts.isEmpty)
        XCTAssertEqual(viewModel.accounts.count, 2)
        XCTAssertEqual(viewModel.accounts.first?.type, "trading")
        XCTAssertEqual(viewModel.accounts.first?.asset, "BTC")
        XCTAssertEqual(viewModel.accounts.last?.type, "trading")
        XCTAssertEqual(viewModel.accounts.last?.asset, "ETH")
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
        let mock = ExternalWalletListBankModel.mockForCrpytoTransfer

        // -- Case: currentAccount nil
        viewModel.currentAccount.value = nil
        dataProvider.didFetchListExternalWalletsSuccessfully(mock: mock)
        viewModel.fetchExternalWallets()
        dataProvider.didFetchListExternalWalletsSuccessfully(mock: mock)
        XCTAssertFalse(viewModel.wallets.isEmpty)
        XCTAssertEqual(viewModel.wallets.count, 2)
        XCTAssertEqual(viewModel.wallets.first?.state, "completed")
        XCTAssertEqual(viewModel.wallets.first?.name, "BTC")
        XCTAssertEqual(viewModel.wallets.last?.state, "completed")
        XCTAssertEqual(viewModel.wallets.last?.name, "ETH")

        // -- Case: currentAccount nil
        viewModel.currentAccount.value = AccountBankModel.trading
        dataProvider.didFetchListExternalWalletsSuccessfully(mock: mock)
        viewModel.fetchExternalWallets()
        dataProvider.didFetchListExternalWalletsSuccessfully(mock: mock)
        XCTAssertFalse(viewModel.wallets.isEmpty)
        XCTAssertEqual(viewModel.wallets.count, 2)
        XCTAssertEqual(viewModel.wallets.first?.state, "completed")
        XCTAssertEqual(viewModel.wallets.first?.name, "BTC")
        XCTAssertEqual(viewModel.wallets.last?.state, "completed")
        XCTAssertEqual(viewModel.wallets.last?.name, "ETH")
        XCTAssertEqual(viewModel.currentWallets.value.count, 1)
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

    func test_createQuote() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAmountInput = "1"
        let quoteBankModel = QuoteBankModel(guid: "1234")

        // -- Case: Current account is nil
        viewModel.currentAccount.value = nil
        dataProvider.didCreateQuoteSuccessfully(quoteBankModel)
        viewModel.createQuote()
        dataProvider.didCreateQuoteSuccessfully(quoteBankModel)
        XCTAssertNil(viewModel.currentQuote.value)
        XCTAssertEqual(viewModel.modalUiState.value, .ERROR)

        // -- Case: Good
        viewModel.currentAccount.value = AccountBankModel.tradingETH
        dataProvider.didCreateQuoteSuccessfully(quoteBankModel)
        viewModel.createQuote()
        dataProvider.didCreateQuoteSuccessfully(quoteBankModel)
        XCTAssertNotNil(viewModel.currentQuote.value)
        XCTAssertEqual(viewModel.currentQuote.value, quoteBankModel)
        XCTAssertEqual(viewModel.modalUiState.value, .QUOTE)
    }

    func test_createTransfer() {

        // -- Given
        let quoteBankModel = QuoteBankModel(guid: "1234")
        let viewModel = self.createViewModel()

        // -- Case: Current quote nil
        viewModel.currentQuote.value = nil
        viewModel.createTransfer()
        XCTAssertNil(viewModel.currentTransfer.value)
        XCTAssertEqual(viewModel.modalUiState.value, .ERROR)

        // -- Case: Good
        viewModel.currentQuote.value = quoteBankModel
        viewModel.currentWallet.value = ExternalWalletBankModel.mock
        dataProvider.didCreateTransferSuccessfully()
        viewModel.createTransfer()
        dataProvider.didCreateTransferSuccessfully()
        XCTAssertNotNil(viewModel.currentTransfer.value)
        XCTAssertEqual(viewModel.modalUiState.value, .DONE)
    }

    // MARK: Accounts Methods
    func test_changeCurrentAccount() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- Case: Account without asset
        viewModel.wallets = [ExternalWalletBankModel.mock, ExternalWalletBankModel.mockEth]
        viewModel.currentWallets.value = []
        viewModel.currentWallet.value = nil
        viewModel.currentAsset.value = nil
        viewModel.isAmountInFiat.value = true
        let accountWithoutAsset = AccountBankModel.mockWithNilAsset
        viewModel.changeCurrentAccount(accountWithoutAsset)
        XCTAssertTrue(viewModel.currentWallets.value.isEmpty)
        XCTAssertNil(viewModel.currentWallet.value)
        XCTAssertNil(viewModel.currentAsset.value)
        XCTAssertFalse(viewModel.isAmountInFiat.value)

        // -- Case: Account with MXN asset
        viewModel.wallets = [ExternalWalletBankModel.mock, ExternalWalletBankModel.mockEth]
        viewModel.currentWallets.value = []
        viewModel.currentWallet.value = nil
        viewModel.currentAsset.value = nil
        viewModel.isAmountInFiat.value = true
        let accountMXN = AccountBankModel.mockMxn
        viewModel.changeCurrentAccount(accountMXN)
        XCTAssertTrue(viewModel.currentWallets.value.isEmpty)
        XCTAssertNil(viewModel.currentWallet.value)
        XCTAssertNil(viewModel.currentAsset.value)
        XCTAssertFalse(viewModel.isAmountInFiat.value)

        // -- Case: Account good (BTC)
        viewModel.wallets = [ExternalWalletBankModel.mock, ExternalWalletBankModel.mockEth]
        viewModel.currentWallets.value = []
        viewModel.currentWallet.value = nil
        viewModel.currentAsset.value = nil
        viewModel.isAmountInFiat.value = true
        let accountBTC = AccountBankModel.trading
        viewModel.changeCurrentAccount(accountBTC)
        XCTAssertFalse(viewModel.currentWallets.value.isEmpty)
        XCTAssertEqual(viewModel.currentWallets.value.count, 1)
        XCTAssertEqual(viewModel.currentWallet.value?.asset, "BTC")
        XCTAssertEqual(viewModel.currentAsset.value?.code, "BTC")
        XCTAssertFalse(viewModel.isAmountInFiat.value)
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

    func test_resetValues() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.resetValues()

        // -- Then
        XCTAssertNil(viewModel.currentWallet.value)
        XCTAssertEqual(viewModel.currentAmountInput, "0")
        XCTAssertFalse(viewModel.isAmountInFiat.value)
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "0.0")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "0")
        XCTAssertFalse(viewModel.preQuoteValueHasErrorState.value)
        XCTAssertEqual(viewModel.amountInputObservable.value, "")
    }

    // MARK: Quote Methods
    func test_createPostQuoteBankModel() {

        // -- Given
        let viewModel = self.createViewModel()
        let customerGuid = Cybrid.customerGuid

        // -- Case: assetCode (currentAccount is nil)
        viewModel.currentAccount.value = nil
        let postQuoteBankModelOne = viewModel.createPostQuoteBankModel(amount: "1")
        XCTAssertNil(postQuoteBankModelOne)

        // -- Case: assetCode (currentAccount has asset as nil)
        viewModel.currentAccount.value = AccountBankModel.mockWithNilAsset
        let postQuoteBankModelTwo = viewModel.createPostQuoteBankModel(amount: "1")
        XCTAssertNil(postQuoteBankModelTwo)

        // -- Case: asset (currentAccount->asset as MXN)
        viewModel.currentAccount.value = AccountBankModel.mockMxn
        let postQuoteBankModelThree = viewModel.createPostQuoteBankModel(amount: "1")
        XCTAssertNil(postQuoteBankModelThree)

        // -- Case: amountInFiat as False
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.isAmountInFiat.value = false
        let postQuoteBankModelFour = viewModel.createPostQuoteBankModel(amount: "1")
        XCTAssertNotNil(postQuoteBankModelFour)
        XCTAssertEqual(postQuoteBankModelFour?.productType, .cryptoTransfer)
        XCTAssertEqual(postQuoteBankModelFour?.customerGuid, customerGuid)
        XCTAssertEqual(postQuoteBankModelFour?.asset, "BTC")
        XCTAssertEqual(postQuoteBankModelFour?.side, "withdrawal")
        XCTAssertEqual(postQuoteBankModelFour?.deliverAmount, "100000000")

        // -- Case: amountInFiat as TRue
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.isAmountInFiat.value = true
        viewModel.preQuoteBDValueObservable.value = "0.0001"
        let postQuoteBankModelFifth = viewModel.createPostQuoteBankModel(amount: "1")
        XCTAssertNotNil(postQuoteBankModelFifth)
        XCTAssertEqual(postQuoteBankModelFour?.productType, .cryptoTransfer)
        XCTAssertEqual(postQuoteBankModelFour?.customerGuid, customerGuid)
        XCTAssertEqual(postQuoteBankModelFour?.asset, "BTC")
        XCTAssertEqual(postQuoteBankModelFour?.side, "withdrawal")
        XCTAssertEqual(postQuoteBankModelFour?.deliverAmount, "100000000")
    }

    func test_calculatePreQuote_currentAccountNil() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- Case: currentAccount is nil
        viewModel.currentAccount.value = nil
        viewModel.calculatePreQuote()
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "0")

        // -- Case: currentAccount->asset is nil
        viewModel.currentAccount.value = AccountBankModel.mockWithNilAsset
        viewModel.calculatePreQuote()
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "0")
    }

    func test_calculatePreQuote_InFiat() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.currentAmountInput = "2"
        viewModel.isAmountInFiat.value = true
        viewModel.currentAsset.value = AssetBankModel.bitcoin
        viewModel.prices.value = .mockPrices

        // -- When
        viewModel.calculatePreQuote()

        // -- Then
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "₿0.00009901")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "0.00009901")
        XCTAssertFalse(viewModel.preQuoteValueHasErrorState.value)
    }

    func test_calculatePreQuote_InFiat_Overdue() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.currentAmountInput = "100000"
        viewModel.isAmountInFiat.value = true
        viewModel.currentAsset.value = AssetBankModel.bitcoin
        viewModel.prices.value = .mockPrices

        // -- When
        viewModel.calculatePreQuote()

        // -- Then
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "₿4.95078670")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "4.95078670")
        XCTAssertTrue(viewModel.preQuoteValueHasErrorState.value)
    }

    func test_calculatePreQuote_NotInFiat() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.currentAmountInput = "0.00002"
        viewModel.isAmountInFiat.value = false
        viewModel.currentAsset.value = AssetBankModel.bitcoin
        viewModel.prices.value = .mockPrices

        // -- When
        viewModel.calculatePreQuote()

        // -- Then
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "$0.40 USD")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "0.40")
        XCTAssertFalse(viewModel.preQuoteValueHasErrorState.value)
    }

    func test_calculatePreQuote_NotInFiat_Overdue() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.currentAmountInput = "3"
        viewModel.isAmountInFiat.value = false
        viewModel.currentAsset.value = AssetBankModel.bitcoin
        viewModel.prices.value = .mockPrices

        // -- When
        viewModel.calculatePreQuote()

        // -- Then
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "$60,596.43 USD")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "60596.43")
        XCTAssertTrue(viewModel.preQuoteValueHasErrorState.value)
    }

    func test_calculatePreQuote_With_PlatformBalance_Nil() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.tradingBalanceNil
        viewModel.currentAmountInput = "2"
        viewModel.isAmountInFiat.value = true
        viewModel.currentAsset.value = AssetBankModel.bitcoin
        viewModel.prices.value = .mockPrices

        // -- When
        viewModel.calculatePreQuote()

        // -- Then
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "₿0.00009901")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "0.00009901")
    }

    func test_calculatePreQuote_Without_Price() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.currentAmountInput = "2"
        viewModel.isAmountInFiat.value = true
        viewModel.currentAsset.value = AssetBankModel.bitcoin

        // -- When
        viewModel.calculatePreQuote()

        // -- Then
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "0")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "0")
    }

    func test_calculatePreQuote_Zero_Input() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.currentAmountInput = "0"

        // -- When
        viewModel.calculatePreQuote()

        // -- Then
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "0.00")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "0")
    }

    // MARK: Transfer Methods
    func test_createPostTransferBankModel() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- Case: currentQuote nil
        viewModel.currentQuote.value = nil
        let postTransferBankModelOne = viewModel.createPostTransferBankModel()
        XCTAssertNil(postTransferBankModelOne)

        // -- Case: currentWallet nil
        viewModel.currentQuote.value = QuoteBankModel.buyBitcoin
        viewModel.currentWallet.value = nil
        let postTransferBankModelTwo = viewModel.createPostTransferBankModel()
        XCTAssertNil(postTransferBankModelTwo)

        // -- Case: Good
        viewModel.currentQuote.value = QuoteBankModel.buyBitcoin
        viewModel.currentWallet.value = ExternalWalletBankModel.mock
        let postTransferBankModel = viewModel.createPostTransferBankModel()
        XCTAssertNotNil(postTransferBankModel)
        XCTAssertEqual(postTransferBankModel?.quoteGuid, "MOCK_GUID")
        XCTAssertEqual(postTransferBankModel?.transferType, .crypto)
        XCTAssertEqual(postTransferBankModel?.externalWalletGuid, "1234")
    }

    // MARK: Prices Methods
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

    // -- MARK: View Helper Methods
    func test_switchActionHandler() {

        // -- Given
        let viewModel = self.createViewModel()
        let transferInFiat = viewModel.isAmountInFiat.value

        // -- When
        viewModel.switchActionHandler(UIButton())

        // -- Then
        XCTAssertEqual(viewModel.isAmountInFiat.value, !transferInFiat)
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
        viewModel.isAmountInFiat.value = true
        viewModel.currentAsset.value = AssetBankModel.bitcoin
        viewModel.prices.value = .mockPrices

        // -- Case: Input text change equl to nul
        viewModel.textFieldDidChangeSelection(nil)
        XCTAssertEqual(viewModel.currentAmountInput, "0")
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "0.00")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "0")
        XCTAssertFalse(viewModel.preQuoteValueHasErrorState.value)

        // -- Case: Input text change equl to ""
        viewModel.textFieldDidChangeSelection("")
        XCTAssertEqual(viewModel.currentAmountInput, "")
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "0.00")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "0")
        XCTAssertFalse(viewModel.preQuoteValueHasErrorState.value)

        // -- Case: Input text change equl to "Hello"
        viewModel.textFieldDidChangeSelection("Hello")
        XCTAssertEqual(viewModel.currentAmountInput, "Hello")
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "0.00")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "0")
        XCTAssertFalse(viewModel.preQuoteValueHasErrorState.value)

        // -- Case: Input text change equl to "2"
        viewModel.textFieldDidChangeSelection("2")
        XCTAssertEqual(viewModel.currentAmountInput, "2")
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "₿0.00009901")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "0.00009901")
        XCTAssertFalse(viewModel.preQuoteValueHasErrorState.value)

        // -- Case: Input text change equl to "3.5"
        viewModel.textFieldDidChangeSelection("3.5")
        XCTAssertEqual(viewModel.currentAmountInput, "3.5")
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "₿0.00017327")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "0.00017327")
        XCTAssertFalse(viewModel.preQuoteValueHasErrorState.value)

        // -- Case: Input text change equl to "0.5"
        viewModel.textFieldDidChangeSelection(".5")
        XCTAssertEqual(viewModel.currentAmountInput, "0.5")
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "₿0.00002475")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "0.00002475")
        XCTAssertFalse(viewModel.preQuoteValueHasErrorState.value)

        // -- Case: Input text change equl to "1."
        viewModel.textFieldDidChangeSelection("1.")
        XCTAssertEqual(viewModel.currentAmountInput, "1.00")
        XCTAssertEqual(viewModel.preQuoteValueObservable.value, "₿0.00004950")
        XCTAssertEqual(viewModel.preQuoteBDValueObservable.value, "0.00004950")
        XCTAssertFalse(viewModel.preQuoteValueHasErrorState.value)
    }

    func test_resetAmountInput() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- Case: Empty
        viewModel.amountInputObservable.value = "1"
        viewModel.resetAmountInput()
        XCTAssertEqual(viewModel.amountInputObservable.value, "")

        // -- Case: Not Empty
        viewModel.amountInputObservable.value = "1"
        viewModel.resetAmountInput(amount: "2")
        XCTAssertEqual(viewModel.amountInputObservable.value, "2")
    }

    func test_canCreateQuote() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- Case: currentAccount is nil
        viewModel.currentAccount.value = nil
        let canOne = viewModel.canCreateQuote()
        XCTAssertFalse(canOne)

        // -- Case: currentWallet is nil
        viewModel.currentWallet.value = nil
        let canTwo = viewModel.canCreateQuote()
        XCTAssertFalse(canTwo)

        // -- Case: currentAmountInput is empty
        viewModel.currentAmountInput = ""
        let canThree = viewModel.canCreateQuote()
        XCTAssertFalse(canThree)

        // -- Case: currentAmountInput is 0
        viewModel.currentAmountInput = "0"
        let canFour = viewModel.canCreateQuote()
        XCTAssertFalse(canFour)

        // -- Case: Good
        viewModel.currentAccount.value = AccountBankModel.trading
        viewModel.currentWallet.value = ExternalWalletBankModel.mock
        viewModel.currentAmountInput = "1"
        let canFifth = viewModel.canCreateQuote()
        XCTAssertTrue(canFifth)
    }
}
