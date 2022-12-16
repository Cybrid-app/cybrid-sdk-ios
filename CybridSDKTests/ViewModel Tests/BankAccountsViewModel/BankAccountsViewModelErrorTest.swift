//
//  BankAccountsViewModelErrorTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 09/12/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class BankAccountsViewModelError: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func createViewModel() -> BankAccountsViewModel {
        return BankAccountsViewModel(dataProvider: self.dataProvider,
                                     logger: nil)
    }

    func test_createWorkflow_Failed() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        viewModel.createWorkflow()
        dataProvider.didCreateWorkflowFailed()

        // --Then
        XCTAssertNil(viewModel.workflowJob)
        XCTAssertEqual(viewModel.uiState.value, .ERROR)
    }

    func test_fetchWorkflow_Failed() {

        // -- Given
        let viewModel = createViewModel()
        viewModel.workflowJob = Polling {}

        // -- When
        viewModel.fetchWorkflow(guid: "1234")
        dataProvider.didFetchWorkflowFailed()

        // -- Then
        XCTAssertNotNil(viewModel.workflowJob)
        XCTAssertEqual(viewModel.uiState.value, .LOADING)
    }

    // MARK: assetIsSupported
    func test_assetIsSupported_Customer_Nil() {

        // -- Given
        let viewModel = createViewModel()

        // --
        dataProvider.didFetchCustomerFailed()
        viewModel.assetIsSupported(asset: "1234") { supported in
            XCTAssertFalse(supported)
        }
        dataProvider.didFetchCustomerFailed()
    }

    func test_assetIsSupported_Customer_Success_Bank_Nil() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.didFetchCustomerSuccessfully()
        viewModel.assetIsSupported(asset: "1234") { supported in
            XCTAssertFalse(supported)
        }
        dataProvider.didFetchCustomerSuccessfully()
        dataProvider.didFetchBankFailed()
    }

    // MARK: ExternalBankAccount
    func test_createExternalBankAccount_Successfully() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.didFetchCustomerSuccessfully()
        dataProvider.didFetchBankSuccessfully()
        viewModel.createExternalBankAccount(publicToken: "", account: nil)
        dataProvider.didFetchCustomerSuccessfully()
        dataProvider.didFetchBankSuccessfully()
        dataProvider.createExternalBankAccountFailed()

        // -- Then
        XCTAssertEqual(viewModel.uiState.value, .ERROR)
    }

    func test_createExternalBankAccount_NotSupported() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.didFetchCustomerSuccessfully()
        dataProvider.didFetchBankSuccessfully_Incomplete()
        viewModel.createExternalBankAccount(publicToken: "", account: nil)
        dataProvider.didFetchCustomerSuccessfully()
        dataProvider.didFetchBankSuccessfully_Incomplete()

        // -- Then
        XCTAssertEqual(viewModel.uiState.value, .ERROR)
    }

    func test_fetchExternalBankAccount() {

        // -- Given
        let viewModel = createViewModel()

        // -- When
        dataProvider.fetchExternalBankAccountFailed()
        viewModel.fetchExternalBankAccount(account: ExternalBankAccountBankModel.mock())
        dataProvider.fetchExternalBankAccountFailed()

        // -- Then
        XCTAssertEqual(viewModel.uiState.value, .LOADING)
    }
}
