//
//  BankAccountsViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 02/12/22.
//

import LinkKit
import CybridApiBankSwift

class BankAccountsViewModel: NSObject {

    // MARK: Private properties
    private unowned var cellProvider: BankAccountsViewProvider
    private var dataProvider: WorkflowProvider & ExternalBankAccountProvider & CustomersRepoProvider & BankProvider
    private var logger: CybridLogger?

    private let plaidCustomizationName = "default"
    private let androidPackageName = "app.cybrid.sdkandroid"
    private let defaultAssetCurrency = "USD"

    // MARK: Internal properties
    internal var workflowJob: Polling?
    internal var externalBankAccountJob: Polling?
    internal var customerGuid = Cybrid.customerGuid

    internal var accounts: [ExternalBankAccountBankModel] = []

    // MARK: Public properties
    var uiState: Observable<BankAccountsViewController.BankAccountsViewState> = .init(.LOADING)
    var modalState: Observable<BankAccountsViewController.BankAccountsModalViewState> = .init(.CONTENT)
    var latestWorkflow: WorkflowWithDetailsBankModel?

    // MARK: Constructor
    init(dataProvider: WorkflowProvider & ExternalBankAccountProvider & CustomersRepoProvider & BankProvider,
         cellProvider: BankAccountsViewProvider,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.cellProvider = cellProvider
        self.logger = logger
    }

    // MARK: ViewModel Methods
    func fetchExternalBankAccounts() {

        self.dataProvider.fetchExternalBankAccounts(customerGuid: self.customerGuid) { [weak self] accountsReponse in

            switch accountsReponse {

            case .success(let accountsList):

                self?.accounts = []
                let accountsPreFilter = accountsList.objects
                var accountsFiltered: [ExternalBankAccountBankModel] = []
                for account in accountsPreFilter {
                    if account.state != .deleted && account.state != .deleting {
                        accountsFiltered.append(account)
                    }
                }
                self?.accounts = accountsFiltered
                self?.uiState.value = .CONTENT

            case .failure:
                self?.logger?.log(.component(.accounts(.pricesDataError)))
            }
        }
    }

    func createWorkflow() {

        let postWorkflowBankModel = PostWorkflowBankModel(
            type: .plaid,
            kind: .create,
            customerGuid: self.customerGuid,
            language: .en,
            linkCustomizationName: self.plaidCustomizationName
        )
        self.dataProvider.createWorkflow(postWorkflowBankModel: postWorkflowBankModel) { [weak self] workflowResponse in

            switch workflowResponse {

            case .success(let workflow):

                self?.logger?.log(.component(.accounts(.pricesDataFetching)))
                self?.workflowJob = Polling { self?.fetchWorkflow(guid: workflow.guid!) }

            case .failure:
                self?.logger?.log(.component(.accounts(.pricesDataError)))
                self?.uiState.value = .ERROR
            }
        }
    }

    func fetchWorkflow(guid: String) {

        self.dataProvider.fetchWorkflow(guid: guid) { [weak self] workflowResponse in

            switch workflowResponse {

            case .success(let workflow):

                self?.logger?.log(.component(.accounts(.pricesDataFetching)))
                self?.checkWorkflowStatus(workflow: workflow)

            case .failure:
                self?.logger?.log(.component(.accounts(.pricesDataError)))
            }
        }
    }

