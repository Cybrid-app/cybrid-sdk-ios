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
    internal var currentSideTypeToTrade: Observable<AssetBankModel.TypeBankModel> = .init(.crypto)

    // MARK: Public properties
    var uiState: Observable<TradeViewController.ViewState> = .init(.PRICES)
    var listPricesViewModel: ListPricesViewModel?

    var accountsOriginal: [AccountBankModel] = []
    var accounts: [AccountAssetUIModel] = []
    var fiatAccounts: [AccountAssetUIModel] = []
    var tradingAccounts: [AccountAssetUIModel] = []

    var assetSwitchTopToBottom: Observable<Bool> = .init(true)
    var amountInput: Observable<String> = .init("0")
    var amountPrice: Observable<String> = .init("0")

    // MARK: View Values
    internal var segmentSelection: Observable<_TradeType> = Observable(.buy)

    // MARK: Constructor
    init(dataProvider: TradesRepoProvider & AccountsRepoProvider,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.logger = logger

        super.init()
        self.initBindingValues()
    }

    func initBindingValues() {

        self.amountInput.bind { [self] _ in
            self.calculatePreQuote()
        }
    }

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

    internal func getAccountAssetUIModel(asset: AssetBankModel) -> AccountAssetUIModel {

        let accountsToUse: [AccountAssetUIModel]!
        if asset.type == .crypto {
            accountsToUse = self.tradingAccounts
        } else {
            accountsToUse = self.fiatAccounts
        }
        return accountsToUse.first(where: {
            $0.asset.code == asset.code
        })!
    }

    @objc
    internal func switchAction(_ sender: UIButton) {

        if self.currentSideTypeToTrade.value == .fiat {
            self.currentSideTypeToTrade.value = .crypto
        } else {
            self.currentSideTypeToTrade.value = .fiat
        }
    }

    internal func calculatePreQuote() {

        var calculatedPrice = "0"
        if self.currentAsset.value != nil {

            let assetCode = self.currentAsset.value?.code ?? ""
            let pairAssetCode = self.currentPairAsset.value?.code ?? ""
            let symbol = "\(assetCode)-\(pairAssetCode)"
            let symbolPrice = self.listPricesViewModel?.prices.value.first(where: {
                $0.symbol == symbol
            })

            let buyPrice = symbolPrice?.buyPrice ?? "0"
            let buyPriceBD = BigDecimal(buyPrice, precision: 0) ?? BigDecimal(0)

            var currentAssetToTrade: AccountAssetUIModel!
            if self.currentSideTypeToTrade.value == .crypto {
                currentAssetToTrade = self.getAccountAssetUIModel(
                    asset: self.currentPairAsset.value!)
            } else {
                currentAssetToTrade = self.getAccountAssetUIModel(
                    asset: self.currentAsset.value!)
            }
            let currentAssetToTradeDecimals = currentAssetToTrade?.asset.decimals ?? 0

            let amountInputBD = BigDecimal(self.amountInput.value)
            let zero = BigDecimal(0)

            switch self.currentSideTypeToTrade.value {
            case .crypto:

                let value = try? amountInputBD?.multiply(with: buyPriceBD, targetPrecision: currentAssetToTradeDecimals)
                calculatedPrice = CybridCurrencyFormatter.formatPrice(value ?? zero, with: (currentAssetToTrade?.asset.symbol)!)

            case .fiat:

                /* calculatedPrice = BigDecimalPipe.divide(
                    lhs: amountInputBD ?? BigDecimal(0),
                    rhs: buyPriceBD,
                    precision: currentAssetToTradeDecimals) */
                // let value = try? amountInputBD?.divCurrency(decimal: buyPriceBD)
                let value = try? amountInputBD?.divide(by: buyPriceBD, targetPrecision: currentAssetToTradeDecimals)
                /// let valueString = String(value?.value ?? "")
                calculatedPrice = CybridCurrencyFormatter.formatInputNumber(value ?? zero)//.removeTrailingZeros()

            default:
                print("")
            }
        }
        self.amountPrice.value = calculatedPrice
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
        }
    }
}

extension TradeViewModel: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.amountInput.value = textField.text ?? ""
    }
}
