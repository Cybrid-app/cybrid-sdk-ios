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

  typealias DataProvider = PricesRepoProvider & AssetsRepoProvider & QuotesRepoProvider & TradesRepoProvider

  // MARK: Observed properties
  internal var cryptoPriceList: [CryptoPriceModel] = []
  internal var filteredCryptoPriceList: Observable<[CryptoPriceModel]> = Observable([])
  internal var selectedCrypto: Observable<_TradeViewModel?> = Observable(nil)
  internal var taskScheduler: TaskScheduler?

  // MARK: Private properties
  private unowned var cellProvider: CryptoPriceViewProvider
  private var dataProvider: DataProvider
  private var logger: CybridLogger?

  init(cellProvider: CryptoPriceViewProvider,
       dataProvider: DataProvider,
       logger: CybridLogger?,
       taskScheduler: TaskScheduler? = nil) {

    self.cellProvider = cellProvider
    self.dataProvider = dataProvider
    self.logger = logger
    self.taskScheduler = taskScheduler ?? TaskScheduler()
  }

  private func registerScheduler() {

    if let scheduler = taskScheduler {
      Cybrid.session.taskSchedulers.insert(scheduler)
    }
  }

  func fetchPriceList(with taskScheduler: TaskScheduler? = nil) {

    registerScheduler()
    dataProvider.fetchAssetsList { [weak self] assetsResult in
      switch assetsResult {
      case .success(let assetsList):
        self?.logger?.log(.component(.priceList(.dataFetching)))
        self?.dataProvider.fetchPriceList(with: taskScheduler ?? self?.taskScheduler) { pricesResult in
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

    taskScheduler?.cancel()
    if let taskScheduler = taskScheduler {
      Cybrid.session.taskSchedulers.remove(taskScheduler)
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
    return filteredCryptoPriceList.value.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    cellProvider.tableView(tableView, cellForRowAt: indexPath, withData: filteredCryptoPriceList.value[indexPath.row])
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = CryptoPriceTableHeaderView(delegate: self)
    return view
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

    let spinner = UIActivityIndicatorView(style: .medium)
    spinner.startAnimating()
    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
    return filteredCryptoPriceList.value.isEmpty ? spinner : nil
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedModel = filteredCryptoPriceList.value[indexPath.row]
    guard
      let assetList = dataProvider.assetsCache,
      let selectedAsset = assetList.first(where: { $0.code == selectedModel.assetCode })
    else { return }
    let viewModel = _TradeViewModel(selectedCrypto: selectedAsset,
                                   dataProvider: dataProvider,
                                   logger: logger)
    selectedCrypto.value = viewModel
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    let lastSectionIndex = tableView.numberOfSections - 1
    let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
    if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {}
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