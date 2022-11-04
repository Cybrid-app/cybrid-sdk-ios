//
//  IdentityVerificationViewModelTests.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 03/11/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class IdentityVerificationViewModel: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func test_init() {

        let UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
        let viewModel = IdentityVerificationViewModel(dataProvider: self.dataProvider,
                                                      UIState: UIState,
                                                      logger: nil)
    }
}
