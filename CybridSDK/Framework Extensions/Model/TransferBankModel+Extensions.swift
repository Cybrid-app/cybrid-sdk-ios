//
//  TransferBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 28/03/23.
//

import Foundation
import CybridApiBankSwift

extension TransferBankModel {
    
    init?(json: [String: Any]) {
        guard
            let createdAt = json[TransferBankModel.CodingKeys.createdAt.rawValue] as? String
        else {
            return nil
        }

        let codingKeys = TransferBankModel.CodingKeys.self
        let createdAtDate = getDate(stringDate: createdAt)
        let type = json[TransferBankModel.CodingKeys.transferType.rawValue] as? String ?? "funding"
        let side = json[TransferBankModel.CodingKeys.side.rawValue] as? String ?? "deposit"
        let state = json[TransferBankModel.CodingKeys.state.rawValue] as? String ?? "storing"
        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            transferType: (TransferBankModel.TransferTypeBankModel(rawValue: type) ?? .funding) as TransferTypeBankModel,
            customerGuid: json[codingKeys.customerGuid.rawValue] as? String ?? "",
            quoteGuid: json[codingKeys.quoteGuid.rawValue] as? String ?? "",
            asset: json[codingKeys.asset.rawValue] as? String ?? "",
            side: (TransferBankModel.SideBankModel(rawValue: side) ?? .deposit) as SideBankModel,
            state: (TransferBankModel.StateBankModel(rawValue: state) ?? .storing) as StateBankModel,
            amount: json[codingKeys.amount.rawValue] as? Int ?? 0,
            fee: json[codingKeys.fee.rawValue] as? Int ?? 0,
            createdAt: createdAtDate)
    }

    static func fromArray(objects: [[String: Any]]) -> [TransferBankModel] {

        var models = [TransferBankModel]()
        for object in objects {
            let objectData = try? JSONSerialization.data(withJSONObject: object)
            var objectCopy = object
            // -- Creating the AccountBankModel
            let model = TransferBankModel(json: objectCopy)
            if let model = model {
                models.append(model)
            }
        }
        return models
    }
}
