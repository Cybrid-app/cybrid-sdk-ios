//
//  DepositAddressBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 18/07/23.
//

import CybridApiBankSwift

extension DepositAddressBankModel {

    init?(json: [String: Any]) {
        guard
            let createdAt = json[DepositAddressBankModel.CodingKeys.createdAt.rawValue] as? String
        else {
            return nil
        }

        let codingKeys = DepositAddressBankModel.CodingKeys.self
        let createdAtDate = getDate(stringDate: createdAt)

        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            bankGuid: json[codingKeys.bankGuid.rawValue] as? String ?? "",
            customerGuid: json[codingKeys.customerGuid.rawValue] as? String ?? "",
            accountGuid: json[codingKeys.accountGuid.rawValue] as? String ?? "",
            createdAt: createdAtDate!,
            asset: json[codingKeys.asset.rawValue] as? String ?? "",
            state: json[codingKeys.state.rawValue] as? String ?? "",
            address: json[codingKeys.address.rawValue] as? String ?? "",
            format: json[codingKeys.format.rawValue] as? String ?? "",
            tag: json[codingKeys.tag.rawValue] as? String ?? ""
        )
    }

    static func fromArray(objects: [[String: Any]]) -> [DepositAddressBankModel] {

        var models = [DepositAddressBankModel]()
        for object in objects {
            // -- Creating the AccountBankModel
            let model = DepositAddressBankModel(json: object)
            if let model = model {
                models.append(model)
            }
        }
        return models
    }
}
