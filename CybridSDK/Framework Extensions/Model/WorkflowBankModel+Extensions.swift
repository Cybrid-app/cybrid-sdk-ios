//
//  WorkflowBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 07/12/22.
//

import CybridApiBankSwift

extension WorkflowBankModel {

    init?(json: [String: Any]) {

        guard
            let createdAt = json[WorkflowBankModel.CodingKeys.createdAt.rawValue] as? String
        else {
            return nil
        }

        let type = json[WorkflowBankModel.CodingKeys.type.rawValue] as? String ?? ""

        let codingKeys = WorkflowBankModel.CodingKeys.self
        let createdAtDate = getDate(stringDate: createdAt)

        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            customerGuid: json[codingKeys.customerGuid.rawValue] as? String ?? "",
            type: WorkflowBankModel.TypeBankModel(rawValue: type) ?? .plaid,
            createdAt: createdAtDate)
    }
}
