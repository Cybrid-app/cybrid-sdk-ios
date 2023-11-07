//
//  BankAccountsViewModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 08/12/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class BankAccountsViewModelTest: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func createViewModel() -> BankAccountsViewModel {
        return BankAccountsViewModel(dataProvider: self.dataProvider,
                                     logger: nil)
    }

    func test_init() {

        let uiState: Observable<BankAccountsView.State> = .init(.LOADING)
        let viewModel = createViewModel()

        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.uiState)
        XCTAssertEqual(viewModel.uiState.value, uiState.value)
        XCTAssertNil(viewModel.latestWorkflow)
        XCTAssertNil(viewModel.workflowJob)
    }

    func test_fetchExternalBankAccounts_Successfully() {

        // -- Given
        let viewModel = createViewModel()

        // -- PreThen - When
        XCTAssertEqual(viewModel.accounts, [])
        XCTAssertEqual(viewModel.uiState.value, .LOADING)
        dataProvider.fetchExternalBankAccountsSuccessfully()
        viewModel.fetchExternalBankAccounts()
        dataProvider.fetchExternalBankAccountsSuccessfully()

        // -- Then
        XCTAssertFalse(viewModel.accounts.isEmpty)
        XCTAssertEqual(viewModel.uiState.value, .CONTENT)
    }

    // MARK: Workflow Test
    func test_createWorkflow_Successfully() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.didCreateWorkflowSuccessfully()
        viewModel.createWorkflow()
        dataProvider.didCreateWorkflowSuccessfully()

        // --Then
        XCTAssertNotNil(viewModel.workflowJob)
    }

    func test_fetchWorkflow_Successfully() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.didFetchWorkflowSuccessfully()
        viewModel.fetchWorkflow(guid: "1234")
        dataProvider.didFetchWorkflowSuccessfully()

        // -- Then
        XCTAssertNil(viewModel.workflowJob)
        XCTAssertEqual(viewModel.uiState.value, .REQUIRED)
    }

    func test_fetchWorkflow_Empty_Successfully() {

        // -- Given
        let viewModel = createViewModel()
        viewModel.workflowJob = Polling {}

        // -- When
        dataProvider.didFetchWorkflow_Empty_Successfully()
        viewModel.fetchWorkflow(guid: "1234")
        dataProvider.didFetchWorkflow_Empty_Successfully()

        // -- Then
        XCTAssertNotNil(viewModel.workflowJob)
        XCTAssertEqual(viewModel.uiState.value, .LOADING)
    }

    func test_fetchWorkflow_Incomplete_Successfully() {

        // -- Given
        let viewModel = createViewModel()
        viewModel.workflowJob = Polling {}

        // -- When
        dataProvider.didFetchWorkflow_Incomplete_Successfully()
        viewModel.fetchWorkflow(guid: "1234")
        dataProvider.didFetchWorkflow_Incomplete_Successfully()

        // -- Then
        XCTAssertNotNil(viewModel.workflowJob)
        XCTAssertEqual(viewModel.uiState.value, .LOADING)
    }

    // MARK: Customer Test
    func test_fetchCustomer() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.didFetchCustomerSuccessfully()
        viewModel.fetchCustomer { customer in
            XCTAssertNotNil(customer)
        }
        dataProvider.didFetchCustomerSuccessfully()
    }

    // MARK: Bank Test
    func test_fetchBank() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.didFetchBankSuccessfully()
        viewModel.fetchBank(bankGuid: "1234") { bank in
            XCTAssertNotNil(bank)
        }
        dataProvider.didFetchBankSuccessfully()
    }

    // MARK: assetIsSupported
    func test_assetIsSupported_Nil() {

        // -- Given
        let viewModel = createViewModel()

        // --
        viewModel.assetIsSupported(asset: nil) { supported in
            XCTAssertFalse(supported)
        }
    }

    func test_assetIsSupported_Customer_Bank_Success_Supported() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.didFetchCustomerSuccessfully()
        dataProvider.didFetchBankSuccessfully()
        viewModel.assetIsSupported(asset: "USD") { supported in
            XCTAssertTrue(supported)
        }
        dataProvider.didFetchCustomerSuccessfully()
        dataProvider.didFetchBankSuccessfully()
    }

    func test_assetIsSupported_Customer_Bank_Success_NotSupported() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.didFetchCustomerSuccessfully()
        dataProvider.didFetchBankSuccessfully()
        viewModel.assetIsSupported(asset: "1234") { supported in
            XCTAssertFalse(supported)
        }
        dataProvider.didFetchCustomerSuccessfully()
        dataProvider.didFetchBankSuccessfully()
    }

    func test_assetIsSupported_Customer_Bank_Success_Incomplete() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.didFetchCustomerSuccessfully()
        dataProvider.didFetchBankSuccessfully_Incomplete()
        viewModel.assetIsSupported(asset: "1234") { supported in
            XCTAssertFalse(supported)
        }
        dataProvider.didFetchCustomerSuccessfully()
        dataProvider.didFetchBankSuccessfully_Incomplete()
    }

    // MARK: ExternalBankAccount
    func test_createExternalBankAccount_Successfully() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.didFetchCustomerSuccessfully()
        dataProvider.didFetchBankSuccessfully()
        dataProvider.createExternalBankAccountSuccessfully()
        viewModel.createExternalBankAccount(publicToken: "", account: nil)
        dataProvider.didFetchCustomerSuccessfully()
        dataProvider.didFetchBankSuccessfully()
        dataProvider.createExternalBankAccountSuccessfully()

        // -- Then
        XCTAssertEqual(viewModel.uiState.value, .LOADING)
    }

    func test_fetchExternalBankAccount() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.fetchExternalBankAccountSuccessfully()
        viewModel.fetchExternalBankAccount(account: ExternalBankAccountBankModel.mock())
        dataProvider.fetchExternalBankAccountSuccessfully()

        // -- Then
        XCTAssertEqual(viewModel.uiState.value, .LOADING)
    }

    func test_disconnectExternalBankAccount_Successfully() {

        // -- Given
        let viewModel = createViewModel()
        viewModel.uiState.value = .CONTENT

        var sum = 2
        let completion: () -> Void = { sum += 1 }

        // -- PreThen - When
        dataProvider.deleteExternalBankAccountSuccessfully()
        viewModel.disconnectExternalBankAccount(account: ExternalBankAccountBankModel.mock(), completion)
        dataProvider.deleteExternalBankAccountSuccessfully()

        // -- Then
        XCTAssertEqual(sum, 3)
        XCTAssertEqual(viewModel.uiState.value, .LOADING)
    }

    // MARK: checkExternalBankAccountState
    func test_checkExternalBankAccountState() {

        // -- Given
        let viewModel = createViewModel()
        viewModel.externalBankAccountJob = Polling {}

        // -- When
        viewModel.checkExternalBankAccountState(externalBankAccount: ExternalBankAccountBankModel.mock())
        XCTAssertNotNil(viewModel.externalBankAccountJob)
        XCTAssertEqual(viewModel.uiState.value, .LOADING)

        viewModel.checkExternalBankAccountState(externalBankAccount: ExternalBankAccountBankModel.mockCompleted())
        XCTAssertNil(viewModel.externalBankAccountJob)
        XCTAssertEqual(viewModel.uiState.value, .DONE)
    }

    func test_openBankAuthorization() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        viewModel.openBankAuthorization()

        // -- Then
        XCTAssertEqual(viewModel.uiState.value, .AUTH)
    }
}
