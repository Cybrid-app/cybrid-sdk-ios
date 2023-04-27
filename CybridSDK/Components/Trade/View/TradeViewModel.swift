//
//  TradeViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 01/02/23.
//

import Foundation
import CybridApiBankSwift

class TradeViewModel: NSObject, ListPricesItemDelegate {

    // MARK: Private properties
    private var dataProvider: TradesRepoProvider & AccountsRepoProvider & QuotesRepoProvider
    private var logger: CybridLogger?

    // MARK: Internal properties
    internal var customerGuig = Cybrid.customerGUID
    internal var currentAsset: Observable<AssetBankModel?> = .init(nil)
    internal var currentPairAsset: Observable<AssetBankModel?> = .init(nil)
    internal var currentAccountToTrade: Observable<AccountAssetUIModel?> = .init(nil)
    internal var currentAccountPairToTrade: Observable<AccountAssetUIModel?> = .init(nil)
    internal var currentAmountInput = "0"
    internal var currentAmountWithPrice: Observable<String> = .init("0.0")

    // MARK: Public properties
    var uiState: Observable<TradeViewController.ViewState> = .init(.PRICES)
    var modalState: Observable<TradeViewController.ModalViewState> = .init(.LOADING)
    var listPricesViewModel: ListPricesViewModel?

    var accountsOriginal: [AccountBankModel] = []
    var accounts: [AccountAssetUIModel] = []
    var fiatAccounts: [AccountAssetUIModel] = []
    var tradingAccounts: [AccountAssetUIModel] = []

    // var assetSwitchTopToBottom: Observable<Bool> = .init(true)
    var quotePolling: Polling?
    var currentQuote: Observable<QuoteBankModel?> = .init(nil)
    var currentTrade: Observable<TradeBankModel?> = .init(nil)

    // MARK: View Values
    internal var segmentSelection: Observable<_TradeType> = Observable(.buy)

    // MARK: Constructor
    init(dataProvider: TradesRepoProvider & AccountsRepoProvider & QuotesRepoProvider,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.logger = logger
    }

    // MARK: List Prices select
    func onSelected(asset: AssetBankModel, pairAsset: AssetBankModel) {

        self.currentAsset.value = asset
        self.currentPairAsset.value = pairAsset
        self.fetchAccounts()
    }

