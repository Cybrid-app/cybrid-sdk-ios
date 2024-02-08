//
//  BankBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 08/12/22.
//

import CybridApiBankSwift

extension BankBankModel {

    init?(json: [String: Any]) {

        guard
            let createdAt = json[BankBankModel.CodingKeys.createdAt.rawValue] as? String
        else {
            return nil
        }

        let codingKeys = BankBankModel.CodingKeys.self
        let createdAtDate = getDate(stringDate: createdAt)

        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            organizationGuid: json[codingKeys.organizationGuid.rawValue] as? String ?? "",
            name: json[codingKeys.name.rawValue] as? String ?? "",
            type: json[codingKeys.type.rawValue] as? String ?? "",
            supportedTradingSymbols: json[codingKeys.supportedTradingSymbols.rawValue] as? [String] ?? [],
            supportedFiatAccountAssets: json[codingKeys.supportedFiatAccountAssets.rawValue] as? [String] ?? [],
            supportedCountryCodes: json[codingKeys.supportedCountryCodes.rawValue] as? [String] ?? [],
            features: [],
            createdAt: createdAtDate!
        )
    }
}
