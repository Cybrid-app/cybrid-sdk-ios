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

        let codingKeys = WorkflowWithDetailsBankModel.CodingKeys.self
        let createdAtDate = getDate(stringDate: createdAt)

        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            customerGuid: json[codingKeys.customerGuid.rawValue] as? String ?? "",
            type: json[codingKeys.type.rawValue] as? String ?? "",
            state: json[codingKeys.state.rawValue] as? String ?? "",
            failureCode: json[codingKeys.failureCode.rawValue] as? String ?? "",
            createdAt: createdAtDate,
            plaidLinkToken: json[codingKeys.plaidLinkToken.rawValue] as? String ?? "")
    }
}
