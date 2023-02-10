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
    internal var currentAssetToTrade: Observable<AccountAssetUIModel?> = .init(nil)

    // MARK: Public properties
    var uiState: Observable<TradeViewController.ViewState> = .init(.PRICES)
    var listPricesViewModel: ListPricesViewModel?

    var accountsOriginal: [AccountBankModel] = []
    var accounts: [AccountAssetUIModel] = []
    var fiatAccounts: [AccountAssetUIModel] = []
    var tradingAccounts: [AccountAssetUIModel] = []

    var assetSwitchTopToBottom: Observable<Bool> = .init(true)

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

                let accountsFormatted = self?.buildUIModelList(accounts: accounts) ?? []
                self?.accounts = accountsFormatted
                self?.fiatAccounts = accountsFormatted.filter { $0.account.type == .fiat }
                self?.tradingAccounts = accountsFormatted.filter { $0.account.type == .trading }
                self?.currentAssetToTrade.value = self?.tradingAccounts.first(where: {
                    $0.asset.code == self?.currentAsset.value?.code
                })
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

    internal func buildUIModelList(accounts: [AccountBankModel]) -> [AccountAssetUIModel]? {

        return accounts.compactMap { account in
            guard
                let assets = listPricesViewModel?.assets,
                let asset = assets.first(where: { $0.code == account.asset })
            else {
                return nil
            }
            return AccountAssetUIModel(
                account: account,
                asset: asset)
        }
    }

    @objc
    internal func switchAction(_ sender: UIButton) {
        self.switchActionHandler()
    }

    internal func switchActionHandler() {

        if self.currentAssetToTrade.value?.account.type == .fiat {
            self.currentAssetToTrade.value = self.tradingAccounts.first(where: {
                $0.asset.code == self.currentAsset.value?.code
            })
        } else {
            self.currentAssetToTrade.value = self.fiatAccounts.first(where: {
                $0.asset.code == self.currentPairAsset.value?.code
            })
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

        let account: AccountAssetUIModel!
        if pickerView.accessibilityIdentifier == "fiatPicker" {
           account = fiatAccounts[row]
        } else {
            account = tradingAccounts[row]
        }

        let name = account.asset.name
        let asset = account.account.asset ?? ""
        return "\(name)(\(asset)) - \(account.balanceFormatted)"
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if pickerView.accessibilityIdentifier == "fiatPicker" {
            currentPairAsset.value = fiatAccounts[row].asset
        } else {
            currentAsset.value = tradingAccounts[row].asset
            currentAssetToTrade.value = self.tradingAccounts.first(where: {
                $0.asset.code == self.currentAsset.value?.code
            })
        }
    }
}

extension TradeViewModel: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {}
}
