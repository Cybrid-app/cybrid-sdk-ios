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
    var accounts: [AccountBankModel] = []

    // MARK: View Values
    internal var segmentSelection: Observable<_TradeType> = Observable(.buy)

    // MARK: Constructor
    init(dataProvider: TradesRepoProvider & AccountsRepoProvider,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.logger = logger
    }

    // MARK: ViewModel Methods
    func onSelected(asset: AssetBankModel, pairAsset: AssetBankModel) {

        currentAsset.value = asset
        currentPairAsset.value = pairAsset
        uiState.value = .CONTENT
    }
    
    internal func fetchAccounts() {

        dataProvider.fetchAccounts(customerGuid: Cybrid.customerGUID) { [weak self] accountsResult in

            switch accountsResult {
            case .success(let accountsList):
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.accounts = accountsList.objects
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
}

extension TradeViewModel: UIPickerViewDelegate, UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return listPricesViewModel?.assets.count ?? 0
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listPricesViewModel?.assets[row].name ?? ""
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //cryptoCurrency.value = assetList.value[row]
        //updateConversion()
    }
}
