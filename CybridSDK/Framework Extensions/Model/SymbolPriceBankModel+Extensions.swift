//
//  SymbolPriceBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 14/09/22.
//

import Foundation
import CybridApiBankSwift

extension SymbolPriceBankModel {

    init?(json: [String: Any]) {
        guard
            let buyPriceString = json[SymbolPriceBankModel.CodingKeys.buyPrice.rawValue] as? String,
            let sellPriceString = json[SymbolPriceBankModel.CodingKeys.sellPrice.rawValue] as? String
        else {
            return nil
        }

        self.init(
            symbol: json[SymbolPriceBankModel.CodingKeys.symbol.rawValue] as? String,
            buyPrice: buyPriceString,
            sellPrice: sellPriceString,
            buyPriceLastUpdatedAt: json[SymbolPriceBankModel.CodingKeys.buyPriceLastUpdatedAt.rawValue] as? Date,
            sellPriceLastUpdatedAt: json[SymbolPriceBankModel.CodingKeys.sellPriceLastUpdatedAt.rawValue] as? Date)
  }
}
