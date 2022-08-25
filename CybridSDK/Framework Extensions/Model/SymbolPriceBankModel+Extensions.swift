//
//  SymbolPriceBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 25/08/22.
//

import Foundation
import CybridApiBankSwift
import BigInt

extension SymbolPriceBankModel {

    init?(json: [String: Any]) {
        guard
            let buyPriceString = json[SymbolPriceBankModel.CodingKeys.buyPrice.rawValue] as? String,
            let sellPriceString = json[SymbolPriceBankModel.CodingKeys.sellPrice.rawValue] as? String,
            let buyPrice = BigInt(buyPriceString),
            let sellPrice = BigInt(sellPriceString)
        else {
            return nil
        }

        self.init(
            symbol: json[SymbolPriceBankModel.CodingKeys.symbol.rawValue] as? String,
            buyPrice: buyPrice,
            sellPrice: sellPrice,
            buyPriceLastUpdatedAt: json[SymbolPriceBankModel.CodingKeys.buyPriceLastUpdatedAt.rawValue] as? Date,
            sellPriceLastUpdatedAt: json[SymbolPriceBankModel.CodingKeys.sellPriceLastUpdatedAt.rawValue] as? Date)
  }
}
