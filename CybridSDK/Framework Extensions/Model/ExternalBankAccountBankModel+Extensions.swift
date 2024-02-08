//
//  ExternalBankAccountBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 10/12/22.
//

import CybridApiBankSwift

extension ExternalBankAccountBankModel {

    init?(json: [String: Any]) {

        guard
            let createdAt = json[ExternalBankAccountBankModel.CodingKeys.createdAt.rawValue] as? String
        else {
            return nil
        }

        let createdAtDate = getDate(stringDate: createdAt)
        let codingKeys = ExternalBankAccountBankModel.CodingKeys.self

        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            name: json[codingKeys.name.rawValue] as? String ?? "",
            asset: json[codingKeys.asset.rawValue] as? String ?? "",
            accountKind: json[codingKeys.accountKind.rawValue] as? String ?? "",
            environment: json[codingKeys.environment.rawValue] as? String ?? "",
            bankGuid: json[codingKeys.bankGuid.rawValue] as? String ?? "",
            customerGuid: json[codingKeys.customerGuid.rawValue] as? String ?? "",
            createdAt: createdAtDate!,
            plaidInstitutionId: json[codingKeys.plaidInstitutionId.rawValue] as? String ?? "",
            plaidAccountMask: json[codingKeys.plaidAccountMask.rawValue] as? String ?? "",
            plaidAccountName: json[codingKeys.plaidAccountName.rawValue] as? String ?? "",
            state: json[codingKeys.state.rawValue] as? String ?? "",
            failureCode: json[codingKeys.failureCode.rawValue] as? String ?? ""
        )
    }

    static func fromArray(objects: [[String: Any]]) -> [ExternalBankAccountBankModel] {

        var models = [ExternalBankAccountBankModel]()
        for object in objects {
            let objectCopy = object
            // -- Creating the AccountBankModel
            let model = ExternalBankAccountBankModel(json: objectCopy)
            if let model = model {
                models.append(model)
            }
        }
        return models
    }
}
