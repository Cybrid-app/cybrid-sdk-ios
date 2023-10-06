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

    func test_handle_wallets_component_dafault() {

        // -- Given
        let error = CybridServerError().handle(
            component: .walletsComponent,
            messageCode: "error",
            errorMessage: "")

        // -- Then
        XCTAssertEqual(error.message, "")
    }

    func test_handle_depositAddress_component_unverifiedCustomer() {

        // -- Given
        let error = CybridServerError().handle(
            component: .depositAddressComponent,
            messageCode: "unverified_customer",
            errorMessage: "")

        // -- Then
        XCTAssertEqual(error.message, "Customer has not been verified")
    }

    func test_handle_depositAddress_component_dafault() {

        // -- Given
        let error = CybridServerError().handle(
            component: .depositAddressComponent,
            messageCode: "error",
            errorMessage: "")

        // -- Then
        XCTAssertEqual(error.message, "")
    }

    func test_handleCryptoTransferComponent_invalidParameter() {

        // -- Given
        let error = CybridServerError().handle(
            component: .cryptoTransferComponent,
            messageCode: "invalid_parameter",
            errorMessage: "deliver_amount is empty")

        // -- Then
        XCTAssertEqual(error.message, "Amount is empty")
    }

    func test_handleCryptoTransferComponent_dafault() {

        // -- Given
        let error = CybridServerError().handle(
            component: .cryptoTransferComponent,
            messageCode: "error",
            errorMessage: "")

        // -- Then
        XCTAssertEqual(error.message, "Server error, try again.")
    }
}
