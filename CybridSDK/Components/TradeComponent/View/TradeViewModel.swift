//
//  TradeViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 01/02/23.
//

import Foundation
import CybridApiBankSwift

class TradeViewModel: NSObject, ListPricesItemDelegate {

    // MARK: Private properties
    private var dataProvider: TradesRepoProvider & AccountsRepoProvider
    private var logger: CybridLogger?

    // MARK: Internal properties
    internal var customerGuig = Cybrid.customerGUID
    internal var currentAsset: Observable<AssetBankModel?> = .init(nil)
    internal var currentPairAsset: Observable<AssetBankModel?> = .init(nil)

    // MARK: Public properties
    var uiState: Observable<TradeViewController.ViewState> = .init(.PRICES)
    var listPricesViewModel: ListPricesViewModel?

    var accountsOriginal: [AccountBankModel] = []
    var accounts: [AccountAssetPriceModel] = []
    var fiatAccounts: [AccountAssetPriceModel] = []
    var tradingAccounts: [AccountAssetPriceModel] = []

    // MARK: View Values
    internal var segmentSelection: Observable<_TradeType> = Observable(.buy)

    // MARK: Constructor
    init(dataProvider: TradesRepoProvider & AccountsRepoProvider,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.logger = logger
    }

    func initBindingValues() {}

    // MARK: ViewModel Methods
    func onSelected(asset: AssetBankModel, pairAsset: AssetBankModel) {

        currentAsset.value = asset
        currentPairAsset.value = pairAsset
        fetchAccounts()
    }

    internal func fetchAccounts() {

        uiState.value = .LOADING
        dataProvider.fetchAccounts(customerGuid: Cybrid.customerGUID) { [weak self] accountsResult in

            switch accountsResult {
            case .success(let accountsList):

                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                let accounts = accountsList.objects
                self?.accountsOriginal = accounts

                let accountsFormatted = self?.buildModelList(accounts: accounts) ?? []
                self?.accounts = accountsFormatted
                self?.fiatAccounts = accountsFormatted.filter { $0.accountType == .fiat }
                self?.tradingAccounts = accountsFormatted.filter { $0.accountType == .trading }
                self?.uiState.value = .CONTENT

            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    // MARK: View Helper Methods
    @objc
    func segmentedControlValueChanged(_ sender: UISegmentedControl) {

      guard let selectedIndex = _TradeType(rawValue: sender.selectedSegmentIndex) else { return }
      self.segmentSelection.value = selectedIndex
    }

    internal func buildModelList(accounts: [AccountBankModel]) -> [AccountAssetPriceModel]? {

        return accounts.compactMap { account in
            guard
                let assets = listPricesViewModel?.assets,
                let prices = listPricesViewModel?.prices.value,
                let asset = assets.first(where: { $0.code == account.asset }),
                let assetCode = account.asset,
                let counterAsset = assets.first(where: { $0.code == currentPairAsset.value?.code }),
                let price = prices.first(where: { $0.symbol == "\(assetCode)-\(currentPairAsset.value?.code ?? "USD")" })
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

extension TradeViewModel: UIPickerViewDelegate, UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if pickerView.accessibilityIdentifier == "fiatPicker" {
            return fiatAccounts.count
        } else {
            return tradingAccounts.count
        }
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView.accessibilityIdentifier == "fiatPicker" {
            return fiatAccounts[row].assetName
        } else {
            return tradingAccounts[row].assetName
        }
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //cryptoCurrency.value = assetList.value[row]
        //updateConversion()
    }
}
