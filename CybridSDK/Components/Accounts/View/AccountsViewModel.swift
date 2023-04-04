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
    internal var assets = Cybrid.assets
    internal var accounts: [AccountBankModel] = []
    internal var prices: [SymbolPriceBankModel] = []
    internal var balances: Observable<[BalanceUIModel]> = .init([])
    internal var accountTotalBalance: Observable<String> = .init("")

    // MARK: Private properties
    private unowned var cellProvider: AccountsViewProvider
    private var dataProvider: PricesRepoProvider & AssetsRepoProvider & AccountsRepoProvider
    private var logger: CybridLogger?

    // -- MARK: Public properties
    var uiState: Observable<AccountsViewController.ViewState> = .init(.LOADING)

    // -- MARK: Poll
    internal var pricesPolling: Polling?

    init(cellProvider: AccountsViewProvider,
         dataProvider: PricesRepoProvider & AssetsRepoProvider & AccountsRepoProvider,
         logger: CybridLogger?) {

        self.cellProvider = cellProvider
        self.dataProvider = dataProvider
        self.logger = logger
    }

    func getAccounts() {

        self.dataProvider.fetchAccounts(customerGuid: Cybrid.customerGUID) { [weak self] accountsResult in

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

            if let list = self.buildModelList(
                assets: self.assets,
                accounts: self.accounts,
                prices: self.prices) {

                self.balances.value = list
                self.calculateTotalBalance()
            }
        }
    }

    internal func buildModelList(assets: [AssetBankModel],
                                 accounts: [AccountBankModel],
                                 prices: [SymbolPriceBankModel]) -> [BalanceUIModel]? {

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

// MARK: - AccountsViewProvider

protocol AccountsViewProvider: AnyObject {

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData dataModel: BalanceUIModel) -> UITableViewCell

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, withBalance balance: BalanceUIModel)
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
      return AccountsHeaderCell(currency: Cybrid.fiat.code)
  }

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      cellProvider.tableView(tableView, didSelectRowAt: indexPath, withBalance: balances.value[indexPath.row])
  }
}
