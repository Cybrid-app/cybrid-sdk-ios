//
//  CryptoTransferViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 15/09/23.
//

import Foundation
import CybridApiBankSwift

open class CryptoTransferViewModel: BaseViewModel {

    typealias DataProvider = AccountsRepoProvider & ExternalWalletRepoProvider & PricesRepoProvider & QuotesRepoProvider & TransfersRepoProvider

    // MARK: Private properties
    private var dataProvider: DataProvider
    private var logger: CybridLogger?

    // MARK: Internal properties
    internal var customerGuid = Cybrid.customerGuid
    internal var assets = Cybrid.assets
    internal var fiat = Cybrid.fiat
    internal var accounts: [AccountBankModel] = []
    internal var wallets: [ExternalWalletBankModel] = []
    internal var prices: Observable<[SymbolPriceBankModel]> = .init([])
    internal var pricesPolling: Polling?

    internal var currentAccount: Observable<AccountBankModel?> = .init(nil)
    internal var currentWallets: Observable<[ExternalWalletBankModel]> = .init([])
    internal var currentAsset: Observable<AssetBankModel?> = .init(nil)
    internal var currentWallet: Observable<ExternalWalletBankModel?> = .init(nil)
    internal var currentAmountInput = "0"
    internal var amountInputObservable: Observable<String> = .init("")
    internal var isAmountInFiat: Observable<Bool> = .init(false)
    internal var preQuoteValueObservable: Observable<String> = .init("0.0")
    internal var preQuoteBDValueObservable: Observable<String> = .init("0")
    internal var preQuoteValueHasErrorState: Observable<Bool> = .init(false)

    internal var currentQuote: Observable<QuoteBankModel?> = .init(nil)
    internal var currentTransfer: Observable<TransferBankModel?> = .init(nil)

    // MARK: Public properties
    var uiState: Observable<CryptoTransferView.State> = .init(.LOADING)
    var modalUiState: Observable<CryptoTransferView.ModalState> = .init(.LOADING)

    // MARK: Constructor
    init(dataProvider: DataProvider,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.logger = logger
    }

    func initComponent() {

        self.fetchAccounts()
        self.pricesPolling = Polling { self.fetchPrices() }
    }

    // MARK: Internal server methods
    internal func fetchAccounts() {

        self.uiState.value = .LOADING
        self.resetValues()
        dataProvider.fetchAccounts(customerGuid: customerGuid) { [self] accountsResponse in
            switch accountsResponse {
            case .success(let accountList):

                // -- Log
                self.logger?.log(.component(.accounts(.accountsDataFetching)))

                // -- Set accounts (Only trading accounts)
                self.accounts = accountList.objects
                self.accounts = self.accounts.filter { $0.type == .trading }
                self.accounts = self.accounts.sorted(by: { $0.asset! < $1.asset! })

                // -- Choosing first account
                if !self.accounts.isEmpty { self.changeCurrentAccount(self.accounts.first!) }

                // -- Fetch External Wallets
                self.fetchExternalWallets()

            case .failure:
                self.logger?.log(.component(.accounts(.accountsDataError)))
                self.accounts = []
                self.uiState.value = .ERROR
            }
        }
    }

    internal func fetchExternalWallets() {

        dataProvider.fetchListExternalWallet { [self] externalWalletsListResponse in
            switch externalWalletsListResponse {
            case.success(let list):

                // -- Log
                self.logger?.log(.component(.accounts(.accountsDataFetching)))

                // -- Set wallets (Only active wallets)
                let allWallets = list.objects
                self.wallets = allWallets.filter {
                    $0.state != .deleting && $0.state != .deleted
                }
                self.wallets = self.wallets.sorted(by: { $0.name! > $1.name! })

                // -- Change current account
                if self.currentAccount.value != nil { self.changeCurrentAccount(currentAccount.value!) }

                // -- UI State
                self.uiState.value = .CONTENT

            case .failure:
                self.logger?.log(.component(.accounts(.accountsDataError)))
                self.wallets = []
                self.uiState.value = .ERROR
            }
        }
    }

