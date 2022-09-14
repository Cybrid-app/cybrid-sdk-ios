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
  let counterAssetCode: String // USD
  let formattedPrice: String // $20,300.129,870

  init?(symbolPrice: SymbolPriceBankModel, asset: AssetBankModel, counterAsset: AssetBankModel) {
    guard let buyPrice = symbolPrice.buyPrice else { return nil }
    self.assetCode = asset.code
    self.assetName = asset.name
    self.imageURL = Cybrid.getCryptoIconURLString(with: asset.code)
    self.counterAssetCode = counterAsset.code
    let bigDecimal = OLDBigDecimal(buyPrice, precision: counterAsset.decimals) ?? OLDBigDecimal(0)
      self.formattedPrice = CybridCurrencyFormatter.formatPrice(bigDecimal, with: counterAsset.symbol)
  }
}
