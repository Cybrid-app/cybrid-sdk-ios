//
//  CryptoPriceModel.swift
//  CybridSDK
//
//  Created by Cybrid on 20/06/22.
//

import BigInt
import CybridApiBankSwift
import Foundation

// MARK: - CryptoPriceModel

struct CryptoPriceModel: Equatable {
  let lhAssetCode: String // BTC
  let lhAssetName: String // Bitcoin
  let imageURL: String // https://abc.com/img.png
  let thAssetCode: String // USD
  let formattedPrice: String // $20,300.129,870

  init(symbolPrice: SymbolPriceBankModel, lhAsset: AssetBankModel, rhAsset: AssetBankModel) {
    self.lhAssetCode = lhAsset.code
    self.lhAssetName = lhAsset.name
    self.imageURL = Cybrid.getCryptoIconURLString(with: lhAsset.code)
    self.thAssetCode = rhAsset.code
    self.formattedPrice = CybridCurrencyFormatter.formatPrice(
      BigInt(symbolPrice.buyPrice ?? 0), // FIXME: We should get BigInt from API
      from: lhAsset,
      to: rhAsset
    )
  }
}

// MARK: - Mocked data
// FIXME: Remove Mocked data

extension CryptoPriceModel {
  static let mockList: [CryptoPriceModel] = [
    CryptoPriceModel(
      symbolPrice: SymbolPriceBankModel(
        symbol: "BTC_USD",
        buyPrice: 2_019_891,
        sellPrice: 2_019_881,
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
      ),
      lhAsset: .bitcoin,
      rhAsset: .usd
    ),
    CryptoPriceModel(
      symbolPrice: SymbolPriceBankModel(
        symbol: "ETH_USD",
        buyPrice: 209_891,
        sellPrice: 209_881,
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
      ),
      lhAsset: .ethereum,
      rhAsset: .usd
    ),
    CryptoPriceModel(
      symbolPrice: SymbolPriceBankModel(
        symbol: "DOGE_USD",
        buyPrice: 20_989_014_300_001,
        sellPrice: 20_988_014_300_001,
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
      ),
      lhAsset: .dogecoin,
      rhAsset: .usd
    )
  ]
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
}
