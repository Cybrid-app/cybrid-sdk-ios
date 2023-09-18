//
//  CryptoTransferViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 15/09/23.
//

import Foundation
import CybridApiBankSwift

open class CryptoTransferViewModel: NSObject {

    // MARK: Private properties
    private var dataProvider: ExternalWalletRepoProvider & QuotesRepoProvider & TransfersRepoProvider & AccountsRepoProvider
    private var logger: CybridLogger?

    // MARK: Internal properties
    internal var customerGuid = Cybrid.customerGuid
    internal var assets = Cybrid.assets

    internal var externalWallets: [ExternalWalletBankModel] = []
    internal var accounts: [AccountBankModel] = []

    // MARK: Public properties
    var uiState: Observable<CryptoTransferView.State> = .init(.LOADING)

    // MARK: Constructor
    init(dataProvider: ExternalWalletRepoProvider & QuotesRepoProvider & TransfersRepoProvider & AccountsRepoProvider,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.logger = logger
    }
    
    // MARK: Internal server methods
    internal func fetchExternalWallets() {
        
        self.uiState.value = .LOADING
        dataProvider.fetchListExternalWallet { [self] externalWalletsListResponse in
            switch externalWalletsListResponse {
            case.success(let list):
                self.logger?.log(.component(.accounts(.accountsDataFetching)))
                let wallets = list.objects
                self.externalWallets = wallets.filter { $0.state != .deleting && $0.state != .deleted }
                //self.uiState.value = .WALLETS
            case .failure:
                self.logger?.log(.component(.accounts(.accountsDataError)))
                //self.uiState.value = .ERROR
            }
        }
    }
    
    internal func fetchAccounts() {
        
        dataProvider.fetchAccounts(customerGuid: customerGuid) { [ self] accountsResponse in
            switch accountsResponse {
            case .success(let accountList):
                
                self.logger?.log(.component(.accounts(.accountsDataFetching)))
                self.accounts = accountList.objects
                //self.fetchExternalAccounts()
                
            case .failure:
                self.logger?.log(.component(.accounts(.accountsDataError)))
            }
        }
    }
    
    func createQuote(amount: String) {
        
        //self.modalUIState.value = .LOADING
        let amountDecimal = CDecimal(amount)
        let side = PostQuoteBankModel.SideBankModel.withdrawal
        
        let postQuoteBankModel = PostQuoteBankModel(
            productType: .funding,
            customerGuid: self.customerGuid,
            asset: Cybrid.fiat.code,
            side: side,
            deliverAmount: AssetFormatter.forInput(Cybrid.fiat, amount: amountDecimal)
        )
        self.dataProvider.createQuote(params: postQuoteBankModel, with: nil) { [weak self] quoteResponse in
            
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
}
