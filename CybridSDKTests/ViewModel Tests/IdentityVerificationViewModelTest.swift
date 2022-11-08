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
