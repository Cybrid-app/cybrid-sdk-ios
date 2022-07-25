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
  internal var cryptoPriceList: [CryptoPriceModel] = []
  internal var filteredCryptoPriceList: Observable<[CryptoPriceModel]> = .init([])

  // MARK: Private properties
  private unowned var cellProvider: CryptoPriceViewProvider
  private var dataProvider: PricesRepoProvider & AssetsRepoProvider

  init(cellProvider: CryptoPriceViewProvider, dataProvider: PricesRepoProvider & AssetsRepoProvider) {
    self.cellProvider = cellProvider
    self.dataProvider = dataProvider
  }

  func startLivePriceUpdates() {
    dataProvider.fetchAssetsList { [weak self] assetsResult in
      switch assetsResult {
      case .success(let assetsList):
        self?.dataProvider.fetchPriceList { pricesResult in
          switch pricesResult {
          case .success(let pricesList):
            guard let modelList = self?.buildModelList(symbols: pricesList, assets: assetsList) else {
              return
            }
            self?.cryptoPriceList = modelList
            self?.filteredCryptoPriceList.value = modelList
          case .failure(let error):
            print(error)
          }
        }
      case .failure(let error):
        print(error)
      }
    }
  }

  func stopLiveUpdates() {
    self.dataProvider.pricesFetchScheduler.cancel()
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
    filteredCryptoPriceList.value.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    cellProvider.tableView(tableView, cellForRowAt: indexPath, withData: filteredCryptoPriceList.value[indexPath.row])
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = CryptoPriceTableHeaderView(delegate: self)
    return view
  }
}

// MARK: - CryptoPriceViewModel + UISearchBarDelegate

extension CryptoPriceViewModel: UISearchTextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    filterPriceList(with: textField.text)
  }

  func filterPriceList(with text: String?) {
    guard let searchText = text, !searchText.isEmpty else {
      filteredCryptoPriceList.value = cryptoPriceList
      return
    }
    filteredCryptoPriceList.value = cryptoPriceList.filter({ model in
      model.assetName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
      || model.assetCode.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
    })
  }
}
