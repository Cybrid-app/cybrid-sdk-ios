//
//  Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 22/08/22.
//

import Foundation
import BigInt
import CybridApiBankSwift

extension AccountBankModel {
    init?(json: [String: Any]) {
        guard
            let platformAvailableValue = json[AccountBankModel.CodingKeys.platformAvailable.rawValue] as? String,
            let platfomrBalanceValue = json[AccountBankModel.CodingKeys.platformBalance.rawValue] as? String,
            let type = json[AccountBankModel.CodingKeys.type.rawValue] as? String,
            let state = json[AccountBankModel.CodingKeys.state.rawValue] as? String
        else {
            return nil
        }
        self.init(
            type: (AccountBankModel.TypeBankModel(rawValue: type) ?? .trading) as TypeBankModel,
            provider: json[AccountBankModel.CodingKeys.provider.rawValue] as? ProviderBankModel,
            guid: json[AccountBankModel.CodingKeys.guid.rawValue] as? String,
            createdAt: json[AccountBankModel.CodingKeys.createdAt.rawValue] as? Date,
            asset: json[AccountBankModel.CodingKeys.asset.rawValue] as? String,
            name: json[AccountBankModel.CodingKeys.name.rawValue] as? String,
            bankGuid: json[AccountBankModel.CodingKeys.bankGuid.rawValue] as? String,
            customerGuid: json[AccountBankModel.CodingKeys.customerGuid.rawValue] as? String,
            platformBalance: platfomrBalanceValue,
            platformAvailable: platformAvailableValue,
            state: StateBankModel(rawValue: state))
    }

    static func fromArray(objects: [[String: Any]]) -> [AccountBankModel] {
        var models = [AccountBankModel]()
        for object in objects {
            let objectData = try? JSONSerialization.data(withJSONObject: object)
            var objectCopy = object
            // -- Magic transform NSNumber to String
            if let objectData = objectData {
                let platfomrAvailableKey = AccountBankModel.CodingKeys.platformAvailable.rawValue
                let platfomrBalanceKey = AccountBankModel.CodingKeys.platformBalance.rawValue
                objectCopy[platfomrAvailableKey] = stringValue(forKey: platfomrAvailableKey, in: objectData)
                objectCopy[platfomrBalanceKey] = stringValue(forKey: platfomrBalanceKey, in: objectData)
            }
            // -- Creating the AccountBankModel
            let model = AccountBankModel(json: objectCopy)
            if let model = model {
                models.append(model)
            }
        }
        return models
    }
}
