//
//  QuoteBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 14/09/22.
//

import Foundation
import CybridApiBankSwift

extension QuoteBankModel {

    init(json: [String: Any]) {

        let productTypeString = json[QuoteBankModel.CodingKeys.productType.rawValue] as? String ?? "trading"
        let productType = (QuoteBankModel.ProductTypeBankModel(rawValue: productTypeString) ?? .trading) as ProductTypeBankModel

        self.init(guid: json[QuoteBankModel.CodingKeys.guid.rawValue] as? String,
                  productType: productType,
                  bankGuid: json[QuoteBankModel.CodingKeys.bankGuid.rawValue] as? String,
                  customerGuid: json[QuoteBankModel.CodingKeys.customerGuid.rawValue] as? String,
                  symbol: json[QuoteBankModel.CodingKeys.symbol.rawValue] as? String,
                  side: json[QuoteBankModel.CodingKeys.side.rawValue] as? SideBankModel,
                  receiveAmount: json[QuoteBankModel.CodingKeys.receiveAmount.rawValue] as? String,
                  deliverAmount: json[QuoteBankModel.CodingKeys.deliverAmount.rawValue] as? String,
                  fee: json[QuoteBankModel.CodingKeys.fee.rawValue] as? String,
                  issuedAt: json[QuoteBankModel.CodingKeys.issuedAt.rawValue] as? Date,
                  expiresAt: json[QuoteBankModel.CodingKeys.expiresAt.rawValue] as? Date,
                  asset: json[QuoteBankModel.CodingKeys.asset.rawValue] as? String,
                  networkFee: json[QuoteBankModel.CodingKeys.networkFee.rawValue] as? String,
                  networkFeeAsset: json[QuoteBankModel.CodingKeys.networkFeeAsset.rawValue] as? String
        )
    }
}
