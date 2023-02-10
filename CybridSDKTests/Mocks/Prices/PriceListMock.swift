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
            buyPrice: "2019891",
            sellPrice: "2019881",
            buyPriceLastUpdatedAt: nil,
            sellPriceLastUpdatedAt: nil
        ),
        SymbolPriceBankModel(
            symbol: "ETH-USD",
            buyPrice: "209891",
            sellPrice: "209881",
            buyPriceLastUpdatedAt: nil,
            sellPriceLastUpdatedAt: nil
        )
    ]
}

extension SymbolPriceBankModel {

    static let btcUSD1 = SymbolPriceBankModel(
        symbol: "BTC-USD",
        buyPrice: "2019891",
        sellPrice: "2019881",
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
    )

    static let btcUSD2 = SymbolPriceBankModel(
        symbol: "BTC-USD",
        buyPrice: "2019815",
        sellPrice: "2019811",
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
    )

    static let ethUSD1 = SymbolPriceBankModel(
        symbol: "ETH-USD",
        buyPrice: "209891",
        sellPrice: "209881",
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
    )

    static let ethUSD2 = SymbolPriceBankModel(
        symbol: "ETH-USD",
        buyPrice: "209805",
        sellPrice: "209811",
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
    )

    static let priceWithoutSymbol = SymbolPriceBankModel(
        symbol: nil,
        buyPrice: "209891",
        sellPrice: "209881",
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
    )

    static let btcUsdBuyPriceNil = SymbolPriceBankModel(
        symbol: nil,
        buyPrice: nil,
        sellPrice: "209881",
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
    )
    
    static let btcUsdBuyPriceUndefined = SymbolPriceBankModel(
        symbol: nil,
        buyPrice: "Hola",
        sellPrice: "209881",
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
    )
}
