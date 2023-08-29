//
//  CybridServerErrorResponseTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 25/08/23.
//

@testable import CybridSDK
import XCTest

class CybridServerErrorTest: XCTestCase {

    func test_handle_wallets_component_invalidParameter() {

        // -- Given
        let error = CybridServerError().handle(
            component: .walletsComponent,
            messageCode: "invalid_parameter",
            errorMessage: "tag must not be empty")

        // -- Then
        XCTAssertEqual(error.message, "Tag must not be empty")
    }

    func test_handle_wallets_component_dataExists() {

        // -- Given
        let error = CybridServerError().handle(
            component: .walletsComponent,
            messageCode: "data_exists",
            errorMessage: "")

        // -- Then
        XCTAssertEqual(error.message, "Address already exists.")
    }

    func test_handle_wallets_dafault() {

        // -- Given
        let error = CybridServerError().handle(
            component: .walletsComponent,
            messageCode: "error",
            errorMessage: "")

        // -- Then
        XCTAssertEqual(error.message, "")
    }
}
