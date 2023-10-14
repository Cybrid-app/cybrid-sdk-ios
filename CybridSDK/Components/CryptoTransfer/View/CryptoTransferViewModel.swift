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
    internal var externalWallets: [ExternalWalletBankModel] = []
    internal var prices: Observable<[SymbolPriceBankModel]> = .init([])

    internal var currentAccount: Observable<AccountBankModel?> = .init(nil)
    internal var currentAsset: AssetBankModel?
    internal var currentExternalWallet: ExternalWalletBankModel?
    internal var currentAmountInput = "0"
    internal var currentQuote: Observable<QuoteBankModel?> = .init(nil)
    internal var currentTransfer: Observable<TransferBankModel?> = .init(nil)

    internal var isTransferInFiat: Observable<Bool> = .init(false)
    internal var amountInputObservable: Observable<String> = .init("")
    internal var amountWithPriceObservable: Observable<String> = .init("0.0")
    internal var amountWithPriceErrorObservable: Observable<Bool> = .init(false)

    internal var pricesPolling: Polling?

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
        dataProvider.fetchAccounts(customerGuid: customerGuid) { [self] accountsResponse in
            switch accountsResponse {
            case .success(let accountList):
                self.logger?.log(.component(.accounts(.accountsDataFetching)))
                self.accounts = accountList.objects
                self.fetchExternalWallets()
            case .failure:
                self.logger?.log(.component(.accounts(.accountsDataError)))
                self.uiState.value = .ERROR
            }
        }
    }

    internal func fetchExternalWallets() {

        dataProvider.fetchListExternalWallet { [self] externalWalletsListResponse in
            switch externalWalletsListResponse {
            case.success(let list):
                self.logger?.log(.component(.accounts(.accountsDataFetching)))
                let wallets = list.objects
                self.externalWallets = wallets.filter {
                    $0.state != .deleting && $0.state != .deleted
                }
                self.uiState.value = .CONTENT
            case .failure:
                self.logger?.log(.component(.accounts(.accountsDataError)))
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

    internal func createQuote(amount: String) {

        self.modalUiState.value = .LOADING
        guard let assetCode = self.currentAccount.value?.asset
        else {
            self.modalUiState.value = .ERROR
            return
        }
        guard let asset = try? Cybrid.findAsset(code: assetCode)
        else {
            self.modalUiState.value = .ERROR
            return
        }

        let amountDecimal = CDecimal(amount)
        let amountReady = AssetFormatter.forInput(asset, amount: amountDecimal)

        let side = PostQuoteBankModel.SideBankModel.withdrawal
        let postQuoteBankModel = PostQuoteBankModel(
            productType: .cryptoTransfer,
            customerGuid: self.customerGuid,
            asset: asset.code,
            side: side,
            deliverAmount: amountReady
        )
        self.dataProvider.createQuote(params: postQuoteBankModel, with: nil) { [weak self] quoteResponse in
            switch quoteResponse {
            case .success(let quote):
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.currentQuote.value = quote
                self?.modalUiState.value = .QUOTE
            case .failure(let error):
                self?.handleError(error)
                self?.modalUiState.value = .ERROR
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    internal func createTransfer() {

        self.modalUiState.value = .LOADING
        guard let currentQuote = self.currentQuote.value
        else {
            self.modalUiState.value = .ERROR
            return
        }

        let postTransferBankModel = PostTransferBankModel(
            quoteGuid: currentQuote.guid!,
            transferType: .crypto,
            externalWalletGuid: currentExternalWallet?.guid ?? ""
        )
        self.dataProvider.createTransfer(postTransferBankModel: postTransferBankModel) { [weak self] transferResponse in
            switch transferResponse {
            case .success(let transfer):
                self?.currentTransfer.value = transfer
                self?.modalUiState.value = .DONE
                self?.fetchAccounts()
            case .failure:
                self?.modalUiState.value = .ERROR
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    // MARK: ViewActions
    @objc
    internal func switchActionHandler(_ sender: UIButton) {
        self.isTransferInFiat.value = !self.isTransferInFiat.value
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

    // MARK: Functions for Accounts
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

    internal func resetAmountInput(amount: String = "") {
        self.amountInputObservable.value = amount
    }

    internal func changeCurrentAccount(_ account: AccountBankModel?) {

        if let account {
            let assetCode = account.asset
            let asset = try? Cybrid.findAsset(code: assetCode!)
            self.currentAsset = asset!
        }
    }

    // MARK: Functions for Prices
    internal func getPrice(symbol: String) -> SymbolPriceBankModel {

        let price = self.prices.value.first(where: {
            $0.symbol == symbol
        })
        return price ?? SymbolPriceBankModel()
    }

    // MARK: Functions for Quotes
    internal func calculatePreQuote() {

        self.amountWithPriceErrorObservable.value = false
        let assetCode = self.currentAccount.value?.asset
        let counterAssetCode = self.fiat.code
        let symbol = "\(assetCode!)-\(counterAssetCode)"
        let amount = CDecimal(self.currentAmountInput)
        if amount.newValue != "0.00" {

            let assetToUse = isTransferInFiat.value ? self.fiat : self.currentAsset!
            let assetToConvert = isTransferInFiat.value ? self.currentAsset! : self.fiat

            guard let buyPrice = self.getPrice(symbol: symbol).buyPrice
            else {
                self.amountWithPriceObservable.value = "0"
                return
            }

            let amountFromInput = AssetFormatter.forInput(
                assetToUse,
                amount: amount
            )
            let tradeValue = AssetFormatter.trade(
                amount: amountFromInput,
                cryptoAsset: self.currentAsset!,
                price: buyPrice,
                base: isTransferInFiat.value ? .fiat : .crypto
            )
            let tradeValueCDecimal = CDecimal(tradeValue)
            let platformBalance = CDecimal(self.currentAccount.value?.platformBalance ?? "0")

            // --
            if self.isTransferInFiat.value {
                if tradeValueCDecimal.intValue > platformBalance.intValue {
                    self.amountWithPriceErrorObservable.value = true
                }
            } else {
                let amountFromInputCD = CDecimal(amountFromInput)
                if amountFromInputCD.intValue > platformBalance.intValue {
                    self.amountWithPriceErrorObservable.value = true
                }
            }

            // --
            let tradeBase = AssetFormatter.forBase(assetToConvert, amount: tradeValueCDecimal)
            let tradeFormatted = AssetFormatter.format(assetToConvert, amount: tradeBase)
            self.amountWithPriceObservable.value = tradeFormatted

        } else {
            self.amountWithPriceObservable.value = amount.newValue
        }
    }
}
