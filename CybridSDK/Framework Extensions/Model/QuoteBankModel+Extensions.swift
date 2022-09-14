//
//  QuoteBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 14/09/22.
//

import Foundation

extension QuoteBankModel {
    
    init?(json: [String: Any]) {
        
        guard
            let deliverAmountString = json[QuoteBankModel.CodingKeys.deliverAmount.rawValue] as? String
            //let receiveAmountString = json[QuoteBankModel.CodingKeys.receiveAmount.rawValue] as? String,
            //let feeAmountString = json[QuoteBankModel.CodingKeys.fee.rawValue] as? String
            //let deliverAmount = BigInt(deliverAmountString),
            //let receiveAmount = BigInt(receiveAmountString),
            //let feeAmount = BigInt(feeAmountString)
        else {
            return nil
        }
        self.init(guid: json[QuoteBankModel.CodingKeys.guid.rawValue] as? String,
                  customerGuid: json[QuoteBankModel.CodingKeys.customerGuid.rawValue] as? String,
                  symbol: json[QuoteBankModel.CodingKeys.symbol.rawValue] as? String,
                  side: json[QuoteBankModel.CodingKeys.side.rawValue] as? SideBankModel,
                  receiveAmount: json[QuoteBankModel.CodingKeys.receiveAmount.rawValue] as? String,
                  deliverAmount: json[QuoteBankModel.CodingKeys.deliverAmount.rawValue] as? String,
                  fee: json[QuoteBankModel.CodingKeys.fee.rawValue] as? String,
                  issuedAt: json[QuoteBankModel.CodingKeys.issuedAt.rawValue] as? Date,
                  expiresAt: json[QuoteBankModel.CodingKeys.expiresAt.rawValue] as? Date)
    }
}
