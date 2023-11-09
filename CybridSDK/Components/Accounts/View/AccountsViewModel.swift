//
//  AccountsViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 18/08/22.
//

import CybridApiBankSwift
import Foundation

open class AccountsViewModel: NSObject {

    // MARK: Observed properties
    internal var assets = Cybrid.assets
    internal var accounts: [AccountBankModel] = []
    internal var prices: [SymbolPriceBankModel] = []
    internal var balances: Observable<[BalanceUIModel]> = .init([])
    internal var accountTotalBalance: Observable<String> = .init("")
    internal var customerGuid = Cybrid.customerGuid

    // MARK: Private properties
    private var dataProvider: PricesRepoProvider & AssetsRepoProvider & AccountsRepoProvider
    private var logger: CybridLogger?

    // -- MARK: Public properties
    var uiState: Observable<AccountsView.State> = .init(.LOADING)

    // -- MARK: Poll
    internal var pricesPolling: Polling?

    init(dataProvider: PricesRepoProvider & AssetsRepoProvider & AccountsRepoProvider,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.logger = logger
    }

    func getAccounts() {

        self.dataProvider.fetchAccounts(customerGuid: self.customerGuid) { [weak self] accountsResult in

            switch accountsResult {
            case .success(let accountsList):
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.accounts = accountsList.objects
                self?.pricesPolling = Polling { [self] in
                    self?.getPricesList()
                }

            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    internal func getPricesList() {

        self.dataProvider.fetchPriceList { [weak self] pricesResult in

            switch pricesResult {
            case .success(let pricesList):

                self?.logger?.log(.component(.accounts(.pricesDataFetching)))
                self?.prices = pricesList
                self?.createAccountsFormatted()
                if self?.uiState.value == .LOADING {
                    self?.uiState.value = .CONTENT
                }

            case .failure:
                self?.logger?.log(.component(.accounts(.pricesDataError)))
            }
        }
    }

    internal func createAccountsFormatted() {

        if !self.assets.isEmpty && !self.accounts.isEmpty && !self.prices.isEmpty {

            // Dividing accounts in fiat and trading
            var fiatAccounts: [AccountBankModel] = []
            var tradingAccounts: [AccountBankModel] = []
            for account in self.accounts {
                switch account.type {
                case .fiat:
                    fiatAccounts.append(account)
                case .trading:
                    tradingAccounts.append(account)
                default:
                    ()
                }
            }
            tradingAccounts = tradingAccounts.sorted(by: { $0.asset! < $1.asset! })

            var fiatList: [BalanceUIModel] = self.buildModelList(
                assets: self.assets,
                accounts: fiatAccounts,
                prices: self.prices)
            let tradingList: [BalanceUIModel] = self.buildModelList(
                assets: self.assets,
                accounts: tradingAccounts,
                prices: self.prices)

            fiatList.append(contentsOf: tradingList)
            self.balances.value = fiatList
            self.calculateTotalBalance()
        }
    }

    internal func buildModelList(assets: [AssetBankModel],
                                 accounts: [AccountBankModel],
                                 prices: [SymbolPriceBankModel]) -> [BalanceUIModel] {

        return accounts.compactMap { account in

            let fiatCode = Cybrid.fiat.code
            let code = account.asset!
            let symbol = "\(code)-\(fiatCode)"
            let asset = assets.first(where: { $0.code == code })
            let counterAsset = assets.first(where: { $0.code == fiatCode })
            let price = prices.first(where: { $0.symbol == symbol })
            return BalanceUIModel(
                account: account,
                asset: asset,
                counterAsset: counterAsset,
                price: price)
        }
    }

    internal func calculateTotalBalance() {

        if !self.assets.isEmpty && !self.balances.value.isEmpty {
            if let asset = assets.first(where: { $0.code == Cybrid.fiat.code.uppercased() }) {

                var total = BigDecimal(0).value
                for balance in self.balances.value {
                    total += balance.accountBalanceInFiat.value
                }
                let totalBigDecimal = BigDecimal(total, precision: asset.decimals)
                let totalFormatted = CybridCurrencyFormatter.formatPrice(totalBigDecimal, with: asset.symbol)
                self.accountTotalBalance.value = "\(totalFormatted) \(asset.code)"
            }
        }
    }
}
