//
//  BaseViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 29/09/23.
//

import Foundation
import CybridApiBankSwift

open class BaseViewModel: NSObject {

    internal var componentEnum: ComponentEnum?
    var serverError = ""

    internal func handleError(_ error: ErrorResponse) {

        if case let ErrorResponse.error(_, data, _, _) = error {

            // -- Check the data if it's not nil
            guard let data = data
            else {
                self.serverError = ""
                return
            }

            // -- Check if data could be serialized as josn
            guard let errorResult = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            else {
                self.serverError = ""
                return
            }

            // -- Working with value json
            let messageCode = errorResult["message_code"] as! String
            let errorMessage = errorResult["error_message"] as! String
            if let componentEnum {
                let handledError = CybridServerError().handle(
                    component: componentEnum,
                    messageCode: messageCode,
                    errorMessage: errorMessage)
                self.serverError = handledError.message
            }
        }
    }
}
