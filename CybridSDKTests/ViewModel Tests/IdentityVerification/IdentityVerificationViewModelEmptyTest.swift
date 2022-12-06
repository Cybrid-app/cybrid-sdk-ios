//
//  IdentityVerificationViewModelEmptyTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 08/11/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class IdentityVerificationViewModelEmptyTest: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func createViewModel(UIState: Observable<IdentityVerificationViewController.KYCViewState>) -> IdentityVerificationViewModel {
        return IdentityVerificationViewModel(dataProvider: self.dataProvider,
                                             UIState: UIState,
                                             logger: nil)
    }

    func test_getIdentityVerificationStatus_Nil_Last_Nil() {

        // -- Given
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)

        // -- When
        viewModel.getIdentityVerificationStatus(record: nil)
        dataProvider.didFetchListIdentityVerificationFailed()
        dataProvider.didCreateCustomerSuccessfully()

        // -- Then
        XCTAssertEqual(viewModel.customerGuid, "")
        XCTAssertNil(viewModel.identityJob)
    }

    func test_getIdentityVerificationStatus_Nil_Last_Expired() {

        // -- Given
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)

        // -- When
        viewModel.getIdentityVerificationStatus(record: nil)
        dataProvider.didFetchListExpiredIdentityVerificationSuccessfully()
        dataProvider.didCreateCustomerSuccessfully()

        // -- Then
        XCTAssertEqual(viewModel.customerGuid, "")
        XCTAssertNil(viewModel.identityJob)
    }

    func test_getIdentityVerificationStatus_Nil_Last_PersonaExpired() {

        // -- Given
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)

        // -- When
        viewModel.getIdentityVerificationStatus(record: nil)
        dataProvider.didFetchListPersonaExpiredIdentityVerificationSuccessfully()
        dataProvider.didCreateCustomerSuccessfully()

        // -- Then
        XCTAssertEqual(viewModel.customerGuid, "")
        XCTAssertNil(viewModel.identityJob)
    }

    func test_fetchIdentityVerificationStatus_Failed() {

        // -- Given
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)
        let record = IdentityVerificationBankModel.getMock()

        // -- When
        viewModel.fetchIdentityVerificationWithDetailsStatus(record: record)
        dataProvider.didFetchIdentityVerificationFailed()

        // -- Then
        XCTAssertNil(viewModel.identityJob)
    }

    func test_fetchLastIdentityVerification_Successfully_Empty() {

        // -- Given
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)
        self.dataProvider = ServiceProviderMock()

        // -- Then
        viewModel.fetchLastIdentityVerification { record in

            XCTAssertNil(record)
        }
        dataProvider.didFetchListEmptyIdentityVerificationSuccessfully()
    }

    func test_fetchLastIdentityVerification_Failed() {

        // -- Given
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)

        // -- Then
        viewModel.fetchLastIdentityVerification { identity in
            XCTAssertNil(identity)
        }
        dataProvider.didFetchListIdentityVerificationFailed()
    }

    func test_createIdentityVerification_Failed() {

        // -- Given
        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = createViewModel(UIState: UIState)

        // -- Then
        viewModel.createIdentityVerification { identity in

            XCTAssertNil(identity)
        }
        dataProvider.didCreateIdentityVerificationFailed()
    }
}
