//
//  AccountsViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 16/08/22.
//

import Foundation
import CybridApiBankSwift

class AccountsViewModel: NSObject {
    
    // MARK: Observed properties
    internal var assets: [AssetBankModel] = []
    internal var prices: Observable<[CryptoPriceModel]> = .init([])
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
        if (assets.count == 0) {
            dataProvider.fetchAssetsList { [weak self] assetsResult in
                switch assetsResult {
                case .success(let assetsList):
                    
                    self?.logger?.log(.component(.priceList(.dataFetching)))
                    self?.assets = assetsList
                    self?.getPricesList()
                
                case .failure:
                    self?.logger?.log(.component(.priceList(.dataError)))
                }
            }
        } else {
            self.getPricesList()
        }
    }
    
    internal func getAccountsList() {
        
    }
        
    internal func getPricesList() {
        
        dataProvider.fetchPriceList(liveUpdateEnabled: true) { [weak self] pricesResult in
            
            switch pricesResult {
            case .success(let pricesList):
                self?.logger?.log(.component(.priceList(.dataRefreshed)))
                guard let modelList = self?.buildModelList(symbols: pricesList, assets: self!.assets) else {
                  return
                }
                self?.prices.value = modelList
            
            case .failure:
                self?.logger?.log(.component(.priceList(.dataError)))
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
