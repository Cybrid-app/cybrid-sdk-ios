//
//  CybridCurrencyFormatter.swift
//  CybridSDK
//
//  Created by Cybrid on 4/07/22.
//

import CybridApiBankSwift
import Foundation

public typealias BigDecimal = Decimal

struct CybridCurrencyFormatter {

  static func formatPrice(_ price: NSNumber,
                          from asset1: AssetBankModel,
                          to asset2: AssetBankModel,
                          locale: Locale = Locale.current) -> String {
    let divisor = pow(BigDecimal(10), asset2.decimals)
    let value = price.decimalValue
    let baseUnit = value / divisor
    let formatter = makeFormatter(with: asset2, locale: locale)
    return format(baseUnit: baseUnit, targetAsset: asset2, formatter: formatter, locale: locale)
  }

  static func format(baseUnit: BigDecimal,
                     targetAsset: AssetBankModel,
                     formatter: NumberFormatter,
                     locale: Locale) -> String {
    let baseNumber = baseUnit as NSNumber
    let decimalSpaces = targetAsset.decimals
    let localizedSymbol = targetAsset.symbol

    guard
      let lossyAmount = formatter.string(from: baseNumber),
      let localizedSeparator = locale.decimalSeparator?.first,
      let formattedUnits = (lossyAmount).split(separator: localizedSeparator).first,
      let unitsNumber = formatter.number(from: String(formattedUnits)),
      let precisionFormattedStrings = formatter.string(from: (baseUnit - unitsNumber.decimalValue) as NSNumber)?
        .split(separator: localizedSeparator)
    else {
      return formatter.string(from: 0) ?? "$0.00"
    }

    let trimmedFormattedUnits = trimTrailingSymbol(localizedSymbol, formattedAmount: String(formattedUnits))

    var result = String(trimmedFormattedUnits)

    if decimalSpaces > 0 {
      if precisionFormattedStrings.count > 1 {
        var rawDecimals = precisionFormattedStrings[1]
        while rawDecimals.count < decimalSpaces { rawDecimals += "0" }
        result += "\(localizedSeparator)" + rawDecimals
      }
    }
    return result
  }

  static func makeFormatter(with asset: AssetBankModel, locale: Locale) -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.usesSignificantDigits = true
    formatter.locale = locale
    formatter.numberStyle = .currency
    formatter.currencyCode = asset.code
    formatter.currencySymbol = asset.symbol
    formatter.minimumSignificantDigits = asset.decimals
    formatter.maximumSignificantDigits = asset.decimals
    formatter.roundingMode = .halfEven
    return formatter
  }

  static func trimTrailingSymbol(_ symbol: String, formattedAmount: String) -> String {
    guard
      formattedAmount.hasSuffix(symbol),
      let index = formattedAmount.firstIndex(of: symbol.first ?? "$")
    else { return formattedAmount }
    let trimmedAmount = formattedAmount.prefix(upTo: index)
    return trimmedAmount.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
