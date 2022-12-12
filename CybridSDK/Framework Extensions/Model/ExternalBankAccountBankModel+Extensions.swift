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

        let accountKind = json[ExternalBankAccountBankModel.CodingKeys.accountKind.rawValue] as? String ?? ""
        let accountKindValue = ExternalBankAccountBankModel.AccountKindBankModel(rawValue: accountKind) ?? .plaid

        let environment = json[ExternalBankAccountBankModel.CodingKeys.environment.rawValue] as? String ?? ""
        let evnironmentValue = ExternalBankAccountBankModel.EnvironmentBankModel(rawValue: environment) ?? .sandbox

        let state = json[ExternalBankAccountBankModel.CodingKeys.state.rawValue] as? String ?? ""
        let stateValue = ExternalBankAccountBankModel.StateBankModel(rawValue: state) ?? .storing

        let createdAtDate = getDate(stringDate: createdAt)

        let codingKeys = ExternalBankAccountBankModel.CodingKeys.self

        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            name: json[codingKeys.name.rawValue] as? String ?? "",
            asset: json[codingKeys.asset.rawValue] as? String ?? "",
            accountKind: accountKindValue,
            environment: evnironmentValue,
            bankGuid: json[codingKeys.bankGuid.rawValue] as? String ?? "",
            customerGuid: json[codingKeys.customerGuid.rawValue] as? String ?? "",
            createdAt: createdAtDate!,
            plaidInstitutionId: json[codingKeys.plaidInstitutionId.rawValue] as? String ?? "",
            plaidAccountMask: json[codingKeys.plaidAccountMask.rawValue] as? String ?? "",
            plaidAccountName: json[codingKeys.plaidAccountName.rawValue] as? String ?? "",
            state: stateValue,
            failureCode: json[codingKeys.failureCode.rawValue] as? String ?? ""
        )
    }
}
