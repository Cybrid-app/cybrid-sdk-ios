//
//  CryptoTransferViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 15/09/23.
//

import Foundation
import CybridApiBankSwift

open class CryptoTransferViewModel: NSObject {

    typealias DataProvider = AccountsRepoProvider & ExternalWalletRepoProvider & PricesRepoProvider & QuotesRepoProvider & TransfersRepoProvider

    // MARK: Private properties
    private var dataProvider: DataProvider
    private var logger: CybridLogger?

    // MARK: Internal properties
    internal var customerGuid = Cybrid.customerGuid
    internal var assets = Cybrid.assets
    internal var fiat = Cybrid.fiat

    internal var accounts: [AccountBankModel] = []
    internal var externalWallets: [ExternalWalletBankModel] = []
    internal var prices: Observable<[SymbolPriceBankModel]> = .init([])

    internal var currentAccount: Observable<AccountBankModel?> = .init(nil)
    internal var currentExternalWallet: ExternalWalletBankModel?
    internal var currentQuote: Observable<QuoteBankModel?> = .init(nil)
    internal var currentTransfer: Observable<TransferBankModel?> = .init(nil)

    internal var isTransferInFiat: Observable<Bool> = .init(false)

    internal var pricesPolling: Polling?

    // MARK: Public properties
    var uiState: Observable<CryptoTransferView.State> = .init(.LOADING)
    var modalUiState: Observable<CryptoTransferView.ModalState> = .init(.LOADING)

    // MARK: Constructor
    init(dataProvider: DataProvider,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.logger = logger
    }

    func initComponent() {

        self.fetchAccounts()
        self.pricesPolling = Polling { self.fetchPrices() }
    }

    // MARK: Internal server methods
    internal func fetchAccounts() {

        self.uiState.value = .LOADING
        dataProvider.fetchAccounts(customerGuid: customerGuid) { [self] accountsResponse in
            switch accountsResponse {
            case .success(let accountList):
                self.logger?.log(.component(.accounts(.accountsDataFetching)))
                self.accounts = accountList.objects
                self.fetchExternalWallets()
            case .failure:
                self.logger?.log(.component(.accounts(.accountsDataError)))
                self.uiState.value = .ERROR
            }
        }
    }

    internal func fetchExternalWallets() {

        dataProvider.fetchListExternalWallet { [self] externalWalletsListResponse in
            switch externalWalletsListResponse {
            case.success(let list):
                self.logger?.log(.component(.accounts(.accountsDataFetching)))
                let wallets = list.objects
                self.externalWallets = wallets.filter {
                    $0.state != .deleting && $0.state != .deleted
                }
                self.uiState.value = .CONTENT
            case .failure:
                self.logger?.log(.component(.accounts(.accountsDataError)))
                self.uiState.value = .ERROR
            }
        }
    }

    internal func fetchPrices() {
        self.dataProvider.fetchPriceList { [self] pricesResponse in
            switch pricesResponse {
            case .success(let prices):
                self.logger?.log(.component(.accounts(.accountsDataFetching)))
                self.prices.value = prices
            case .failure:
                self.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    internal func createQuote(amount: String) {

        self.modalUiState.value = .LOADING
        let amountDecimal = CDecimal(amount)
        let side = PostQuoteBankModel.SideBankModel.withdrawal
        let postQuoteBankModel = PostQuoteBankModel(
            productType: .cryptoTransfer,
            customerGuid: self.customerGuid,
            asset: Cybrid.fiat.code, /* Right code */
            side: side,
            deliverAmount: AssetFormatter.forInput(Cybrid.fiat, amount: amountDecimal)
        )
        self.dataProvider.createQuote(params: postQuoteBankModel, with: nil) { [weak self] quoteResponse in
            switch quoteResponse {
            case .success(let quote):
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.currentQuote.value = quote
                self?.modalUiState.value = .QUOTE
            case .failure:
                self?.modalUiState.value = .ERROR
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    internal func createTransfer() {

        self.modalUiState.value = .LOADING
        let postTransferBankModel = PostTransferBankModel(
            quoteGuid: currentQuote.value!.guid!,
            transferType: .crypto,
            externalWalletGuid: currentExternalWallet?.guid ?? ""
        )
        self.dataProvider.createTransfer(postTransferBankModel: postTransferBankModel) { [weak self] transferResponse in
            switch transferResponse {
            case .success(let transfer):
                self?.currentTransfer.value = transfer
                self?.modalUiState.value = .TRANSFER
            case .failure:
                self?.modalUiState.value = .ERROR
                self?.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }

    // MARK: ViewActions
    @objc
    internal func switchActionHandler(_ sender: UIButton) {
        self.isTransferInFiat.value = !self.isTransferInFiat.value
    }
}
