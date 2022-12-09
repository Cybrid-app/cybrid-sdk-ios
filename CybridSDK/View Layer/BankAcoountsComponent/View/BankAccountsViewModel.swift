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
    private var dataProvider: WorkflowProvider & ExternalBankAccountProvider & CustomersRepoProvider
    private var logger: CybridLogger?

    private let plaidCustomizationName = "default"
    private let androidPackageName = "app.cybrid.sdkandroid"
    private let defaultAssetCurrency = "USD"

    // MARK: Internal properties
    internal var workflowJob: Polling?
    internal var customerGuid = Cybrid.customerGUID

    // MARK: Public properties
    var uiState: Observable<BankAccountsViewcontroller.BankAccountsViewState> = .init(.LOADING)
    var latestWorkflow: WorkflowWithDetailsBankModel?

    // MARK: Constructor
    init(dataProvider: WorkflowProvider & ExternalBankAccountProvider & CustomersRepoProvider,
         UIState: Observable<BankAccountsViewcontroller.BankAccountsViewState>,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.uiState = UIState
        self.logger = logger
    }

    // MARK: ViewModel Methods

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

        let postExternalBankAccount = PostExternalBankAccountBankModel(
            name: account?.name ?? "",
            accountKind: .plaid,
            customerGuid: customerGuid,
            asset: defaultAssetCurrency,
            plaidPublicToken: publicToken,
            plaidAccountId: account?.id ?? ""
        )
        self.dataProvider.createExternalBankAccount(postExternalBankAccountBankModel: postExternalBankAccount) { [weak self] externalBankAccountResponse in

            switch externalBankAccountResponse {

            case .success:
                self?.logger?.log(.component(.accounts(.pricesDataFetching)))
                self?.uiState.value = .DONE

            case .failure:
                self?.logger?.log(.component(.accounts(.pricesDataError)))
                self?.uiState.value = .ERROR
            }
        }
    }
    
    func fetchCustomer(_ completion: @escaping FetchCustomerCompletion) {
        
        self.dataProvider.getCustomer(customerGuid: customerGuid, completion)
    }
    
    func fetchBank() {}

    func checkWorkflowStatus(workflow: WorkflowWithDetailsBankModel) {

        if workflow.plaidLinkToken != nil && workflow.plaidLinkToken?.isEmpty ?? false {

            self.workflowJob?.stop()
            self.workflowJob = nil
            self.uiState.value = .REQUIRED
        }
    }
}
