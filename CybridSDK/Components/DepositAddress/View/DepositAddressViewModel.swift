//
//  DepositAddressViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 14/07/23.
//

import CybridApiBankSwift

open class DepositAddressViewModel: BaseViewModel {

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
    private(set) var currentAmountForDeposit: String = ""
    private(set) var currentMessageForDeposit: String = ""

    // MARK: Constructor
    init(dataProvider: DepositAddressRepoProvider,
         logger: CybridLogger?,
         accountBalance: BalanceUIModel) {
        self.dataProvider = dataProvider
        self.logger = logger
        self.accountBalance = accountBalance

        super.init()
        self.componentEnum = .depositAddressComponent
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
        dataProvider.fetchDepositAddress(depositAddressGuid: depositAddress.guid!) { [weak self] response in
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
            case .failure(let error):
                self?.logger?.log(.component(.accounts(.accountsDataError)))
                self?.handleError(error)
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

    internal func setValuesForDeposit(amount: String, message: String) {

        self.currentAmountForDeposit = amount
        self.currentMessageForDeposit = message
        self.uiState.value = .CONTENT
    }

    // MARK: Functions to QRCode
    internal func generateQRCode(assetCode: String,
                                 address: String,
                                 network: String = "",
                                 amount: String = "",
                                 message: String = "") -> UIImage? {
        let addressFormatted = self.getStringAddressForQRCode(assetCode: assetCode,
                                                              address: address,
                                                              network: network,
                                                              amount: amount,
                                                              message: message)
        return CybridSDK.generateQRCode(from: addressFormatted)
    }

    internal func getStringAddressForQRCode(assetCode: String,
                                            address: String,
                                            network: String = "",
                                            amount: String = "",
                                            message: String = "",
                                            gas: String = "") -> String {
        var addressFormatted = ""
        switch assetCode {
        case "BTC":
            addressFormatted += "bitcoin:\(address)"
            if !amount.isEmpty {
                addressFormatted += "?amount=\(amount)"
            }
            if !message.isEmpty {
                if let messageEncoded = message.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) {
                    addressFormatted += "&message=\(messageEncoded)"
                }
            }
        case "ETH":
            addressFormatted += "ethereum:\(address)"
            if !amount.isEmpty {
                addressFormatted += "?value=\(amount)"
            }
            if !gas.isEmpty {
                addressFormatted += "&gas=\(gas)"
            }
            if !message.isEmpty {
                if let messageEncoded = message.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) {
                    addressFormatted += "&data=\(messageEncoded)"
                }
            }

        default:
            addressFormatted += address
        }
        print(addressFormatted)
        return addressFormatted
    }
}
