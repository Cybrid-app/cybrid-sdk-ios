//
//  IdentityVerificationViewModelErrorTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 08/11/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class IdentityVerificationViewModelErrorTest: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func createViewModel(uiState: Observable<IdentityView.State>) -> IdentityVerificationViewModel {
        let viewModel = IdentityVerificationViewModel(dataProvider: self.dataProvider,
                                                      logger: nil)
        viewModel.uiState.value = uiState.value
        return viewModel
    }

    func test_createCustomerTest_Error() {

        // -- Given
        let uiState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: uiState)
        let originalCustomerGUID = viewModel.customerGuid

        // -- When
        viewModel.createCustomerTest()
        dataProvider.didCreateCustomerFailed()

        // -- Then
        XCTAssertEqual(originalCustomerGUID, viewModel.customerGuid)
    }

    func test_getCustomerStatus_Failed() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)
        let originalCustomerGUID = viewModel.customerGuid

        // -- When
        viewModel.getCustomerStatus()
        dataProvider.didFetchCustomerFailed()

        // -- Then
        XCTAssertEqual(originalCustomerGUID, viewModel.customerGuid)
    }

    func test_getIdentityVerificationStatus_Nil_Last_Nil() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)

        // -- When
        viewModel.getIdentityVerificationStatus(identityWrapper: nil)
        dataProvider.didFetchListIdentityVerificationFailed()

        // -- Then
        XCTAssertNil(viewModel.identityJob)
    }

    func test_getIdentityVerificationStatus_Nil_Last_Expired() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)

        // -- When
        viewModel.getIdentityVerificationStatus(identityWrapper: nil)
        dataProvider.didFetchListExpiredIdentityVerificationSuccessfully()
        dataProvider.didFetchIdentityVerificationSuccessfully()

        // -- Then
        XCTAssertNil(viewModel.identityJob)
    }

    func test_getIdentityVerificationStatus_Nil_Last_PersonaExpired() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)

        // -- When
        dataProvider.didFetchListPersonaExpiredIdentityVerificationSuccessfully()
        viewModel.getIdentityVerificationStatus(identityWrapper: nil)
        dataProvider.didFetchListPersonaExpiredIdentityVerificationSuccessfully()

        // -- Then
        XCTAssertNil(viewModel.identityJob)
    }

    func test_fetchIdentityVerificationStatus_Failed() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)
        let record = IdentityVerificationBankModel.getMock()

        // -- When
        viewModel.fetchIdentityVerificationWithDetailsStatus(record: record)
        dataProvider.didFetchIdentityVerificationFailed()

        // -- Then
        XCTAssertNil(viewModel.identityJob)
    }

    func test_fetchLastIdentityVerification_Successfully_Empty() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)
        self.dataProvider = ServiceProviderMock()

        // -- Then
        dataProvider.didFetchListEmptyIdentityVerificationSuccessfully()
        viewModel.fetchLastIdentityVerification { record in
            XCTAssertNil(record)
        }
        dataProvider.didFetchListEmptyIdentityVerificationSuccessfully()
    }

    func test_fetchLastIdentityVerification_Failed() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)

        // -- Then
        viewModel.fetchLastIdentityVerification { identity in
            XCTAssertNil(identity)
        }
        dataProvider.didFetchListIdentityVerificationFailed()
    }

    func test_createIdentityVerification_Failed() {

        // -- Given
        let UIState: Observable<IdentityView.State> = .init(.LOADING)
        let viewModel = createViewModel(uiState: UIState)

        // -- Then
        viewModel.createIdentityVerification { identity in

            XCTAssertNil(identity)
        }
        dataProvider.didCreateIdentityVerificationFailed()
    }
}
