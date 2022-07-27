//
//  PriceListMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 19/07/22.
//

import CybridApiBankSwift
import Foundation

extension Array where Element == SymbolPriceBankModel {
  static let mockPrices: Self = [
    SymbolPriceBankModel(
      symbol: "BTC-USD",
      buyPrice: 2_019_891,
      sellPrice: 2_019_881,
      buyPriceLastUpdatedAt: nil,
      sellPriceLastUpdatedAt: nil
    ),
    SymbolPriceBankModel(
      symbol: "ETH-USD",
      buyPrice: 209_891,
      sellPrice: 209_881,
      buyPriceLastUpdatedAt: nil,
      sellPriceLastUpdatedAt: nil
    )
  ]
}

extension SymbolPriceBankModel {
  static let btcUSD1 = SymbolPriceBankModel(
    symbol: "BTC-USD",
    buyPrice: 2_019_891,
    sellPrice: 2_019_881,
    buyPriceLastUpdatedAt: nil,
    sellPriceLastUpdatedAt: nil
  )

  static let btcUSD2 = SymbolPriceBankModel(
    symbol: "BTC-USD",
    buyPrice: 2_019_815,
    sellPrice: 2_019_811,
    buyPriceLastUpdatedAt: nil,
    sellPriceLastUpdatedAt: nil
  )

  static let ethUSD1 = SymbolPriceBankModel(
    symbol: "ETH-USD",
    buyPrice: 209_891,
    sellPrice: 209_881,
    buyPriceLastUpdatedAt: nil,
    sellPriceLastUpdatedAt: nil
  )

  static let ethUSD2 = SymbolPriceBankModel(
    symbol: "ETH-USD",
    buyPrice: 209_805,
    sellPrice: 209_811,
    buyPriceLastUpdatedAt: nil,
    sellPriceLastUpdatedAt: nil
  )
}
