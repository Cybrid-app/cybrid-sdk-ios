//
//  CybridCurrencyFormatter.swift
//  CybridSDK
//
//  Created by Cybrid on 4/07/22.
//

import BigInt
import CybridApiBankSwift
import Foundation

struct CybridCurrencyFormatter {

  enum CurrencySymbol: Equatable {
    case leading(symbol: String)
    case trailing(symbol: String)
  }

  static func makeDefaultFormatter(locale: Locale = Locale.autoupdatingCurrent,
                                   precision: Int = 2,
                                   currencySymbol: String) -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.locale = locale
    formatter.numberStyle = .currency
    formatter.currencySymbol = currencySymbol
    formatter.minimumSignificantDigits = precision + 1 // 1 for the integer and precision for the fractions
    return formatter
  }

  static func zeroCurrencyAmount(formatter: NumberFormatter) -> String {
    return formatter.string(from: 0) ?? "$0.00"
  }

  static func localizedCurrencySymbol(locale: Locale,
                                      currencySymbol: String,
                                      formatter: NumberFormatter) -> CurrencySymbol {
    let currencyExample = zeroCurrencyAmount(formatter: formatter)

    if currencyExample.hasSuffix(currencySymbol),
        let suffixIndex = currencyExample.lastIndex(of: "0") {
      let suffixSymbol = currencyExample
        .suffix(currencyExample.count - suffixIndex.utf16Offset(in: currencyExample) - 1)
      return .trailing(symbol: String(suffixSymbol))
    } else if currencyExample.hasPrefix(currencySymbol),
              let firstNumberIndex = currencyExample.firstIndex(of: "0") {
      let prefixSymbol = currencyExample.prefix(upTo: firstNumberIndex)
      return .leading(symbol: String(prefixSymbol))
    }
    return .leading(symbol: "$")
  }

  private static func groups(string: String, size: Int) -> [String] {
    if string.count <= size { return [string] }
    let groupBoundaries = stride(from: 0, to: string.count, by: size) + [string.count]
    let ranges = (0..<groupBoundaries.count - 1).map { groupBoundaries[$0]..<groupBoundaries[$0 + 1] }.reversed()
    let groups = ranges.map { range -> String in
        let lowerIndex = string.index(string.endIndex, offsetBy: -range.upperBound)
        let upperIndex = string.index(string.endIndex, offsetBy: -range.lowerBound)
        return String(string[lowerIndex..<upperIndex])
    }
    return groups
  }

  static func localizedCurrencyString(from number: BigDecimal,
                                      locale: Locale,
                                      groupingSeparator: String?,
                                      decimalSeparator: String?,
                                      currencySymbol: String,
                                      baseFormatter: NumberFormatter? = nil) -> String {
    let currencyFormatter = baseFormatter ?? makeDefaultFormatter(locale: locale,
                                                                  precision: number.precision,
                                                                  currencySymbol: currencySymbol)
    let formattedZeroCurrency = zeroCurrencyAmount(formatter: currencyFormatter)

    if number.value == 0 { return formattedZeroCurrency }

    let localizedCurrencySymbol = localizedCurrencySymbol(locale: locale,
                                                          currencySymbol: currencySymbol,
                                                          formatter: currencyFormatter)
    let groupingSeparator = groupingSeparator ?? ","
    let decimalSeparator = decimalSeparator ?? "."

    var numberString = String(abs(number.value))
    let leadingZeroesForSmallNumbers = String(repeating: "0",
                                              count: max(0, number.precision - numberString.count + 1))
    numberString = leadingZeroesForSmallNumbers + numberString

    let fractional = String(numberString.suffix(number.precision))
    let integer = String(numberString.prefix(numberString.count - fractional.count))

    let isNegative = number.value < 0
    let negativeSign = isNegative ? "-" : ""

    let integerGroupped = groups(string: integer, size: 3).joined(separator: groupingSeparator)
    let magnitude = fractional.isEmpty ? integerGroupped : integerGroupped + decimalSeparator + fractional
    let sign = (magnitude != formattedZeroCurrency && isNegative) ? negativeSign : ""

    switch localizedCurrencySymbol {
    case .leading(let symbol):
      return sign + symbol + magnitude
    case .trailing(let symbol):
      return sign + magnitude + symbol
    }
  }

  static func formatPrice(_ price: BigInt,
                          from asset1: AssetBankModel,
                          to asset2: AssetBankModel,
                          locale: Locale = Locale.current) -> String {
    return localizedCurrencyString(from: BigDecimal(price, asset2.decimals),
                                   locale: locale,
                                   groupingSeparator: locale.groupingSeparator,
                                   decimalSeparator: locale.decimalSeparator,
                                   currencySymbol: asset2.symbol)
  }
}

public struct BigDecimal: Hashable {
    public var value: BigInt
    public var precision: Int

    public init(_ value: BigInt, _ precision: Int) {
        self.value = value
        self.precision = precision
    }
}
