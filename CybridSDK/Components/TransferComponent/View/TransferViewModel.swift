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

    // MARK: Public properties
    var uiState: Observable<TransferViewController.ViewState> = .init(.LOADING)
    var currentFiatCurrency = "USD"

    // MARK: Constructor
    init(dataProvider: AccountsRepoProvider & ExternalBankAccountProvider & QuotesRepoProvider & TradesRepoProvider & AssetsRepoProvider,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.logger = logger
    }

    // MARK: ViewModel Methods
    func getAccounts() {
        self.fetchAssets()
    }

    func fetchAssets() {

        self.dataProvider.fetchAssetsList { [weak self] assetsResponse in

            switch assetsResponse {

            case .success(let assets):

                self?.logger?.log(.component(.accounts(.pricesDataFetching)))
                self?.assets = assets
                self?.fetchAccounts()

            case .failure:
                self?.logger?.log(.component(.accounts(.pricesDataError)))
            }
        }
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

    func fetchExternalAccounts() {}
}
