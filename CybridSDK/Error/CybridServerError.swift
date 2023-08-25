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
            switch messageCode {
            case "invalid_parameter":
                if errorMessage == "tag must not be empty" {
                    response.message = self.localizer.localize(with: "cybrid.server.error.wallets.view.error.invalid_parameter.tag")
                    response.inputName = "tag"
                }
            case "data_exists":
                response.message = self.localizer.localize(with: "cybrid.server.error.wallets.view.error.data_exists")
                response.inputName = "address"
            default:
                response.message = ""
            }
        }
        return response
    }
}