    func createExternalBankAccount(publicToken: String, account: LinkKit.Account?) {

        self.assetIsSupported(asset: defaultAssetCurrency) { [weak self] supported in

            if supported {

                let postExternalBankAccount = PostExternalBankAccountBankModel(
                    name: account?.name ?? "",
                    accountKind: .plaid,
                    customerGuid: self?.customerGuid,
                    asset: self?.defaultAssetCurrency ?? "",
                    plaidPublicToken: publicToken,
                    plaidAccountId: account?.id ?? ""
                )
                self?.dataProvider.createExternalBankAccount(postExternalBankAccountBankModel: postExternalBankAccount) { [weak self ] externalBankAccountResponse in

                    switch externalBankAccountResponse {

                    case .success(let externalBankAccount):
                        self?.logger?.log(.component(.accounts(.pricesDataFetching)))
                        self?.externalBankAccountJob = Polling { self?.fetchExternalBankAccount(account: externalBankAccount) }

                    case .failure:
                        self?.logger?.log(.component(.accounts(.pricesDataError)))
                        self?.uiState.value = .ERROR
                    }
                }

            } else {
                self?.uiState.value = .ERROR
            }
        }
    }

    func fetchCustomer(_ completion: @escaping FetchCustomerCompletion) {

        self.dataProvider.getCustomer(customerGuid: customerGuid, completion)
    }

    func fetchBank(bankGuid: String, _ completion: @escaping FetchBankCompletion) {

        self.dataProvider.fetchBank(guid: bankGuid, completion)
    }

    func fetchExternalBankAccount(account: ExternalBankAccountBankModel) {

        self.dataProvider.fetchExternalBankAccount(externalBankAccountGuid: account.guid!) { [weak self] externalBankAccountResponse in

            switch externalBankAccountResponse {

            case .success(let externalBankAccount):
                self?.checkExternalBankAccountState(externalBankAccount: externalBankAccount)

            case .failure:
                self?.logger?.log(.component(.accounts(.pricesDataError)))
            }
        }
    }

    func assetIsSupported(asset: String?, _ completion: @escaping (Bool) -> Void) {

        if asset == nil {
            completion(false)
        } else {

            self.fetchCustomer { [weak self] customerResponse in

                switch customerResponse {

                case .success(let customer):

                    self?.fetchBank(bankGuid: customer.bankGuid!) { bankResponse in

                        switch bankResponse {

                        case .success(let bank):
                            if let supported = bank.supportedFiatAccountAssets {

                                if supported.contains(asset!) {
                                    completion(true)
                                } else {
                                    completion(false)
                                }
                            } else {
                                completion(false)
                            }

                        case.failure:
                            completion(false)
                        }
                    }

                case .failure:
                    completion(false)
                }
            }
        }
    }

    func checkWorkflowStatus(workflow: WorkflowWithDetailsBankModel) {

        if !(workflow.plaidLinkToken?.isEmpty ?? true) {

            self.workflowJob?.stop()
            self.workflowJob = nil
            self.uiState.value = .REQUIRED
        }
    }

    func checkExternalBankAccountState(externalBankAccount: ExternalBankAccountBankModel) {

        if externalBankAccount.state == .completed {

            self.externalBankAccountJob?.stop()
            self.externalBankAccountJob = nil
            self.uiState.value = .DONE
        }
    }

    func disconnectExternalBankAccount(account: ExternalBankAccountBankModel, _ completion: @escaping () -> Void) {

        self.dataProvider.deleteExternalBankAccount(bankAccountGuid: account.guid!) { [weak self] accountResponse in

            switch accountResponse {

            case .success:

                completion()
                self?.uiState.value = .LOADING
                self?.fetchExternalBankAccounts()

            case .failure:
                self?.logger?.log(.component(.accounts(.pricesDataError)))
            }
        }
    }
}

// MARK: - AccountsViewProvider

protocol BankAccountsViewProvider: AnyObject {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withAccount dataModel: ExternalBankAccountBankModel) -> UITableViewCell

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, withAccount balance: ExternalBankAccountBankModel)
}

// MARK: - AccountsViewModel + UITableViewDelegate + UITableViewDataSource

extension BankAccountsViewModel: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accounts.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellProvider.tableView(tableView, cellForRowAt: indexPath, withAccount: accounts[indexPath.row])
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellProvider.tableView(tableView, didSelectRowAt: indexPath, withAccount: accounts[indexPath.row])
    }
}
