//
//  ExternalWalletsViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 17/08/23.
//

import CybridApiBankSwift

open class ExternalWalletViewModel: NSObject {

    // MARK: Private properties
    private var dataProvider: ExternalWalletRepoProvider & TransfersRepoProvider
    private var logger: CybridLogger?

    // MARK: Internal properties
    internal var customerGuig = Cybrid.customerGuid
    internal var externalWallets: [ExternalWalletBankModel] = []
    internal var externalWalletsActive: [ExternalWalletBankModel] = []
    internal var transfers: [TransferBankModel] = []

    // MARK: Public properties
    var uiState: Observable<ExternalWalletsView.State> = .init(.LOADING)
    var transfersUiState: Observable<ExternalWalletsView.TransfersState> = .init(.LOADING)
    var addressScannedValue: Observable<String> = .init("")
    var tagScannedValue: Observable<String> = .init("")
    var currentWallet: ExternalWalletBankModel?
    var lastUiState: ExternalWalletsView.State = .LOADING
    var serverError = ""

    // MARK: Constructor
    init(dataProvider: ExternalWalletRepoProvider & TransfersRepoProvider,
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

        self.lastUiState = self.uiState.value
        self.uiState.value = .LOADING
        dataProvider.createExternalWallet(postExternalWalletBankModel: postExternalWalletBankModel) { [weak self] externalWalletResponse in
            switch externalWalletResponse {
            case .success:
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.fetchExternalWallets()
            case .failure(let error):
                self?.logger?.log(.component(.accounts(.accountsDataError)))
                self?.handleError(error)
                self?.uiState.value = .ERROR
            }
        }
    }

    internal func deleteExternalWallet() {

        self.uiState.value = .LOADING
        dataProvider.deleteExternalWallet(guid: self.currentWallet!.guid!) { [weak self] response in
            switch response {
            case .success:
                self?.logger?.log(.component(.accounts(.accountsDataFetching)))
                self?.fetchExternalWallets()
                self?.currentWallet = nil
            case .failure:
                self?.logger?.log(.component(.accounts(.accountsDataError)))
                self?.uiState.value = .ERROR
            }
        }
    }

    internal func goToWalletDetail(_ wallet: ExternalWalletBankModel) {

        self.currentWallet = wallet
        self.uiState.value = .WALLET
        self.transfers = []
    }

    internal func fetchTransfers() {

        self.transfersUiState.value = .LOADING
        dataProvider.fetchTransfers(customerGuid: customerGuig) { [self] transfersResponse in
            switch transfersResponse {
            case .success(let list):
                self.logger?.log(.component(.accounts(.accountsDataFetching)))
                self.transfers = list.objects
                self.transfersUiState.value = .EMPTY

            case .failure:
                self.logger?.log(.component(.accounts(.accountsDataError)))
                self.transfersUiState.value = .EMPTY
            }
        }
    }

    internal func handleQRScanned(code: String) {

        print(code)
        var codeValue = code
        if code.contains(":") {
            let codeParts = code.components(separatedBy: ":")
            let data = String(codeParts[1])
            let dataComponents = data.components(separatedBy: "&")
            if dataComponents.count > 1 {
                let address = dataComponents[0]
                let components = dataComponents[1]
                codeValue = address
                self.findTagInQRData(components)
            } else {
                codeValue = data
            }
        }
        self.addressScannedValue.value = codeValue
    }

    internal func findTagInQRData(_ components: String) {

        var tagValue = ""
        let componnetsParts = components.components(separatedBy: "?")
        if !componnetsParts.isEmpty {
            for component in componnetsParts {
                let componentParts = component.components(separatedBy: "=")
                if componentParts.count == 2 {
                    let itemName = componentParts[0]
                    let itemValue = componentParts[1]
                    if itemName == "tag" {
                        tagValue = itemValue
                    }
                }
            }
        }
        self.tagScannedValue.value = tagValue
    }

    internal func handleError(_ error: ErrorResponse) {

        if case let ErrorResponse.error(_, data, _, _) = error {

            // -- Check the data if it's not nil
            guard let data = data
            else {
                self.serverError = ""
                self.uiState.value = .ERROR
                return
            }

            // -- Check if data could be serialized as josn
            guard let errorResult = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            else {
                self.serverError = ""
                self.uiState.value = .ERROR
                return
            }

            // -- Working with value json
            let messageCode = errorResult["message_code"] as! String
            let errorMessage = errorResult["error_message"] as! String
            let handledError = CybridServerError().handle(
                component: .walletsComponent,
                messageCode: messageCode,
                errorMessage: errorMessage)
            self.serverError = handledError.message
        }
    }
}
