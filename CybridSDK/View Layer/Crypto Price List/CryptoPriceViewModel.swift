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
  internal var filteredCryptoPriceList: Observable<[CryptoPriceModel]> = Observable([])
  internal var selectedCrypto: Observable<TradeViewModel?> = Observable(nil)

  // MARK: Private properties
  private unowned var cellProvider: CryptoPriceViewProvider
  private var dataProvider: PricesRepoProvider & AssetsRepoProvider
  private var logger: CybridLogger?

  init(cellProvider: CryptoPriceViewProvider,
       dataProvider: PricesRepoProvider & AssetsRepoProvider,
       logger: CybridLogger?) {
    self.cellProvider = cellProvider
    self.dataProvider = dataProvider
    self.logger = logger
  }

  func fetchPriceList(liveUpdateEnabled: Bool = true) {
    dataProvider.fetchAssetsList { [weak self] assetsResult in
      switch assetsResult {
      case .success(let assetsList):
        self?.logger?.log(.component(.priceList(.dataFetching)))
        self?.dataProvider.fetchPriceList(liveUpdateEnabled: liveUpdateEnabled) { pricesResult in
          switch pricesResult {
          case .success(let pricesList):
            self?.logger?.log(.component(.priceList(.dataRefreshed)))
            guard let modelList = self?.buildModelList(symbols: pricesList, assets: assetsList) else {
              return
            }
            self?.cryptoPriceList = modelList
            self?.filteredCryptoPriceList.value = modelList
          case .failure:
            self?.logger?.log(.component(.priceList(.dataError)))
          }
        }
      case .failure:
        self?.logger?.log(.component(.priceList(.dataError)))
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

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedModel = filteredCryptoPriceList.value[indexPath.row]
    guard
      let assetList = dataProvider.assetsCache,
      let selectedAsset = assetList.first(where: { $0.code == selectedModel.assetCode })
    else { return }
    let viewModel = TradeViewModel(selectedCrypto: selectedAsset,
                                   dataProvider: dataProvider,
                                   logger: logger)
    selectedCrypto.value = viewModel
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
