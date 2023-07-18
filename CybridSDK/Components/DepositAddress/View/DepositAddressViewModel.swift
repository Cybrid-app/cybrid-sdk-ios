//
//  DepositAddressViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 14/07/23.
//

import CybridApiBankSwift

open class DepositAddressViewModel: NSObject {

    // MARK: Private properties
    private var dataProvider: DepositAddressRepoProvider
    private var logger: CybridLogger?

    // MARK: Internal properties
    internal var customerGuig = Cybrid.customerGuid
    internal var accountBalance: BalanceUIModel
    internal var depositAddresses: [DepositAddressBankModel] = []
    internal var currentDepositAddress: DepositAddressBankModel?
    internal var depositAddressPolling: Polling?

    // MARK: Public properties
    var uiState: Observable<DepositAddresView.State> = .init(.LOADING)
    var loadingLabelUiState: Observable<DepositAddresView.LoadingLabelState> = .init(.VERIFYING)

    // MARK: Constructor
    init(dataProvider: DepositAddressRepoProvider,
         logger: CybridLogger?,
         accountBalance: BalanceUIModel) {

        self.dataProvider = dataProvider
        self.logger = logger
        self.accountBalance = accountBalance
    }

    // MARK: Internal server methods
    internal func fetchDepositAddresses() {

        self.uiState.value = .LOADING
        self.loadingLabelUiState.value = .VERIFYING
        dataProvider.fetchListDepositAddress { [weak self] listResponse in
            switch listResponse {
            case .success(let list):
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.depositAddresses = list.objects
                self?.verifyingAtLeastOneAccount()
            case.failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
                self?.uiState.value = .ERROR
            }
        }
    }

    internal func fetchDepositAddress(depositAddress: DepositAddressBankModel) {

        self.uiState.value = .LOADING
        self.loadingLabelUiState.value = .GETTING
        dataProvider.fetchDepositAddress(depositAddressGuid: depositAddress.guid) { [weak self] response in
            switch response {
            case.success(let depositAddressBankModel):
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.checkDepositAddressValue(depositAddress: depositAddressBankModel)
            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
                self?.uiState.value = .ERROR
            }
        }
    }

    internal func createDepositAddress() {

        self.uiState.value = .LOADING
        self.loadingLabelUiState.value = .CREATING
        let postDepositAdrress = PostDepositAddressBankModel(accountGuid: self.accountBalance.account.guid!)
        dataProvider.createDepositAddress(postDepositAdrress: postDepositAdrress) { [weak self] response in
            switch response {
            case .success(let depositAddress):
                self?.checkDepositAddressValue(depositAddress: depositAddress)
            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
                self?.uiState.value = .ERROR
            }
        }
    }

    // MARK: Internal logic methods
    internal func verifyingAtLeastOneAccount() {

        guard let depositAddress = self.depositAddresses.last(where: { $0.accountGuid == self.accountBalance.account.guid }) else {

            self.createDepositAddress()
            return
        }
        self.fetchDepositAddress(depositAddress: depositAddress)
    }

    internal func displayDepositAddress(depositAddress: DepositAddressBankModel) {

        self.currentDepositAddress = depositAddress
        self.uiState.value = .CONTENT
    }

    internal func checkDepositAddressValue(depositAddress: DepositAddressBankModel) {

        switch depositAddress.state {

        case .storing:
            self.depositAddressPolling = Polling {
                self.fetchDepositAddress(depositAddress: depositAddress)
            }

        case .created:
            self.depositAddressPolling?.stop()
            self.depositAddressPolling = nil
            self.displayDepositAddress(depositAddress: depositAddress)

        default:
            self.depositAddressPolling?.stop()
            self.depositAddressPolling = nil
        }
    }
}
