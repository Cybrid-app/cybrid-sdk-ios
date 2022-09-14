//
//  TradeBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 14/09/22.
//

import Foundation
import CybridApiBankSwift

extension TradeBankModel {

    init?(json: [String: Any]) {
        guard
            let createdAt = json[TradeBankModel.CodingKeys.createdAt.rawValue] as? String,
            let deliverAmount = json[TradeBankModel.CodingKeys.deliverAmount.rawValue] as? String,
            let fee = json[TradeBankModel.CodingKeys.fee.rawValue] as? String,
            let receiveAmount = json[TradeBankModel.CodingKeys.receiveAmount.rawValue] as? String,
            let side = json[TradeBankModel.CodingKeys.side.rawValue] as? String,
            let state = json[TradeBankModel.CodingKeys.state.rawValue] as? String
        else {
            return nil
        }

        let codingKeys = TradeBankModel.CodingKeys.self
        let createdAtDate = getDate(stringDate: createdAt)
        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            customerGuid: json[codingKeys.customerGuid.rawValue] as? String ?? "",
            quoteGuid: json[codingKeys.quoteGuid.rawValue] as? String ?? "",
            symbol: json[codingKeys.symbol.rawValue] as? String ?? "",
            side: (TradeBankModel.SideBankModel(rawValue: side) ?? .buy) as SideBankModel,
            state: (TradeBankModel.StateBankModel(rawValue: state) ?? .settling) as StateBankModel,
            receiveAmount: receiveAmount,
            deliverAmount: deliverAmount,
            fee: fee,
            createdAt: createdAtDate)
    }

    static func fromArray(objects: [[String: Any]]) -> [TradeBankModel] {

        var models = [TradeBankModel]()
        for object in objects {
            let objectData = try? JSONSerialization.data(withJSONObject: object)
            var objectCopy = object
            // -- Magic transform NSNumber to String
            if let objectData = objectData {

                let stringChangeValues = [
                    TradeBankModel.CodingKeys.deliverAmount.rawValue,
                    TradeBankModel.CodingKeys.fee.rawValue,
                    TradeBankModel.CodingKeys.receiveAmount.rawValue
                ]
                for change in stringChangeValues {
                    objectCopy[change] = stringValue(forKey: change, in: objectData)
                }
            }
            // -- Creating the AccountBankModel
            let model = TradeBankModel(json: objectCopy)
            if let model = model {
                models.append(model)
            }
        }
        return models
    }
}
