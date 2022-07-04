//
//  CybridCurrencyFormatter.swift
//  CybridSDK
//
//  Created by Cybrid on 4/07/22.
//

import CybridApiBankSwift
import Foundation

struct CybridCurrencyFormatter {
  typealias BigDecimal = Decimal

  static func getExchangeString(from asset1: AssetBankModel, to asset2: AssetBankModel, price: Int) -> String {
    let divisor = pow(BigDecimal(10), asset2.decimals)
    let value = BigDecimal(price)
    let baseUnit = value / divisor
    let zeroAmount = asset2.symbol + "0"
    return format(baseUnit: baseUnit, targetAsset: asset2) ?? zeroAmount
  }

  static func format(baseUnit: BigDecimal, targetAsset: AssetBankModel) -> String? {
    let formatter = makeNumberFormatter(with: targetAsset)
    return formatter.string(from: baseUnit as NSNumber)
  }

  private static func makeNumberFormatter(with asset: AssetBankModel) -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.currencyCode = asset.code
    formatter.currencySymbol = asset.symbol
    formatter.numberStyle = .currency
    formatter.decimalSeparator = "."
    return formatter
  }
}
