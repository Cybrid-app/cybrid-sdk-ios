//
//  ExternalWalletsBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 20/08/23.
//

import CybridApiBankSwift

extension ExternalWalletBankModel {

    init?(json: [String: Any]) {
        guard
            let createdAt = json[ExternalWalletBankModel.CodingKeys.createdAt.rawValue] as? String
        else {
            return nil
        }

        let codingKeys = ExternalWalletBankModel.CodingKeys.self
        let createdAtDate = getDate(stringDate: createdAt)

        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            name: json[codingKeys.name.rawValue] as? String ?? "",
            asset: json[codingKeys.asset.rawValue] as? String ?? "",
            environment: json[CodingKeys.environment.rawValue] as? String ?? "",
            bankGuid: json[codingKeys.bankGuid.rawValue] as? String ?? "",
            customerGuid: json[codingKeys.customerGuid.rawValue] as? String ?? "",
            address: json[codingKeys.address.rawValue] as? String ?? "",
            tag: json[codingKeys.tag.rawValue] as? String ?? "",
            createdAt: createdAtDate!,
            state: json[codingKeys.state.rawValue] as? String ?? "",
            failureCode: json[codingKeys.failureCode.rawValue] as? String ?? ""
        )
    }

    static func fromArray(objects: [[String: Any]]) -> [ExternalWalletBankModel] {

        var models = [ExternalWalletBankModel]()
        for object in objects {
            let model = ExternalWalletBankModel(json: object)
            if let model = model {
                models.append(model)
            }
        }
        return models
    }
}
