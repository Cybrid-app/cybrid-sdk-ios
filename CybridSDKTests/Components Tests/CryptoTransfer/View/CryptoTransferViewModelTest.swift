//
//  CryptoTransferViewModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 04/10/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class CryptoTransferViewModelTest: CryptoTransferTest {

    func test_init() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.customerGuid.isEmpty)
        XCTAssertFalse(viewModel.assets.isEmpty)
    }
}
