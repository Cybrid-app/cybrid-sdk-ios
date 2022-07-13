//
//  CryptoPriceViewModel.swift
//  CybridSDK
//
//  Created by Cybrid on 20/06/22.
//

import CybridApiBankSwift
import UIKit

protocol CryptoPriceViewProvider: AnyObject {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData dataModel: CryptoPriceModel) -> UITableViewCell
}

class CryptoPriceViewModel: NSObject {
  // MARK: Observed properties
  var cryptoPriceList: Observable<[CryptoPriceModel]> = .init([])

  // MARK: Private properties
  private unowned var cellProvider: CryptoPriceViewProvider
  private var dataProvider: SymbolsDataProvider & PricesDataProvider & AssetsDataProvider
  private var assetsList: [AssetListBankModel] = []
  private var pricesList: [SymbolPriceBankModel] = []

  init(cellProvider: CryptoPriceViewProvider, dataProvider: SymbolsDataProvider & PricesDataProvider & AssetsDataProvider) {
    self.cellProvider = cellProvider
    self.dataProvider = dataProvider
  }

  func fetchPriceList() {
    dataProvider.fetchAvailableSymbols { [weak self] symbolsResult in
      switch symbolsResult {
      case .success(let symbolList):
        let symbolListString: String = {
          var result: String = ""
          for symbol in symbolList {
            if symbol == symbolList.first {
              result += symbol
            } else {
              result += ",\(symbol)"
            }
          }
          return result
        }()
        self?.dataProvider.fetchPriceList(symbols: symbolListString) { pricesResult in
          switch pricesResult {
          case .success(let pricesList):
            self?.dataProvider.fetchAssetsList({ assetsResult in
              switch assetsResult {
              case .success(let assetsList):
                guard let modelList = self?.buildModelList(symbols: pricesList, assets: assetsList) else {
                  return
                }
                self?.cryptoPriceList.value = modelList
              case .failure(let error):
                print(error)
              }
            })
          case .failure(let error):
            print(error)
          }
        }
      case .failure(let error):
        print(error)
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

// MARK: - CryptoPriceViewModel + UITableViewDelegate + UITableViewDataSource

extension CryptoPriceViewModel: UITableViewDelegate, UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    cryptoPriceList.value.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    cellProvider.tableView(tableView, cellForRowAt: indexPath, withData: cryptoPriceList.value[indexPath.row])
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = CryptoPriceTableHeaderView()
    return view
  }
}
