//
//  IdentityVerificationBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 01/11/22.
//

import Foundation
import CybridApiBankSwift

extension IdentityVerificationBankModel {

    init?(json: [String: Any]) {

        guard
            let createdAt = json[IdentityVerificationBankModel.CodingKeys.createdAt.rawValue] as? String
        else {
            return nil
        }

        let codingKeys = IdentityVerificationBankModel.CodingKeys.self
        let createdAtDate = getDate(stringDate: createdAt)

        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            customerGuid: json[codingKeys.customerGuid.rawValue] as? String ?? "",
            type: json[codingKeys.type.rawValue] as? String ?? "",
            method: json[codingKeys.method.rawValue] as? String ?? "",
            createdAt: createdAtDate,
            state: json[codingKeys.state.rawValue] as? String ?? "",
            outcome: json[codingKeys.outcome.rawValue] as? String ?? "",
            failureCodes: nil)
    }

    static func fromArray(objects: [[String: Any]]) -> [IdentityVerificationBankModel] {

        var models = [IdentityVerificationBankModel]()
        for object in objects {
            // -- Creating the AccountBankModel
            let model = IdentityVerificationBankModel(json: object)
            if let model = model {
                models.append(model)
            }
        }
        return models
    }
}
