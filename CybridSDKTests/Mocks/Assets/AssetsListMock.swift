//
//  AssetsListMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 19/07/22.
//

import CybridApiBankSwift

extension AssetListBankModel {
  static var mock = AssetListBankModel(
    total: 1,
    page: 0,
    perPage: 2,
    objects: [
      .bitcoin,
      .ethereum,
      .usd,
      .eur
    ]
  )
}

extension AssetBankModel {
  static let bitcoin = AssetBankModel(type: .crypto, code: "BTC", name: "Bitcoin", symbol: "₿", decimals: 8)
  static let ethereum = AssetBankModel(type: .crypto, code: "ETH", name: "Ethereum", symbol: "Ξ", decimals: 18)
  static let dogecoin = AssetBankModel(type: .crypto, code: "DOGE", name: "Dogecoin", symbol: "∂", decimals: 8)
  static let usd = AssetBankModel(type: .fiat, code: "USD", name: "US Dollars", symbol: "$", decimals: 2)
  static let cad = AssetBankModel(type: .fiat, code: "CAD", name: "Canadian Dollars", symbol: "$", decimals: 2)
  static let eur = AssetBankModel(type: .fiat, code: "EUR", name: "Euros", symbol: "€", decimals: 2)

  static let cryptoAssets: [AssetBankModel] = [.bitcoin, .ethereum, .dogecoin]
  static let fiatAssets: [AssetBankModel] = [.usd, .cad, .eur]
  static let mock: [AssetBankModel] = [.bitcoin, .ethereum, .usd]
}
