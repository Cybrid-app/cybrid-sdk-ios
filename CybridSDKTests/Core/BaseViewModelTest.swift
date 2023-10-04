//
//  BaseViewModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 29/09/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class BaseViewModelTest: XCTestCase {

    private func createViewModel() -> BaseViewModel {
        return BaseViewModel()
    }

    func test_handleError_WithData_nil() {

        // -- Given
        let viewModel = self.createViewModel()
        let error = ErrorResponse.error(1, nil, nil, CybridError.serviceError)

        // -- When
        viewModel.handleError(error)

        // -- Then
        XCTAssertEqual(viewModel.serverError, "")
    }

    func test_handleError_WithData_No_Json() {

        // -- Given
        let viewModel = self.createViewModel()
        let data = "Cybrid".data(using: .utf8)
        let error = ErrorResponse.error(1, data, nil, CybridError.serviceError)

        // -- When
        viewModel.handleError(error)

        // -- Then
        XCTAssertEqual(viewModel.serverError, "")
    }

    func test_handleError() {

        // -- Given
        let viewModel = self.createViewModel()
        viewModel.componentEnum = .walletsComponent
        let data = "{\"status\":400,\"error_message\":\"tag must not be empty\",\"message_code\":\"invalid_parameter\"}".data(using: .utf8)
        let error = ErrorResponse.error(1, data, nil, CybridError.serviceError)

        // -- When
        viewModel.handleError(error)

        // -- Then
        XCTAssertEqual(viewModel.serverError, "Tag must not be empty")
    }
}
