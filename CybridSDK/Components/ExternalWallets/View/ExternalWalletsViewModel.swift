//
//  ExternalWalletsViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 17/08/23.
//

import CybridApiBankSwift

open class ExternalWalletsViewModel: NSObject {

    // MARK: Private properties
    private var dataProvider: ExternalWalletRepoProvider
    private var logger: CybridLogger?

    // MARK: Internal properties
    internal var customerGuig = Cybrid.customerGuid
    internal var externalWallets: [ExternalWalletBankModel] = []
    internal var externalWalletsActive: [ExternalWalletBankModel] = []

    // MARK: Public properties
    var uiState: Observable<ExternalWalletsView.State> = .init(.LOADING)
    var currentWallet: ExternalWalletBankModel?

    // MARK: Constructor
    init(dataProvider: ExternalWalletRepoProvider,
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
                self.externalWallets = list.objects
                self.externalWalletsActive = self.externalWallets.filter { $0.state != .deleting && $0.state != .deleted }
                self.uiState.value = .WALLETS
            case .failure:
                self.logger?.log(.component(.accounts(.accountsDataError)))
                self.uiState.value = .ERROR
            }
        }
    }

    internal func createExternalWallet(postExternalWalletBankModel: PostExternalWalletBankModel) {

        self.uiState.value = .LOADING
        dataProvider.createExternalWallet(postExternalWalletBankModel: postExternalWalletBankModel) { [weak self] externalWalletResponse in
            switch externalWalletResponse {
            case .success:
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.fetchExternalWallets()
            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
                self?.uiState.value = .ERROR
            }
        }
    }

    internal func deleteExternalWallet() {

        self.uiState.value = .LOADING
        dataProvider.deleteExternalWallet(guid: self.currentWallet?.guid ?? "") { [weak self] response in
            switch response {
            case .success:
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.fetchExternalWallets()
            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
                self?.uiState.value = .ERROR
            }
        }
        self.currentWallet = nil
    }
}
