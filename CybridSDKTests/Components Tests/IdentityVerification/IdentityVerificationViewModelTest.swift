//
//  IdentityVerificationViewModelTests.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 03/11/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class IdentityVerificationViewModelTest: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func createViewModel(uiState: Observable<IdentityView.State>) -> IdentityVerificationViewModel {
        let viewModel = IdentityVerificationViewModel(dataProvider: self.dataProvider,
                                                      logger: nil)
        viewModel.uiState.value = uiState.value
        return viewModel
    }

    func test_init() {

        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)

        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.uiState)
        XCTAssertEqual(viewModel.uiState.value, UIState.value)
        XCTAssertNil(viewModel.latestIdentityVerification)
    }

    func test_createCustomerTest_Successfully() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)
        let expectedCustomerGuid = "cybrid_unit_testing_guid"

        // -- When
        dataProvider.didCreateCustomerSuccessfully()
        viewModel.createCustomerTest()
        dataProvider.didCreateCustomerSuccessfully()

        // -- Then
        XCTAssertEqual(viewModel.customerGuid, expectedCustomerGuid)
    }

    func test_getCustomerStatus_Successfully() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)
        let originalCustomerGUID = viewModel.customerGuid

        // -- When
        dataProvider.didFetchCustomerSuccessfully()
        viewModel.getCustomerStatus()
        dataProvider.didFetchCustomerSuccessfully()

        // -- Then
        XCTAssertEqual(originalCustomerGUID, viewModel.customerGuid)
    }

    func test_getCustomerStatus_Successfully_Empty() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)
        let originalCustomerGUID = viewModel.customerGuid

        // -- When
        dataProvider.didFetchCustomerSuccessfully_Empty()
        viewModel.getCustomerStatus()
        dataProvider.didFetchCustomerSuccessfully_Empty()

        // -- Then
        XCTAssertEqual(originalCustomerGUID, viewModel.customerGuid)
    }

    func test_getIdentityVerificationStatus_State_Expired() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)
        let wrapper = IdentityVerificationWrapper(identity: IdentityVerificationBankModel.getExpiredMock(), details: nil)

        // -- When
        viewModel.getIdentityVerificationStatus(identityWrapper: wrapper)
        dataProvider.didCreateIdentityVerificationSuccessfully()
        dataProvider.didFetchListIdentityVerificationSuccessfully()

        // -- Then
        XCTAssertNil(viewModel.identityJob)
    }

    func test_fetchIdentityVerificationStatus_Successfully() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)
        let record = IdentityVerificationBankModel.getMock()

        // -- When
        viewModel.fetchIdentityVerificationWithDetailsStatus(record: record)
        dataProvider.didFetchIdentityVerificationSuccessfully()

        // -- Then
        XCTAssertNotNil(viewModel.identityJob)
    }

    func test_getIdentityVerificationStatusWithWrapperNil_lastVerification_Nil() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)

        // -- When
        dataProvider.didFetchListIdentityVerificationFailed()
        dataProvider.didCreateIdentityVerificationSuccessfully()
        dataProvider.didFetchIdentityVerificationSuccessfully()
        viewModel.getIdentityVerificationStatusWithWrapperNil()
        dataProvider.didFetchListIdentityVerificationFailed()
        dataProvider.didCreateIdentityVerificationSuccessfully()
        dataProvider.didFetchIdentityVerificationSuccessfully()

        // -- Then
        XCTAssertNotNil(viewModel.identityJob)
    }

    func test_getIdentityVerificationStatusWithWrapperNil_state_expired() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)

        // -- When
        dataProvider.didFetchListExpiredIdentityVerificationSuccessfully()
        dataProvider.didCreateIdentityVerificationSuccessfully()
        dataProvider.didFetchIdentityVerificationSuccessfully()
        viewModel.getIdentityVerificationStatusWithWrapperNil()
        dataProvider.didFetchListExpiredIdentityVerificationSuccessfully()
        dataProvider.didCreateIdentityVerificationSuccessfully()
        dataProvider.didFetchIdentityVerificationSuccessfully()

        // -- Then
        XCTAssertNotNil(viewModel.identityJob)
    }

    func test_getIdentityVerificationStatusWithWrapperNil() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)

        // -- When
        dataProvider.didFetchListIdentityVerificationSuccessfully()
        dataProvider.didFetchIdentityVerificationSuccessfully()
        viewModel.getIdentityVerificationStatusWithWrapperNil()
        dataProvider.didFetchListIdentityVerificationSuccessfully()
        dataProvider.didFetchIdentityVerificationSuccessfully()

        // -- Then
        XCTAssertNotNil(viewModel.identityJob)
    }

    func test_fetchLastIdentityVerification_Successfully() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)

        // -- Then
        viewModel.fetchLastIdentityVerification { identity in

            XCTAssertNotNil(identity)
            XCTAssertEqual(identity?.customerGuid, "12345")
        }
        dataProvider.didFetchListIdentityVerificationSuccessfully()
    }

    func test_createIdentityVerification_Successfully() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)

        // -- Then
        dataProvider.didCreateIdentityVerificationSuccessfully()
        viewModel.createIdentityVerification { identity in

            XCTAssertNotNil(identity)
            XCTAssertEqual(identity?.customerGuid, "12345")
        }
        dataProvider.didCreateIdentityVerificationSuccessfully()
    }

    func test_checkCustomerStatus() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)
        var customer = CustomerBankModel()

        // -- state: storing - UIState: LOADING
        customer.state = "storing"
        XCTAssertNil(viewModel.customerJob)
        viewModel.checkCustomerStatus(state: customer.state!)
        XCTAssertNotNil(viewModel.customerJob)
        XCTAssertEqual(viewModel.uiState.value, .LOADING)

        // -- state: verified - UIState: VERIFIED
        customer.state = "verified"
        viewModel.customerJob = Polling {}
        viewModel.checkCustomerStatus(state: customer.state!)
        XCTAssertNil(viewModel.customerJob)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.VERIFIED)

        // -- state: unverified - UIState: LOADING
        customer.state = "unverified"
        viewModel.customerJob = Polling {}
        viewModel.checkCustomerStatus(state: customer.state!)
        XCTAssertNil(viewModel.customerJob)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.VERIFIED)

        // -- state: rejected - UIState: ERROR
        customer.state = "rejected"
        viewModel.customerJob = Polling {}
        viewModel.checkCustomerStatus(state: customer.state!)
        XCTAssertNil(viewModel.customerJob)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.ERROR)

        // -- state: frozen - UIState: FROZEN
        customer.state = "frozen"
        viewModel.customerJob = Polling {}
        viewModel.checkCustomerStatus(state: customer.state!)
        XCTAssertNil(viewModel.customerJob)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.FROZEN)

        // -- state: unknownDefaultOpenApi - UIState: LOADING
        customer.state = "unknownDefaultOpenApi"
        viewModel.uiState.value = .LOADING
        viewModel.checkCustomerStatus(state: customer.state!)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.LOADING)
    }

    func test_checkIdentityRecordStatus() {

        // -- Given
        let uiState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: uiState)
        let wrapper = IdentityVerificationWrapper(identity: IdentityVerificationBankModel(state: "storing"), details: IdentityVerificationWithDetailsBankModel(state: "storing"))

        // -- state: storing - UIState: LOADING
        XCTAssertNil(viewModel.identityJob)
        viewModel.checkIdentityRecordStatus(wrapper: wrapper)
        XCTAssertNotNil(viewModel.identityJob)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.LOADING)

        // -- state: waiting - personaState: completed - UIState: LOADING
        wrapper.identityVerification?.state = "waiting"
        wrapper.identityVerificationDetails?.state = "waiting"
        wrapper.identityVerificationDetails?.personaState = "completed"
        viewModel.identityJob = nil
        viewModel.checkIdentityRecordStatus(wrapper: wrapper)
        XCTAssertNotNil(viewModel.identityJob)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.LOADING)

        // -- state: waiting - personaState: processing - UIState: LOADING
        wrapper.identityVerification?.state = "waiting"
        wrapper.identityVerificationDetails?.state = "waiting"
        wrapper.identityVerificationDetails?.personaState = "processing"
        viewModel.identityJob = nil
        viewModel.checkIdentityRecordStatus(wrapper: wrapper)
        XCTAssertNotNil(viewModel.identityJob)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.LOADING)

        // -- state: waiting - personaState: reviewing - UIState: LOADING
        wrapper.identityVerification?.state = "waiting"
        wrapper.identityVerificationDetails?.state = "waiting"
        wrapper.identityVerificationDetails?.personaState = "reviewing"
        viewModel.checkIdentityRecordStatus(wrapper: wrapper)
        XCTAssertNil(viewModel.identityJob)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.REVIEWING)

        // -- state: expired - UIState: LOADING
        wrapper.identityVerification?.state = "expired"
        wrapper.identityVerificationDetails?.state = "expired"
        viewModel.uiState.value = .LOADING
        viewModel.identityJob = Polling {}
        viewModel.checkIdentityRecordStatus(wrapper: wrapper)
        XCTAssertNil(viewModel.identityJob)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.LOADING)

        // -- state: completed - UIState: VERIFIED
        wrapper.identityVerification?.state = "completed"
        wrapper.identityVerificationDetails?.state = "completed"
        viewModel.uiState.value = .LOADING
        viewModel.identityJob = Polling {}
        viewModel.checkIdentityRecordStatus(wrapper: wrapper)
        XCTAssertNil(viewModel.identityJob)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.VERIFIED)

        // -- state: unknownDefaultOpenApi - UIState: LOADING
        wrapper.identityVerification?.state = "unknownDefaultOpenApi"
        wrapper.identityVerificationDetails?.state = "unknownDefaultOpenApi"
        viewModel.uiState.value = .LOADING
        viewModel.identityJob = Polling {}
        viewModel.checkIdentityRecordStatus(wrapper: wrapper)
        XCTAssertNil(viewModel.identityJob)
    }

    func test_checkIdentityPersonaStatus() {

        // -- Given
        let uiState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: uiState)
        let wrapper = IdentityVerificationWrapper(identity: IdentityVerificationBankModel(state: "waiting"), details: IdentityVerificationWithDetailsBankModel(personaState: "waiting"))

        // -- Persona: waiting - UIState: REQUIRED
        viewModel.checkIdentityPersonaStatus(wrapper: wrapper)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerification, wrapper.identityVerification)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerificationDetails, wrapper.identityVerificationDetails)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.REQUIRED)

        // -- Persona: pending - UIState: REQUIRED
        wrapper.identityVerificationDetails?.personaState = "pending"
        viewModel.uiState.value = .LOADING
        viewModel.checkIdentityPersonaStatus(wrapper: wrapper)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerification, wrapper.identityVerification)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerificationDetails, wrapper.identityVerificationDetails)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.REQUIRED)

        // -- Persona: reviewing - UIState: REVIEWING
        wrapper.identityVerificationDetails?.personaState = "reviewing"
        viewModel.uiState.value = .LOADING
        viewModel.checkIdentityPersonaStatus(wrapper: wrapper)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerification, wrapper.identityVerification)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerificationDetails, wrapper.identityVerificationDetails)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.REVIEWING)

        // -- Persona: completed - UIState: ERROR
        wrapper.identityVerificationDetails?.personaState = "completed"
        viewModel.uiState.value = .LOADING
        viewModel.checkIdentityPersonaStatus(wrapper: wrapper)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerification, wrapper.identityVerification)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerificationDetails, wrapper.identityVerificationDetails)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.ERROR)

        // -- Persona: expired - UIState: ERROR
        wrapper.identityVerificationDetails?.personaState = "expired"
        viewModel.uiState.value = .LOADING
        viewModel.checkIdentityPersonaStatus(wrapper: wrapper)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerification, wrapper.identityVerification)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerificationDetails, wrapper.identityVerificationDetails)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.LOADING)

        // -- Persona: processing - UIState: ERROR
        wrapper.identityVerificationDetails?.personaState = "processing"
        viewModel.uiState.value = .LOADING
        viewModel.checkIdentityPersonaStatus(wrapper: wrapper)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerification, wrapper.identityVerification)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerificationDetails, wrapper.identityVerificationDetails)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.ERROR)

        // -- Persona: unknown - UIState: ERROR
        wrapper.identityVerificationDetails?.personaState = "unknown"
        viewModel.uiState.value = .LOADING
        viewModel.checkIdentityPersonaStatus(wrapper: wrapper)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerification, wrapper.identityVerification)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerificationDetails, wrapper.identityVerificationDetails)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.ERROR)

        // -- Persona: unknownDefaultOpenApi - UIState: ERROR
        wrapper.identityVerificationDetails?.personaState = "unknownDefaultOpenApi"
        viewModel.uiState.value = .LOADING
        viewModel.checkIdentityPersonaStatus(wrapper: wrapper)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerification, wrapper.identityVerification)
        XCTAssertEqual(viewModel.latestIdentityVerification?.identityVerificationDetails, wrapper.identityVerificationDetails)
        XCTAssertEqual(viewModel.uiState.value, IdentityView.State.ERROR)
    }
}
