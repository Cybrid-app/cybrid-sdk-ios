//
//  WorkflowWithDetailsBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 07/12/22.
//

import CybridApiBankSwift

extension WorkflowWithDetailsBankModel {

    init?(json: [String: Any]) {

        guard
            let createdAt = json[WorkflowWithDetailsBankModel.CodingKeys.createdAt.rawValue] as? String
        else {
            return nil
        }

        let type = json[WorkflowWithDetailsBankModel.CodingKeys.type.rawValue] as? String ?? ""
        let state = json[WorkflowWithDetailsBankModel.CodingKeys.type.rawValue] as? String ?? ""

        let codingKeys = WorkflowWithDetailsBankModel.CodingKeys.self
        let createdAtDate = getDate(stringDate: createdAt)

        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            customerGuid: json[codingKeys.customerGuid.rawValue] as? String ?? "",
            type: WorkflowWithDetailsBankModel.TypeBankModel(rawValue: type) ?? .plaid,
            state: WorkflowWithDetailsBankModel.StateBankModel(rawValue: state) ?? .storing,
            failureCode: json[codingKeys.failureCode.rawValue] as? String ?? "",
            createdAt: createdAtDate,
            plaidLinkToken: json[codingKeys.plaidLinkToken.rawValue] as? String ?? "")
    }
}
