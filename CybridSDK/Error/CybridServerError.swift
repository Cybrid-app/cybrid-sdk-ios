//
//  CybridServerError.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 24/08/23.
//

import Foundation

struct CybridServerErrorResponse {

    var message: String
    var inputName: String
}

internal class CybridServerError {

    var localizer: CybridLocalizer

    init() {
        self.localizer = CybridLocalizer()
    }

    func handle(component: ComponentEnum, messageCode: String, errorMessage: String) -> CybridServerErrorResponse {

        var response = CybridServerErrorResponse(message: "", inputName: "")
        switch component {
        case .walletsComponent:
            response = self.handleWalletsComponent(messageCode: messageCode, errorMessage: errorMessage)
        case .depositAddressComponent:
            response = self.handleDepositAddressComponent(messageCode: messageCode, errorMessage: errorMessage)
        }
        return response
    }

    internal func handleWalletsComponent(messageCode: String, errorMessage: String) -> CybridServerErrorResponse {

        var response = CybridServerErrorResponse(message: "", inputName: "")
        switch messageCode {
        case "invalid_parameter":
            if errorMessage == "tag must not be empty" {
                response.message = self.localizer.localize(with: UIStrings.walletsCreateErrorInvalidadTag)
                response.inputName = "tag"
            }
        case "data_exists":
            response.message = self.localizer.localize(with: UIStrings.walletsCreateErrorDataExists)
            response.inputName = "address"
        default:
            response.message = ""
        }
        return response
    }

    internal func handleDepositAddressComponent(messageCode: String, errorMessage: String) -> CybridServerErrorResponse {

        var response = CybridServerErrorResponse(message: "", inputName: "")
        switch messageCode {
        case "unverified_customer":
            response.message = self.localizer.localize(with: UIStrings.depositAddressErrorUnverifiedCustomer)
        default:
            response.message = ""
        }
        return response
    }
}

extension CybridServerError {

    enum UIStrings {

        static let walletsCreateErrorInvalidadTag = "cybrid.server.error.wallets.view.error.invalid_parameter.tag"
        static let walletsCreateErrorDataExists = "cybrid.server.error.wallets.view.error.data_exists"
        static let depositAddressErrorUnverifiedCustomer = "cybrid.server.error.deposit.address.create.error.unverified_customer"
    }
}
