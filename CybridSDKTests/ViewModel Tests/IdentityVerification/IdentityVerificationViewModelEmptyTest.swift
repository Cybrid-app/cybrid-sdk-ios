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
