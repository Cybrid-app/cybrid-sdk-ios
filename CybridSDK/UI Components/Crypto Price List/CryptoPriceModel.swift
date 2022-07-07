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
  let assetCode: String // BTC
  let assetName: String // Bitcoin
  let imageURL: String // https://abc.com/img.png
  let pairAssetCode: String // USD
  let formattedPrice: String // $20,300.129,870

  init(symbolPrice: SymbolPriceBankModel, asset: AssetBankModel, pairAsset: AssetBankModel) {
    self.assetCode = asset.code
    self.assetName = asset.name
    self.imageURL = Cybrid.getCryptoIconURLString(with: asset.code)
    self.pairAssetCode = pairAsset.code
    self.formattedPrice = CybridCurrencyFormatter.formatPrice(
      BigInt(symbolPrice.buyPrice ?? 0), // FIXME: We should get BigInt from API
      to: pairAsset
    )
  }
}

// FIXME: Remove Mocked data
// MARK: - Mocked data

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
      asset: .bitcoin,
      pairAsset: .usd
    ),
    CryptoPriceModel(
      symbolPrice: SymbolPriceBankModel(
        symbol: "ETH_USD",
        buyPrice: 209_891,
        sellPrice: 209_881,
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
      ),
      asset: .ethereum,
      pairAsset: .usd
    ),
    CryptoPriceModel(
      symbolPrice: SymbolPriceBankModel(
        symbol: "DOGE_USD",
        buyPrice: 20_989_014_300_001,
        sellPrice: 20_988_014_300_001,
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
      ),
      asset: .dogecoin,
      pairAsset: .usd
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
