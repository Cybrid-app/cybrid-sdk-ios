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

    func createViewModel(UIState: Observable<IdentityVerificationViewController.KYCViewState>) -> IdentityVerificationViewModel {
        return IdentityVerificationViewModel(dataProvider: self.dataProvider,
                                             UIState: UIState,
                                             logger: nil)
    }

    func test_init() {

        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)

        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.UIState)
        XCTAssertEqual(viewModel.UIState.value, UIState.value)
        XCTAssertNil(viewModel.latestIdentityVerification)
    }

    func test_createCustomer_Successfully() {

        // -- Given
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)

        // -- When
        dataProvider.didCreateCustomerSuccessfully()
        viewModel.createCustomerTest()
        dataProvider.didCreateCustomerSuccessfully()

        // -- Then
        XCTAssertEqual(viewModel.customerGuid, "12345")
    }

    func test_createCustomer_Error() {

        // -- Given
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)
        let originalCustomerGUID = viewModel.customerGuid

        // -- When
        dataProvider.didCreateCustomerFailed()
        viewModel.createCustomerTest()

        // -- Then
        XCTAssertEqual(originalCustomerGUID, viewModel.customerGuid)

    }

    func test_getCustomerStatus_Successfully() {

        // -- Given
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)
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
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)
        let originalCustomerGUID = viewModel.customerGuid

        // -- When
        dataProvider.didFetchCustomerSuccessfully_Empty()
        viewModel.getCustomerStatus()
        dataProvider.didFetchCustomerSuccessfully_Empty()

        // -- Then
        XCTAssertEqual(originalCustomerGUID, viewModel.customerGuid)
    }

    func test_getCustomerStatus_Failed() {

        // -- Given
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)
        let originalCustomerGUID = viewModel.customerGuid

        // -- When
        viewModel.getCustomerStatus()
        dataProvider.didFetchCustomerFailed()

        // -- Then
        XCTAssertEqual(originalCustomerGUID, viewModel.customerGuid)
    }

    func test_fetchLastIdentityVerification_Successfully() {

        // -- Given
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)

        // -- Then
        viewModel.fetchLastIdentityVerification { identity in

            XCTAssertNotNil(identity)
            XCTAssertEqual(identity?.customerGuid, "12345")
        }
        dataProvider.didFetchListIdentityVerificationSuccessfully()
    }

    func test_createIdentityVerification_Successfully() {

        // -- Given
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)

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
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)
        var customer = CustomerBankModel()

        // -- state: storing - UIState: LOADING
        customer.state = .storing
        XCTAssertNil(viewModel.customerJob)
        viewModel.checkCustomerStatus(state: customer.state!)
        XCTAssertNotNil(viewModel.customerJob)

        // -- state: storing - UIState: VERIFIED
        customer.state = .verified
        viewModel.customerJob = Polling {}
        viewModel.checkCustomerStatus(state: customer.state!)
        XCTAssertNil(viewModel.customerJob)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.VERIFIED)

        // -- state: unverified - UIState: LOADING
        customer.state = .unverified
        viewModel.customerJob = Polling {}
        viewModel.checkCustomerStatus(state: customer.state!)
        XCTAssertNil(viewModel.customerJob)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.VERIFIED)

        // -- state: rejected - UIState: LOADING
        customer.state = .rejected
        viewModel.customerJob = Polling {}
        viewModel.checkCustomerStatus(state: customer.state!)
        XCTAssertNil(viewModel.customerJob)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.ERROR)

        // -- state: unknownDefaultOpenApi - UIState: LOADING
        customer.state = .unknownDefaultOpenApi
        viewModel.UIState.value = .LOADING
        viewModel.checkCustomerStatus(state: customer.state!)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.LOADING)
    }

    func test_checkIdentityRecordStatus() {

        // -- Given
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)
        var record = IdentityVerificationBankModel(state: .storing)

        // -- state: storing - UIState: LOADING
        XCTAssertNil(viewModel.identityJob)
        viewModel.checkIdentityRecordStatus(record: record)
        XCTAssertNotNil(viewModel.identityJob)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.LOADING)

        // -- state: waiting - personaState: completed - UIState: LOADING
        record.state = .waiting
        record.personaState = .completed
        viewModel.identityJob = nil
        viewModel.checkIdentityRecordStatus(record: record)
        XCTAssertNotNil(viewModel.identityJob)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.LOADING)

        // -- state: waiting - personaState: processing - UIState: LOADING
        record.state = .waiting
        record.personaState = .processing
        viewModel.identityJob = nil
        viewModel.checkIdentityRecordStatus(record: record)
        XCTAssertNotNil(viewModel.identityJob)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.LOADING)

        // -- state: waiting - personaState: reviewing - UIState: LOADING
        record.state = .waiting
        record.personaState = .reviewing
        viewModel.checkIdentityRecordStatus(record: record)
        XCTAssertNil(viewModel.identityJob)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.REVIEWING)

        // -- state: expired - UIState: LOADING
        record.state = .expired
        viewModel.UIState.value = .LOADING
        viewModel.identityJob = Polling {}
        viewModel.checkIdentityRecordStatus(record: record)
        XCTAssertNil(viewModel.identityJob)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.LOADING)

        // -- state: completed - UIState: VERIFIED
        record.state = .completed
        viewModel.UIState.value = .LOADING
        viewModel.identityJob = Polling {}
        viewModel.checkIdentityRecordStatus(record: record)
        XCTAssertNil(viewModel.identityJob)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.VERIFIED)

        // -- state: unknownDefaultOpenApi - UIState: LOADING
        record.state = .unknownDefaultOpenApi
        viewModel.UIState.value = .LOADING
        viewModel.identityJob = Polling {}
        viewModel.checkIdentityRecordStatus(record: record)
        XCTAssertNil(viewModel.identityJob)
    }

    func test_checkIdentityPersonaStatus() {

        // -- Given
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)
        var record = IdentityVerificationBankModel(personaState: .waiting)

        // -- Persona: waiting - UIState: REQUIRED
        viewModel.checkIdentityPersonaStatus(record: record)
        XCTAssertEqual(viewModel.latestIdentityVerification, record)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.REQUIRED)

        // -- Persona: pending - UIState: REQUIRED
        record.personaState = .pending
        viewModel.UIState.value = .LOADING
        viewModel.checkIdentityPersonaStatus(record: record)
        XCTAssertEqual(viewModel.latestIdentityVerification, record)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.REQUIRED)

        // -- Persona: reviewing - UIState: REVIEWING
        record.personaState = .reviewing
        viewModel.UIState.value = .LOADING
        viewModel.checkIdentityPersonaStatus(record: record)
        XCTAssertEqual(viewModel.latestIdentityVerification, record)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.REVIEWING)

        // -- Persona: completed - UIState: ERROR
        record.personaState = .completed
        viewModel.UIState.value = .LOADING
        viewModel.checkIdentityPersonaStatus(record: record)
        XCTAssertEqual(viewModel.latestIdentityVerification, record)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.ERROR)

        // -- Persona: expired - UIState: ERROR
        record.personaState = .expired
        viewModel.UIState.value = .LOADING
        viewModel.checkIdentityPersonaStatus(record: record)
        XCTAssertEqual(viewModel.latestIdentityVerification, record)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.ERROR)

        // -- Persona: processing - UIState: ERROR
        record.personaState = .processing
        viewModel.UIState.value = .LOADING
        viewModel.checkIdentityPersonaStatus(record: record)
        XCTAssertEqual(viewModel.latestIdentityVerification, record)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.ERROR)

        // -- Persona: unknown - UIState: ERROR
        record.personaState = .unknown
        viewModel.UIState.value = .LOADING
        viewModel.checkIdentityPersonaStatus(record: record)
        XCTAssertEqual(viewModel.latestIdentityVerification, record)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.ERROR)

        // -- Persona: unknownDefaultOpenApi - UIState: ERROR
        record.personaState = .unknownDefaultOpenApi
        viewModel.UIState.value = .LOADING
        viewModel.checkIdentityPersonaStatus(record: record)
        XCTAssertEqual(viewModel.latestIdentityVerification, record)
        XCTAssertEqual(viewModel.UIState.value, IdentityVerificationViewController.KYCViewState.ERROR)
    }
}
