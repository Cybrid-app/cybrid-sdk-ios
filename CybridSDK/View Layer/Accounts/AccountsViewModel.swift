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

    // MARK: Private properties
    private var dataProvider: PricesRepoProvider & AssetsRepoProvider & AccountsRepoProvider
    private var logger: CybridLogger?
    private var currentCurrency: String = "USD"

    init(dataProvider: PricesRepoProvider & AssetsRepoProvider & AccountsRepoProvider,
         logger: CybridLogger?,
         currency: String = "USD") {
      self.dataProvider = dataProvider
      self.logger = logger
    }

    func getAccounts() {

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
        dataProvider.fetchAccounts { [weak self] accountsResult in
            print(accountsResult)
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

        dataProvider.fetchPriceList(liveUpdateEnabled: true) { [weak self] pricesResult in
            print(pricesResult)
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

            case .failure(let error):
                print(error)
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
}
