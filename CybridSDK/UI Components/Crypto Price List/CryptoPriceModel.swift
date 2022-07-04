//
//  CryptoPriceModel.swift
//  CybridSDK
//
//  Created by Cybrid on 20/06/22.
//

import CybridApiBankSwift
import Foundation

// MARK: - CryptoPriceModel

struct CryptoPriceModel: Equatable {
  let cryptoCode: String // BTC
  let cryptoName: String // Bitcoin
  let imageURL: String // https://abc.com/img.png
  let fiatCode: String // USD
  let formattedPrice: String // $20,300.129,870

  init(symbolPrice: SymbolPriceBankModel, cryptoAsset: AssetBankModel, fiatAsset: AssetBankModel) {
    self.cryptoCode = cryptoAsset.code
    self.cryptoName = cryptoAsset.name
    self.imageURL = Cybrid.getCryptoIconURLString(with: cryptoAsset.code)
    self.fiatCode = fiatAsset.code
    self.formattedPrice = CybridCurrencyFormatter.getExchangeString(from: cryptoAsset, to: fiatAsset, price: symbolPrice.buyPrice ?? 0)
  }
}

// MARK: - Mocked data
// FIXME: Remove Mocked data

extension CryptoPriceModel {
  static let mockList: [CryptoPriceModel] = [
    CryptoPriceModel(
      symbolPrice: SymbolPriceBankModel(
        symbol: "BTC_USD",
        buyPrice: 2_019_890,
        sellPrice: 2_019_880,
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
      ),
      cryptoAsset: .bitcoin,
      fiatAsset: .usd
    ),
    CryptoPriceModel(
      symbolPrice: SymbolPriceBankModel(
        symbol: "ETH_USD",
        buyPrice: 209_890,
        sellPrice: 209_880,
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
      ),
      cryptoAsset: .ethereum,
      fiatAsset: .usd
    ),
    CryptoPriceModel(
      symbolPrice: SymbolPriceBankModel(
        symbol: "DOGE_USD",
        buyPrice: 20_989_014_300_001,
        sellPrice: 20_988_014_300_001,
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
      ),
      cryptoAsset: .dogecoin,
      fiatAsset: .usd
    )
  ]
}

extension AssetBankModel {

  static let bitcoin = AssetBankModel(type: .crypto, code: "BTC", name: "Bitcoin", symbol: "B", decimals: 8)
  static let ethereum = AssetBankModel(type: .crypto, code: "ETH", name: "Ethereum", symbol: "E", decimals: 18)
  static let dogecoin = AssetBankModel(type: .crypto, code: "DOGE", name: "Dogecoin", symbol: "D", decimals: 8)
  static let usd = AssetBankModel(type: .fiat, code: "USD", name: "US Dollars", symbol: "$", decimals: 2)
  static let cad = AssetBankModel(type: .fiat, code: "CAD", name: "Canadian Dollars", symbol: "$", decimals: 2)
  static let eur = AssetBankModel(type: .fiat, code: "EUR", name: "Euros", symbol: "€", decimals: 2)

  static let cryptoAssets: [AssetBankModel] = [.bitcoin, .ethereum, .dogecoin]
  static let fiatAssets: [AssetBankModel] = [.usd, .cad, .eur]
}
