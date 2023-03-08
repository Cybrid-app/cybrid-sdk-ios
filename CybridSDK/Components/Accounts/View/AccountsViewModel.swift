//
//  AccountsViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 18/08/22.
//

import CybridApiBankSwift
import Foundation

class AccountsViewModel: NSObject {

    // MARK: Observed properties
    internal var assets: [AssetBankModel] = []
    internal var accounts: [AccountBankModel] = []
    internal var prices: [SymbolPriceBankModel] = []
    internal var balances: Observable<[AccountAssetPriceModel]> = .init([])
    internal var accountTotalBalance: Observable<String> = .init("")

    // MARK: Private properties
    private unowned var cellProvider: AccountsViewProvider
    private var dataProvider: PricesRepoProvider & AssetsRepoProvider & AccountsRepoProvider
    private var logger: CybridLogger?
    var currentCurrency: String = "USD"

    // -- MARK: Public properties
    var uiState: Observable<AccountsViewController.ViewState> = .init(.LOADING)

    // -- MARK: Poll
    internal var pricesPolling: Polling?

    init(cellProvider: AccountsViewProvider,
         dataProvider: PricesRepoProvider & AssetsRepoProvider & AccountsRepoProvider,
         logger: CybridLogger?,
         currency: String = "USD") {

        self.cellProvider = cellProvider
        self.dataProvider = dataProvider
        self.logger = logger
        self.currentCurrency = currency
    }

    internal func getAssetsList() async -> [AssetBankModel] {

        await withCheckedContinuation { continuation in
            dataProvider.fetchAssetsList { [weak self] assetsResult in
                switch assetsResult {
                case .success(let assetsList):

                    self?.logger?.log(.component(.accounts(.assetsDataFetching)))
                    continuation.resume(returning: assetsList)

                case .failure:
                    self?.logger?.log(.component(.accounts(.assetsDataError)))
                    continuation.resume(returning: [])
                }
            }
        }
    }

    func getAccounts() {

        if self.assets.isEmpty {
            Task { self.assets = await self.getAssetsList() }
        }

        dataProvider.fetchAccounts(customerGuid: Cybrid.customerGUID) { [weak self] accountsResult in

            switch accountsResult {
            case .success(let accountsList):
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.accounts = accountsList.objects
                self?.getPricesList()
            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    internal func getPricesList() {

        self.pricesPolling = Polling { [self] in
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
    }

    internal func createAccountsFormatted() {

        if !self.assets.isEmpty && !self.accounts.isEmpty && !self.prices.isEmpty {

            if let list = self.buildModelList(
                assets: self.assets,
                accounts: self.accounts,
                prices: self.prices) {

                self.balances.value = list
                self.calculateTotalBalance()
            }
        }
    }

    internal func buildModelList(
        assets: [AssetBankModel],
        accounts: [AccountBankModel],
        prices: [SymbolPriceBankModel]) -> [AccountAssetPriceModel]? {

      return accounts.compactMap { account in

        let code = account.asset ?? ""
        let symbol = "\(code)-\(currentCurrency)"
        let asset = assets.first(where: { $0.code == code })
        let counterAsset = assets.first(where: { $0.code == currentCurrency })
        let price = prices.first(where: { $0.symbol == symbol })
        return AccountAssetPriceModel(
            account: account,
            asset: asset,
            counterAsset: counterAsset,
            price: price)
      }
    }

    private func calculateTotalBalance() {

        if !self.assets.isEmpty && !self.balances.value.isEmpty {
            if let asset = assets.first(where: { $0.code == currentCurrency.uppercased() }) {

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

// MARK: - AccountsViewProvider

protocol AccountsViewProvider: AnyObject {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData dataModel: AccountAssetPriceModel) -> UITableViewCell

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, withBalance balance: AccountAssetPriceModel)
}

// MARK: - AccountsViewModel + UITableViewDelegate + UITableViewDataSource

extension AccountsViewModel: UITableViewDelegate, UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    balances.value.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    cellProvider.tableView(tableView, cellForRowAt: indexPath, withData: balances.value[indexPath.row])
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      return AccountsHeaderCell(currency: self.currentCurrency)
  }

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      cellProvider.tableView(tableView, didSelectRowAt: indexPath, withBalance: balances.value[indexPath.row])
  }
}
