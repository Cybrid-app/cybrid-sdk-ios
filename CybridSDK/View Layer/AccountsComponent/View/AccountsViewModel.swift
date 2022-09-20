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
    internal var balances: Observable<[AccountAssetPriceModel]> = .init([])
    internal var accountTotalBalance: Observable<String> = .init("")

    // MARK: Private properties
    private unowned var cellProvider: AccountsViewProvider
    private var dataProvider: PricesRepoProvider & AssetsRepoProvider & AccountsRepoProvider
    private var logger: CybridLogger?
    var currentCurrency: String = "USD"

    init(cellProvider: AccountsViewProvider,
         dataProvider: PricesRepoProvider & AssetsRepoProvider & AccountsRepoProvider,
         logger: CybridLogger?,
         currency: String = "USD") {

        self.cellProvider = cellProvider
        self.dataProvider = dataProvider
        self.logger = logger
    }

    func getAccounts() {
        
        let test = BigDecimal("100")
        let test2 = AssetPipe.transform(value: test, decimals: 3, unit: .trade)
        let test3 = AssetPipe.transform(value: test, decimals: 3, unit: .base)
        print("LOLLL ============")
        print(test.toPlainString())
        print(test2.toPlainString())
        print(test3.toPlainString())
        print("===================")

        self.getAssetsList()
    }

    internal func getAssetsList() {

        if assets.isEmpty {
            dataProvider.fetchAssetsList { [weak self] assetsResult in
                switch assetsResult {
                case .success(let assetsList):

                    self?.logger?.log(.component(.accounts(.assetsDataFetching)))
                    self?.assets = assetsList
                    self?.getAccountsList()

                case .failure:
                    self?.logger?.log(.component(.accounts(.assetsDataError)))
                }
            }
        } else {
            self.getAccountsList()
        }
    }

    internal func getAccountsList() {

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

        dataProvider.fetchPriceList(with: TaskScheduler()) { [weak self] pricesResult in

            switch pricesResult {
            case .success(let pricesList):
                self?.logger?.log(.component(.accounts(.pricesDataFetching)))
                guard let modelList = self?.buildModelList(
                    assets: self?.assets ?? [],
                    accounts: self?.accounts ?? [],
                    prices: pricesList) else {
                  return
                }
                self?.balances.value = modelList
                self?.calculateTotalBalance()

            case .failure(let error):
                self?.logger?.log(.component(.accounts(.pricesDataError)))
            }
        }
    }

    private func buildModelList(
        assets: [AssetBankModel],
        accounts: [AccountBankModel],
        prices: [SymbolPriceBankModel]) -> [AccountAssetPriceModel]? {
      return accounts.compactMap { account in
        guard
          let asset = assets.first(where: { $0.code == account.asset }),
          let assetCode = account.asset,
          let counterAsset = assets.first(where: { $0.code == currentCurrency }),
          let price = prices.first(where: { $0.symbol == "\(assetCode)-\(currentCurrency)" })

        else {
          return nil
        }
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

                var total = SBigDecimal(0).value
                for balance in self.balances.value {
                    total += balance.accountBalanceInFiat.value
                }
                let totalBigDecimal = SBigDecimal(total, precision: asset.decimals)
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