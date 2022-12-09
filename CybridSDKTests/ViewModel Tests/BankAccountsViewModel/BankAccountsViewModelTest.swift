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

    func createViewModel(uiState: Observable<BankAccountsViewcontroller.BankAccountsViewState>) -> BankAccountsViewModel {
        return BankAccountsViewModel(dataProvider: self.dataProvider,
                                     UIState: uiState,
                                     logger: nil)
    }

    func test_init() {

        let uiState: Observable<BankAccountsViewcontroller.BankAccountsViewState> = .init(.LOADING)
        let viewModel = createViewModel(uiState: uiState)

        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.uiState)
        XCTAssertEqual(viewModel.uiState.value, uiState.value)
        XCTAssertNil(viewModel.latestWorkflow)
        XCTAssertNil(viewModel.workflowJob)
    }

    func test_createWorkflow_Successfully() {

        // -- Given
        let uiState: Observable<BankAccountsViewcontroller.BankAccountsViewState> = .init(.LOADING)
        let viewModel = createViewModel(uiState: uiState)

        // -- When
        dataProvider.didCreateWorkflowSuccessfully()
        viewModel.createWorkflow()
        dataProvider.didCreateWorkflowSuccessfully()

        // --Then
        XCTAssertNotNil(viewModel.workflowJob)
    }

    func test_fetchWorkflow_Successfully() {

        // -- Given
        let uiState: Observable<BankAccountsViewcontroller.BankAccountsViewState> = .init(.LOADING)
        let viewModel = createViewModel(uiState: uiState)

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
        let uiState: Observable<BankAccountsViewcontroller.BankAccountsViewState> = .init(.LOADING)
        let viewModel = createViewModel(uiState: uiState)
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
        let uiState: Observable<BankAccountsViewcontroller.BankAccountsViewState> = .init(.LOADING)
        let viewModel = createViewModel(uiState: uiState)
        viewModel.workflowJob = Polling {}

        // -- When
        dataProvider.didFetchWorkflow_Incomplete_Successfully()
        viewModel.fetchWorkflow(guid: "1234")
        dataProvider.didFetchWorkflow_Incomplete_Successfully()

        // -- Then
        XCTAssertNotNil(viewModel.workflowJob)
        XCTAssertEqual(viewModel.uiState.value, .LOADING)
    }
}
