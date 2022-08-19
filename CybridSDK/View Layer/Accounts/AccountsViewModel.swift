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
    internal var prices: Observable<[CryptoPriceModel]> = .init([])
    internal var accountsObj: [AccountBankModel] = []
    internal var accounts: [AccountAssetPriceModel] = []

    // MARK: Private properties
    private var dataProvider: PricesRepoProvider & AssetsRepoProvider & AccountsRepoProvider
    private var logger: CybridLogger?

    init(dataProvider: PricesRepoProvider & AssetsRepoProvider & AccountsRepoProvider,
         logger: CybridLogger?) {
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
            switch accountsResult {
            case .success(let accountsList):
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.accountsObj = accountsList.objects
                self?.getPricesList()
            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    internal func getPricesList() {

        dataProvider.fetchPriceList(liveUpdateEnabled: true) { [weak self] pricesResult in

            switch pricesResult {
            case .success(let pricesList):
                self?.logger?.log(.component(.accounts(.pricesDataFetching)))
                guard let modelList = self?.buildModelList(symbols: pricesList, assets: self!.assets) else {
                  return
                }
                self?.prices.value = modelList

            case .failure:
                self?.logger?.log(.component(.accounts(.pricesDataError)))
            }
        }
    }

    private func buildModelList(symbols: [SymbolPriceBankModel], assets: [AssetBankModel]) -> [CryptoPriceModel] {
      return symbols.compactMap { priceModel in
        guard
          let hiphenIndex = priceModel.symbol?.firstIndex(of: "-"),
          let firstAssetCode = priceModel.symbol?.prefix(upTo: hiphenIndex),
          let firstAsset = assets.first(where: { $0.code == firstAssetCode }),
          let secondAssetCode = priceModel.symbol?.suffix(3),
          let secondAsset = assets.first(where: { $0.code == secondAssetCode })
        else {
          return nil
        }
        return CryptoPriceModel(symbolPrice: priceModel, asset: firstAsset, counterAsset: secondAsset)
      }
    }
}
