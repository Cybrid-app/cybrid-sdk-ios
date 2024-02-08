//
//  CustomerBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 01/11/22.
//

import Foundation
import CybridApiBankSwift

extension CustomerBankModel {

    init?(json: [String: Any]) {
        guard
            let createdAt = json[CustomerBankModel.CodingKeys.createdAt.rawValue] as? String
        else {
            return nil
        }

        let codingKeys = CustomerBankModel.CodingKeys.self
        let createdAtDate = getDate(stringDate: createdAt)

        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            bankGuid: json[codingKeys.bankGuid.rawValue] as? String ?? "",
            type: json[codingKeys.type.rawValue] as? String ?? "",
            createdAt: createdAtDate,
            state: json[codingKeys.state.rawValue] as? String ?? "")
    }

    static func fromArray(objects: [[String: Any]]) -> [CustomerBankModel] {

        var models = [CustomerBankModel]()
        for object in objects {
            // -- Creating the AccountBankModel
            let model = CustomerBankModel(json: object)
            if let model = model {
                models.append(model)
            }
        }
        return models
    }
}
