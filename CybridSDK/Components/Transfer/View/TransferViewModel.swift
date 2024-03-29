//
//  TransferViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 23/12/22.
//

import Foundation
import CybridApiBankSwift

open class TransferViewModel: NSObject {

    // MARK: Private properties
    private var dataProvider: AccountsRepoProvider & ExternalBankAccountProvider & QuotesRepoProvider & TransfersRepoProvider
    private var logger: CybridLogger?

    // MARK: Internal properties
    internal var customerGuid = Cybrid.customerGuid
    internal var assets = Cybrid.assets

    internal var accounts: Observable<[AccountBankModel]> = .init([])
    internal var externalBankAccounts: Observable<[ExternalBankAccountBankModel]> = .init([])

    internal var fiatBalance: Observable<String> = .init("")
    internal var currentQuote: Observable<QuoteBankModel?> = .init(nil)
    internal var currentTransfer: Observable<TransferBankModel?> = .init(nil)

    internal var errorMessage: Observable<Bool> = .init(false)

    internal var currentExternalBankAccount: Observable<ExternalBankAccountBankModel?> = .init(nil)
    internal var isWithdraw: Observable<Bool> = .init(false)
    internal var amount: String = ""

    internal var accountsPolling: Polling?

    // MARK: Public properties
    var uiState: Observable<TransferView.State> = .init(.LOADING)
    var modalUIState: Observable<TransferView.ModalState> = .init(.LOADING)
    var balanceLoading: Observable<TransferView.BalanceViewState> = .init(.CONTENT)

    // MARK: Constructor
    init(dataProvider: AccountsRepoProvider & ExternalBankAccountProvider & QuotesRepoProvider & TransfersRepoProvider,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.logger = logger
    }

    // MARK: ViewModel Methods
    func fetchAccounts() {

        self.uiState.value = .LOADING
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

    func fetchAccountsInPolling() {

        self.balanceLoading.value = .LOADING
        self.dataProvider.fetchAccounts(customerGuid: self.customerGuid) { [weak self] accountsResponse in

            switch accountsResponse {
            case .success(let accountList):

                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.accounts.value = accountList.objects
                self?.calculateFiatBalance()
                self?.balanceLoading.value = .CONTENT

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
                self?.checkExternalBankAccounts(accounts: accountList.objects)

            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    func createAccountsPolling() {

        self.accountsPolling = Polling(interval: 8) {
            self.fetchAccountsInPolling()
        }
    }

    func checkExternalBankAccounts(accounts: [ExternalBankAccountBankModel]) {

        self.externalBankAccounts.value = accounts
        if !accounts.isEmpty {

            self.currentExternalBankAccount.value = accounts.first
            self.calculateFiatBalance()
            self.uiState.value = .CONTENT
            self.createAccountsPolling()
            for account in accounts where account.state == .refreshRequired {
                self.errorMessage.value = true
            }
        } else {
            self.uiState.value = .WARNING
        }
    }

    func calculateFiatBalance() {

        if !self.assets.isEmpty {
            if let pairAsset = assets.first(where: { $0.code == Cybrid.fiat.code.uppercased() }) {

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

    func createQuote(amount: String) {

        self.modalUIState.value = .LOADING
        let amountDecimal = CDecimal(amount)
        let side = self.getQuoteSide()

        let postQuoteBankModel = PostQuoteBankModel(
            productType: .funding,
            customerGuid: self.customerGuid,
            asset: Cybrid.fiat.code,
            side: side,
            deliverAmount: AssetFormatter.forInput(Cybrid.fiat, amount: amountDecimal)
        )
        self.dataProvider.createQuote(postQuoteBankModel: postQuoteBankModel) { [weak self] quoteResponse in

            switch quoteResponse {

            case .success(let quote):

                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.currentQuote.value = quote
                self?.modalUIState.value = .CONFIRM

            case .failure:

                self?.modalUIState.value = .ERROR
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    func createTransfer() {

        self.modalUIState.value = .LOADING
        let postTransferBankModel = PostTransferBankModel(
            quoteGuid: self.currentQuote.value!.guid!,
            transferType: .funding,
            externalBankAccountGuid: self.currentExternalBankAccount.value?.guid ?? ""
        )
        self.dataProvider.createTransfer(postTransferBankModel: postTransferBankModel) { [weak self] transferResponse in

            switch transferResponse {

            case .success(let transfer):
                self?.currentTransfer.value = transfer
                self?.modalUIState.value = .DETAILS

            case .failure:

                self?.modalUIState.value = .ERROR
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    @objc
    func segmentedControlValueChanged(_ sender: UISegmentedControl) {

        self.isWithdraw.value = sender.selectedSegmentIndex == 0 ? false : true
    }

    func getAccountNameInFormat(_ account: ExternalBankAccountBankModel?) -> String {

        let accountMask = account?.plaidAccountMask ?? ""
        let accountName = account?.plaidAccountName ?? ""
        let accountID = account?.plaidInstitutionId ?? ""
        let name = "\(accountID) - \(accountName) (\(accountMask))"
        return name
    }

    func getQuoteSide() -> PostQuoteBankModel.SideBankModel {

        let side: PostQuoteBankModel.SideBankModel = self.isWithdraw.value ? .withdrawal : .deposit
        return side
    }

    func getAmountOfCurrentTransferFormatted() -> String {
        do {
            let amountValueString = self.currentTransfer.value?.amount
            guard let transferAssetCode = self.currentTransfer.value?.asset else {
                return CybridConstants.transferAssetError
            }
            let asset = try Cybrid.findAsset(code: transferAssetCode)
            let amountBase = AssetFormatter.forBase(asset, amount: CDecimal(amountValueString!))
            return AssetFormatter.format(asset, amount: amountBase)
        } catch {
            return CybridConstants.transferAssetError
        }
    }
}