    internal func fetchPrices() {
        self.dataProvider.fetchPriceList { [self] pricesResponse in
            switch pricesResponse {
            case .success(let prices):
                self.logger?.log(.component(.accounts(.accountsDataFetching)))
                self.prices.value = prices
            case .failure:
                self.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    internal func createQuote() {

        self.modalUiState.value = .LOADING

        // -- Create PostQuoteBankModel
        guard let postQuoteBankModel = self.createPostQuoteBankModel(amount: self.currentAmountInput)
        else {
            self.logger?.log(.component(.accounts(.accountsDataError)))
            modalUiState.value = .ERROR
            return
        }

        // -- Create Quote
        self.dataProvider.createQuote(params: postQuoteBankModel, with: nil) { [weak self] quoteResponse in
            switch quoteResponse {
            case .success(let quote):
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.currentQuote.value = quote
                self?.modalUiState.value = .QUOTE
            case .failure(let error):
                self?.handleError(error)
                self?.currentQuote.value = nil
                self?.modalUiState.value = .ERROR
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    internal func createTransfer() {

        self.modalUiState.value = .LOADING

        // -- Create PostTransferBankModel
        guard let postTransferBankModel = self.createPostTransferBankModel()
        else {
            self.logger?.log(.component(.accounts(.accountsDataError)))
            modalUiState.value = .ERROR
            return
        }

        // -- Create Transfer
        self.dataProvider.createTransfer(postTransferBankModel: postTransferBankModel) { [weak self] transferResponse in
            switch transferResponse {
            case .success(let transfer):
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.currentTransfer.value = transfer
                self?.modalUiState.value = .DONE
            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
                self?.currentQuote.value = nil
                self?.currentTransfer.value = nil
                self?.modalUiState.value = .ERROR
            }
        }
    }

    // MARK: Accounts Methods
    internal func changeCurrentAccount(_ account: AccountBankModel) {

        self.currentAccount.value = account
        let assetCode = self.currentAccount.value?.asset ?? ""

        // -- Changing current wallet
        self.currentWallets.value = self.wallets.filter { $0.asset == assetCode }
        self.currentWallet.value = self.currentWallets.value.isEmpty ? nil : self.currentWallets.value.first

        // -- Changing current asset
        self.currentAsset.value = try? Cybrid.findAsset(code: assetCode)

        // -- Setting as no fiat
        self.isAmountInFiat.value = false
    }

    internal func getMaxAmountOfAccount() -> String {

        var valueFormatted = "0"
        let assetCode = self.currentAccount.value?.asset ?? ""

        guard let asset = try? Cybrid.findAsset(code: assetCode)
        else { return valueFormatted }

        let account = self.currentAccount.value
        let accountValue = account?.platformBalance
        let accountValueCDecimal = CDecimal(accountValue!)
        if accountValueCDecimal.newValue == "0.00" {
            return valueFormatted
        }
        valueFormatted = AssetFormatter.forBase(asset, amount: accountValueCDecimal)
        return valueFormatted
    }

    internal func resetValues() {

        self.currentWallet.value = nil
        self.currentAmountInput = "0"
        self.isAmountInFiat.value = false
        self.preQuoteValueObservable.value = "0.0"
        self.preQuoteBDValueObservable.value = "0"
        self.preQuoteValueHasErrorState.value = false
        self.amountInputObservable.value = ""
    }

    // MARK: Quote Methods
    internal func createPostQuoteBankModel(amount: String) -> PostQuoteBankModel? {

        guard let assetCode = self.currentAccount.value?.asset
        else {
            self.modalUiState.value = .ERROR
            return nil
        }

        guard let asset = try? Cybrid.findAsset(code: assetCode)
        else {
            self.modalUiState.value = .ERROR
            return nil
        }

        let amountDecimal = isAmountInFiat.value ? CDecimal(preQuoteBDValueObservable.value) : CDecimal(amount)
        let amountReady = AssetFormatter.forInput(asset, amount: amountDecimal)
        return PostQuoteBankModel(
            productType: .cryptoTransfer,
            customerGuid: self.customerGuid,
            asset: asset.code,
            side: PostQuoteBankModel.SideBankModel.withdrawal,
            deliverAmount: amountReady
        )
    }

    internal func calculatePreQuote() {

        self.preQuoteValueHasErrorState.value = false

        guard let assetCode = self.currentAccount.value?.asset
        else {
            self.preQuoteValueObservable.value = "0"
            return
        }

        let counterAssetCode = self.fiat.code
        let symbol = "\(assetCode)-\(counterAssetCode)"
        let amount = CDecimal(self.currentAmountInput)
        if amount.newValue != "0.00" {

            let assetToUse = isAmountInFiat.value ? self.fiat : self.currentAsset.value!
            let assetToConvert = isAmountInFiat.value ? self.currentAsset.value! : self.fiat

            guard let sellPrice = self.getPrice(symbol: symbol).sellPrice
            else {
                self.preQuoteValueObservable.value = "0"
                return
            }

            let amountFromInput = AssetFormatter.forInput(
                assetToUse,
                amount: amount
            )
            let tradeValue = AssetFormatter.trade(
                amount: amountFromInput,
                cryptoAsset: self.currentAsset.value!,
                price: sellPrice,
                base: isAmountInFiat.value ? .fiat : .crypto
            )
            let tradeValueCDecimal = CDecimal(tradeValue)
            let platformBalance = CDecimal(self.currentAccount.value?.platformBalance ?? "0")

            // --
            if self.isAmountInFiat.value { // Input example: 1 USD

                if tradeValueCDecimal.intValue > platformBalance.intValue {
                    self.preQuoteValueHasErrorState.value = true
                }

            } else { // Input example: 1 BTC

                let amountFromInputCD = CDecimal(amountFromInput)
                if amountFromInputCD.intValue > platformBalance.intValue {
                    self.preQuoteValueHasErrorState.value = true
                }
            }

            // --
            let tradeBase = AssetFormatter.forBase(assetToConvert, amount: tradeValueCDecimal)
            self.preQuoteBDValueObservable.value = tradeBase

            let tradeFormatted = AssetFormatter.format(assetToConvert, amount: tradeBase)
            self.preQuoteValueObservable.value = tradeFormatted

        } else {
            self.preQuoteValueObservable.value = amount.newValue
        }
    }

    // MARK: Transfer Methods
    internal func createPostTransferBankModel() -> PostTransferBankModel? {

        guard let currentQuote = self.currentQuote.value
        else { return nil }

        guard let currentWallet = self.currentWallet.value
        else { return nil }

        return PostTransferBankModel(
            quoteGuid: currentQuote.guid!,
            transferType: .crypto,
            externalWalletGuid: currentWallet.guid!
        )
    }

    // MARK: Prices Methods
    internal func getPrice(symbol: String) -> SymbolPriceBankModel {

        let price = self.prices.value.first(where: {
            $0.symbol == symbol
        })
        return price ?? SymbolPriceBankModel()
    }

    // MARK: View Helper Methods
    @objc
    internal func switchActionHandler(_ sender: UIButton) {
        self.isAmountInFiat.value = !self.isAmountInFiat.value
    }

    @objc
    func maxButtonClickHandler() {

        let amount = self.getMaxAmountOfAccount()
        self.resetAmountInput(amount: amount)
    }

    func textFieldDidChangeSelection(_ text: String?) {

        var amountString = text ?? "0"
        if amountString.contains(".") {

            let leftSide = "0"
            let rightSide = "00"
            let stringParts = amountString.getParts()

            if stringParts[0] == "." {
                amountString = "\(leftSide)\(amountString)"
            }

            if stringParts[stringParts.count - 1] == "." {
                amountString = "\(amountString)\(rightSide)"
            }
        }
        self.currentAmountInput = amountString
        self.calculatePreQuote()
    }

    internal func resetAmountInput(amount: String = "") {
        self.amountInputObservable.value = amount
    }

    internal func canCreateQuote() -> Bool {
        return (self.currentAccount.value != nil) && (self.currentWallet.value != nil) && (!self.currentAmountInput.isEmpty && self.currentAmountInput != "0")
    }
}
