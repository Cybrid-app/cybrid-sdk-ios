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

        let sourceAccountJson = json[TransferBankModel.CodingKeys.sourceAccount.rawValue] as? [String: Any] ?? ["": ""]
        let sourceAccount = TransferBankModel.getSourceAccount(sourceAccountJson: sourceAccountJson)

        let destinationAccountJson = json[TransferBankModel.CodingKeys.destinationAccount.rawValue] as? [String: Any] ?? ["": ""]
        let destinationAccount = TransferBankModel.getDestinationAccount(destinationAccountJson: destinationAccountJson)

        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            transferType: json[codingKeys.transferType.rawValue] as? String ?? "",
            bankGuid: json[codingKeys.bankGuid.rawValue] as? String ?? "",
            customerGuid: json[codingKeys.customerGuid.rawValue] as? String ?? "",
            quoteGuid: json[codingKeys.quoteGuid.rawValue] as? String ?? "",
            externalBankAccountGuid: json[codingKeys.externalBankAccountGuid.rawValue] as? String ?? "",
            asset: json[codingKeys.asset.rawValue] as? String ?? "",
            side: json[codingKeys.side.rawValue] as? String ?? "",
            state: json[codingKeys.state.rawValue] as? String ?? "",
            failureCode: json[codingKeys.failureCode.rawValue] as? String ?? "",
            amount: json[codingKeys.amount.rawValue] as? Int ?? 0,
            estimatedAmount: json[codingKeys.estimatedAmount.rawValue] as? Int ?? 0,
            fee: json[codingKeys.fee.rawValue] as? Int ?? 0,
            estimatedNetworkFee: json[codingKeys.estimatedNetworkFee.rawValue] as? Int ?? 0,
            networkFee: json[codingKeys.networkFee.rawValue] as? Int ?? 0,
            networkFeeAsset: json[codingKeys.networkFeeAsset.rawValue] as? String ?? "",
            networkFeeLiabilityAmount: json[codingKeys.networkFeeLiabilityAmount.rawValue] as? Int ?? 0,
            networkFeeLiabilityAmountAsset: json[codingKeys.networkFeeLiabilityAmountAsset.rawValue] as? String ?? "",
            txnHash: json[codingKeys.txnHash.rawValue] as? String ?? "",
            sourceAccount: sourceAccount,
            destinationAccount: destinationAccount,
            createdAt: createdAtDate)
    }

    private static func getSourceAccount(sourceAccountJson: [String: Any]) -> TransferSourceAccountBankModel {

        let sourceAccountType = sourceAccountJson[TransferSourceAccountBankModel.CodingKeys.type.rawValue] as? String ?? ""
        let sourceAccountGuid = sourceAccountJson[TransferSourceAccountBankModel.CodingKeys.guid.rawValue] as? String ?? ""
        return TransferSourceAccountBankModel(
            guid: sourceAccountGuid,
            type: sourceAccountType
        )
    }

    private static func getDestinationAccount(destinationAccountJson: [String: Any]) -> TransferDestinationAccountBankModel {

        let destinationAccountType = destinationAccountJson[TransferDestinationAccountBankModel.CodingKeys.type.rawValue] as? String ?? ""
        let destinationAccountGuid = destinationAccountJson[TransferDestinationAccountBankModel.CodingKeys.guid.rawValue] as? String ?? ""
        return TransferDestinationAccountBankModel(
            guid: destinationAccountGuid,
            type: destinationAccountType
        )
    }

    static func fromArray(objects: [[String: Any]]) -> [TransferBankModel] {

        var models = [TransferBankModel]()
        for object in objects {
            // -- Creating the AccountBankModel
            let model = TransferBankModel(json: object)
            if let model = model {
                models.append(model)
            }
        }
        return models
    }
}