    internal func fetchAccounts() {

        self.uiState.value = .LOADING
        self.initBindingValues()
        dataProvider.fetchAccounts(customerGuid: Cybrid.customerGUID) { [weak self] accountsResult in

            switch accountsResult {
            case .success(let accountsList):

                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                let accounts = accountsList.objects
                self?.accountsOriginal = accounts

                let accountsFormatted = self?.buildUIModelList(accounts: accounts) ?? []
                self?.accounts = accountsFormatted
                self?.fiatAccounts = accountsFormatted.filter { $0.account.type == .fiat }
                self?.tradingAccounts = accountsFormatted.filter { $0.account.type == .trading }
                self?.currentAccountToTrade.value = self?.tradingAccounts.first(where: {
                    $0.asset.code == self?.currentAsset.value?.code
                })
                self?.currentAccountPairToTrade.value = self?.fiatAccounts.first(where: {
                    $0.asset.code == self?.currentPairAsset.value?.code
                })
                self?.uiState.value = .CONTENT

            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    internal func buildUIModelList(accounts: [AccountBankModel]) -> [AccountAssetUIModel]? {

        return accounts.compactMap { account in
            guard
                let assets = listPricesViewModel?.assets,
                let asset = assets.first(where: { $0.code == account.asset })
            else {
                return nil
            }
            return AccountAssetUIModel(
                account: account,
                asset: asset)
        }
    }

    func initBindingValues() {

        self.listPricesViewModel?.filteredCryptoPriceList.bind { [self] _ in
            self.calculatePreQuote()
        }
    }

    // MARK: View Helper Methods
    @objc
    func segmentedControlValueChanged(_ sender: UISegmentedControl) {

        guard let selectedIndex = _TradeType(rawValue: sender.selectedSegmentIndex) else { return }
        self.segmentSelection.value = selectedIndex
    }

    @objc
    internal func switchAction(_ sender: UIButton) {
        self.switchActionHandler()
    }

    internal func switchActionHandler() {

        if self.currentAccountToTrade.value?.account.type == .fiat {
            self.currentAccountToTrade.value = self.tradingAccounts.first(where: {
                $0.asset.code == self.currentAsset.value?.code
            })
            self.currentAccountPairToTrade.value = self.fiatAccounts.first(where: {
                $0.asset.code == self.currentPairAsset.value?.code
            })
        } else {
            self.currentAccountToTrade.value = self.fiatAccounts.first(where: {
                $0.asset.code == self.currentPairAsset.value?.code
            })
            self.currentAccountPairToTrade.value = self.tradingAccounts.first(where: {
                $0.asset.code == self.currentAsset.value?.code
            })
        }
    }

    internal func calculatePreQuote() {

        let assetCode = currentAsset.value?.code ?? ""
        let pairAssetCode = currentPairAsset.value?.code ?? ""
        let symbol = "\(assetCode)-\(pairAssetCode)"
        let amount = CDecimal(self.currentAmountInput)
        if amount.newValue != "0.00" {

            let buyPrice = self.getPrice(symbol: symbol).buyPrice ?? "0"
            let asset = self.currentAccountToTrade.value?.asset
            let assetToConvert = self.currentAccountPairToTrade.value?.asset
            let amountFormatted = AssetFormatter.forInput(asset!, amount: amount)
            let tradeValue = AssetFormatter.trade(
                amount: amountFormatted,
                cryptoAsset: self.currentAsset.value!,
                price: buyPrice,
                base: asset?.type ?? .crypto)
            let tradeValueCDecimal = CDecimal(tradeValue)
            let tradeBase = AssetFormatter.forBase(assetToConvert!, amount: tradeValueCDecimal)
            let tradeFormatted = AssetFormatter.format(assetToConvert!, amount: tradeBase)
            self.currentAmountWithPrice.value = tradeFormatted
        } else {
            self.currentAmountWithPrice.value = amount.newValue
        }
    }

    internal func getPrice(symbol: String) -> SymbolPriceBankModel {

        let price = self.listPricesViewModel?.filteredCryptoPriceList.value.first(where: {
            $0.originalSymbol.symbol == symbol
        })
        return price?.originalSymbol ?? SymbolPriceBankModel()
    }

    internal func createPostQuote() -> PostQuoteBankModel {

        let assetCode = currentAsset.value?.code ?? ""
        let pairAssetCode = currentPairAsset.value?.code ?? ""
        let symbol = "\(assetCode)-\(pairAssetCode)"
        let amount = CDecimal(self.currentAmountInput)
        var postQuote = PostQuoteBankModel(side: .buy)

        switch segmentSelection.value {
        case .buy:
            if currentAccountToTrade.value?.asset.type == .crypto {
                let amountFormatted = AssetFormatter.forInput(currentAsset.value!, amount: amount)
                postQuote = PostQuoteBankModel(
                    productType: .trading,
                    customerGuid: self.customerGuig,
                    symbol: symbol,
                    side: .buy,
                    receiveAmount: amountFormatted
                )
            } else {
                let amountFormatted = AssetFormatter.forInput(currentPairAsset.value!, amount: amount)
                postQuote = PostQuoteBankModel(
                    productType: .trading,
                    customerGuid: self.customerGuig,
                    symbol: symbol,
                    side: .buy,
                    deliverAmount: amountFormatted
                )
            }

        case .sell:
            if currentAccountToTrade.value?.asset.type == .fiat {
                let amountFormatted = AssetFormatter.forInput(currentPairAsset.value!, amount: amount)
                postQuote = PostQuoteBankModel(
                    productType: .trading,
                    customerGuid: self.customerGuig,
                    symbol: symbol,
                    side: .sell,
                    receiveAmount: amountFormatted
                )
            } else {
                let amountFormatted = AssetFormatter.forInput(currentAsset.value!, amount: amount)
                postQuote = PostQuoteBankModel(
                    productType: .trading,
                    customerGuid: self.customerGuig,
                    symbol: symbol,
                    side: .sell,
                    deliverAmount: amountFormatted
                )
            }
        }
        return postQuote
    }

    func createQuote() {

        self.modalState.value = .LOADING
        self.quotePolling = Polling(interval: 8) {
            let postQuote = self.createPostQuote()
            self.dataProvider.createQuote(params: postQuote, with: nil) { [weak self] quoteResult in
                switch quoteResult {
                case .success(let quote):
                    self?.currentQuote.value = quote
                    self?.modalState.value = .CONTENT

                case .failure:
                    self?.logger?.log(.component(.accounts(.accountsDataError)))
                    self?.modalState.value = .ERROR
                    self?.stopQuotePolling()
                }
            }
        }
    }

    func createTrade() {

        self.stopQuotePolling()
        self.modalState.value = .SUBMITING
        self.dataProvider.createTrade(quoteGuid: (self.currentQuote.value?.guid)!) { [weak self] tradeResult in
            switch tradeResult {
            case .success(let quote):
                self?.currentTrade.value = quote
                self?.modalState.value = .SUCCESS

            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
                self?.modalState.value = .ERROR
            }
        }
    }

    func dismissModal() {

        self.modalState.value = .LOADING
        self.stopQuotePolling()
    }

    func stopQuotePolling() {

        self.quotePolling?.stop()
        self.quotePolling = nil
    }
}
