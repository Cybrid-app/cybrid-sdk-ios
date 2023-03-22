//
//  TransferViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 23/12/22.
//

import Foundation
import CybridApiBankSwift

class TransferViewModel: NSObject {

    // MARK: Private properties
    private var dataProvider: AccountsRepoProvider & ExternalBankAccountProvider & QuotesRepoProvider & TradesRepoProvider & AssetsRepoProvider
    private var logger: CybridLogger?

    // MARK: Internal properties
    internal var customerGuid = Cybrid.customerGUID
    internal var assets: [AssetBankModel] = []
    internal var accounts: Observable<[AccountBankModel]> = .init([])
    internal var externalBankAccounts: Observable<[ExternalBankAccountBankModel]> = .init([])
    internal var fiatBalance: Observable<String> = .init("")
    internal var currentQuote: Observable<QuoteBankModel?> = .init(nil)
    internal var currentTrade: Observable<TradeBankModel?> = .init(nil)
    internal var currentExternalBankAccount: Observable<ExternalBankAccountBankModel?> = .init(nil)
    internal var isWithdraw: Observable<Bool> = .init(false)

    // MARK: Public properties
    var uiState: Observable<TransferViewController.ViewState> = .init(.LOADING)
    var modalUIState: Observable<TransferViewController.ModalViewState> = .init(.CONTENT)

    // MARK: Constructor
    init(dataProvider: AccountsRepoProvider & ExternalBankAccountProvider & QuotesRepoProvider & TradesRepoProvider & AssetsRepoProvider,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.logger = logger
    }

    // MARK: ViewModel Methods
    func getAccounts() {

        self.assets = Cybrid.assets
        self.fetchAccounts()
    }

    func fetchAccounts() {

        self.dataProvider.fetchAccounts(customerGuid: self.customerGuid) { [weak self] accountsResponse in

            switch accountsResponse {
            case .success(let accountList):
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.accounts.value = accountList.objects
                self?.fetchExternalAccounts()

            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    func fetchExternalAccounts() {

        self.dataProvider.fetchExternalBankAccounts(customerGuid: self.customerGuid) { [weak self] accountsResponse in
            switch accountsResponse {
            case .success(let accountList):
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.externalBankAccounts.value = accountList.objects
                self?.calculateFiatBalance()
                self?.uiState.value = .ACCOUNTS

            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    func calculateFiatBalance() {

        if !self.assets.isEmpty {
            if let pairAsset = assets.first(where: { $0.code == Cybrid.fiat.code }) {

                var total = BigDecimal(0).value
                for account in self.accounts.value {
                    if account.type == .fiat && account.state == .created {

                        let accountBalance = BigDecimal(account.platformBalance ?? "0")
                        total += accountBalance!.value
                    }
                }
                let totalBigDecimal = BigDecimal(total, precision: pairAsset.decimals)
                let totalFormatted = CybridCurrencyFormatter.formatPrice(totalBigDecimal, with: pairAsset.symbol)
                self.fiatBalance.value = "\(totalFormatted) \(pairAsset.code)"
            }
        }
    }

    func createQuote(side: PostQuoteBankModel.SideBankModel, amount: BigDecimal) {

        let postQuoteBankModel = PostQuoteBankModel(
            productType: .funding,
            customerGuid: self.customerGuid,
            asset: Cybrid.fiat.code,
            side: side,
            deliverAmount: ""
        )
        self.dataProvider.createQuote(params: postQuoteBankModel, with: nil) { [weak self] quoteResponse in

            switch quoteResponse {

            case .success(let quote):
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.currentQuote.value = quote

            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    func createTrade() {

        self.dataProvider.createTrade(quoteGuid: self.currentQuote.value?.guid ?? "") { [weak self] tradeResponse in

            switch tradeResponse {

            case .success(let trade):
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.currentTrade.value = trade

            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    @objc
    func segmentedControlValueChanged(_ sender: UISegmentedControl) {

        self.isWithdraw.value = sender.selectedSegmentIndex == 0 ? false : true
    }
}

extension TransferViewModel: UIPickerViewDelegate, UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return externalBankAccounts.value.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        let account = self.externalBankAccounts.value[row]
        let accountMask = account.plaidAccountMask ?? ""
        let accountName = account.plaidAccountName ?? ""
        let accountID = account.plaidInstitutionId ?? ""
        return "\(accountID) - \(accountName) (\(accountMask))"
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentExternalBankAccount.value = self.externalBankAccounts.value[row]
    }
}
