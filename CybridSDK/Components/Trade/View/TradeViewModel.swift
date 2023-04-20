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
    internal var currentAccountToTrade: Observable<AccountAssetUIModel?> = .init(nil)
    internal var currentAccountPairToTrade: Observable<AccountAssetUIModel?> = .init(nil)
    internal var currentAmountInput = "0"
    internal var currentAmountWithPrice: Observable<String> = .init("0.0")

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

    // MARK: List Prices select
    func onSelected(asset: AssetBankModel, pairAsset: AssetBankModel) {

        self.currentAsset.value = asset
        self.currentPairAsset.value = pairAsset
        self.fetchAccounts()
    }

    internal func fetchAccounts() {

        self.uiState.value = .LOADING
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
                self?.currentAccountToTrade.value = self?.tradingAccounts.first(where: {
                    $0.asset.code == self?.currentAsset.value?.code
                })
                self?.currentAccountPairToTrade.value = self?.fiatAccounts.first(where: {
                    $0.asset.code == self?.currentPairAsset.value?.code
                })
                self?.uiState.value = .CONTENT

            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
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

    func initBindingValues() {}

    // MARK: View Helper Methods
    @objc
    func segmentedControlValueChanged(_ sender: UISegmentedControl) {

      guard let selectedIndex = _TradeType(rawValue: sender.selectedSegmentIndex) else { return }
      self.segmentSelection.value = selectedIndex
    }

    @objc
    internal func switchAction(_ sender: UIButton) {
        self.switchActionHandler()
    }

    internal func switchActionHandler() {

        if self.currentAccountToTrade.value?.account.type == .fiat {
            self.currentAccountToTrade.value = self.tradingAccounts.first(where: {
                $0.asset.code == self.currentAsset.value?.code
            })
            self.currentAccountPairToTrade.value = self.fiatAccounts.first(where: {
                $0.asset.code == self.currentPairAsset.value?.code
            })
        } else {
            self.currentAccountToTrade.value = self.fiatAccounts.first(where: {
                $0.asset.code == self.currentPairAsset.value?.code
            })
            self.currentAccountPairToTrade.value = self.tradingAccounts.first(where: {
                $0.asset.code == self.currentAsset.value?.code
            })
        }
    }

    internal func calculatePreQuote() {

        let assetCode = currentAsset.value?.code ?? ""
        let pairAssetCode = currentPairAsset.value?.code ?? ""
        let symbol = "\(assetCode)-\(pairAssetCode)"
        let amount = CDecimal(self.currentAmountInput)
        if amount.newValue != "0.00" {

            let buyPrice = self.getPrice(symbol: symbol).buyPrice ?? "0"
            let asset = self.currentAccountToTrade.value?.asset
            let assetToConvert = self.currentAccountPairToTrade.value?.asset
            let amountFormatted = AssetFormatter.forInput(asset!, amount: amount)
            let tradeValue = AssetFormatter.trade(
                amount: amountFormatted,
                cryptoAsset: self.currentAsset.value!,
                price: buyPrice,
                base: asset?.type ?? .crypto)
            let tradeValueCDecimal = CDecimal(tradeValue)
            let tradeBase = AssetFormatter.forBase(assetToConvert!, amount: tradeValueCDecimal)
            let tradeFormatted = AssetFormatter.format(assetToConvert!, amount: tradeBase)
            self.currentAmountWithPrice.value = tradeFormatted
        } else {
            self.currentAmountWithPrice.value = amount.newValue
        }
    }

    internal func getPrice(symbol: String) -> SymbolPriceBankModel {

        let price = self.listPricesViewModel?.filteredCryptoPriceList.value.first(where: {
            $0.originalSymbol.symbol == symbol
        })
        return price?.originalSymbol ?? SymbolPriceBankModel()
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
            currentAccountToTrade.value = self.tradingAccounts.first(where: {
                $0.asset.code == self.currentAsset.value?.code
            })
        }
    }
}

extension TradeViewModel: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {

        var amountString = textField.text ?? "0"
        if amountString.contains(".") {

            let leftSide = "0"
            let rightSide = "00"
            let stringParts = amountString.getParts()

            if stringParts[0] == "." {
                amountString = "\(leftSide)\(amountString)"
            }

            if stringParts[stringParts.count - 1] == "." {
                amountString = "\(amountString)\(rightSide)"
            }
        }
        self.currentAmountInput = amountString
        self.calculatePreQuote()
    }
}
