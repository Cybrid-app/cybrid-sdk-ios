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
            let createdAt = json[CustomerBankModel.CodingKeys.createdAt.rawValue] as? String,
            let state = json[CustomerBankModel.CodingKeys.state.rawValue] as? String,
            let type = json[CustomerBankModel.CodingKeys.type.rawValue] as? String
        else {
            return nil
        }

        let codingKeys = CustomerBankModel.CodingKeys.self
        let createdAtDate = getDate(stringDate: createdAt)

        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            type: (CustomerBankModel.TypeBankModel(rawValue: type) ?? .individual) as TypeBankModel,
            createdAt: createdAtDate,
            state: (CustomerBankModel.StateBankModel(rawValue: state) ?? .storing) as StateBankModel)
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
