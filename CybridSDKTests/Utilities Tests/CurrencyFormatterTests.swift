//
//  CurrencyFormatterTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 29/06/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import Foundation
import XCTest

class CurrencyFormatterTests: XCTestCase {
  func testExchangeEthereum_toUSD_CurrencyString_EN_US() {
    // Given
    let asset1 = AssetBankModel.ethereum
    let asset2 = AssetBankModel.usd
    let price: NSNumber = 200_032

    // When
    let currencyString = CybridCurrencyFormatter.formatPrice(
      price,
      from: asset1,
      to: asset2
    )

    // Then
    XCTAssertEqual(currencyString, "$2,000.32")
  }

  func testExchangeEthereum_toUSD_CurrencyString_FR_CA() {
    // Given
    let asset1 = AssetBankModel.ethereum
    let asset2 = AssetBankModel.usd
    let price: NSNumber = 200_032

    // When
    let currencyString = CybridCurrencyFormatter.formatPrice(
      price,
      from: asset1,
      to: asset2,
      locale: Locale(identifier: "FR_CA")
    )

    // Then
    XCTAssertEqual(currencyString, "2 000,32 $")
  }

  func testDecimalMaxEthereum() {
    // Given
    let asset1 = AssetBankModel.usd
    let asset2 = AssetBankModel.ethereum
    let price = Decimal(string: "123456789123456789123456789123")
    XCTAssertNotNil(price)

    // When
    let currencyString = CybridCurrencyFormatter.formatPrice(
      price! as NSNumber,
      from: asset1,
      to: asset2
    )

    // Then
    XCTAssertEqual(currencyString, "Ξ 123,456,789,123.456789123456789123")
  }

  func testZeroPrice() {
    // Given
    let asset1 = AssetBankModel.usd
    let asset2 = AssetBankModel.ethereum
    let price: NSNumber = 0

    // When
    let currencyString = CybridCurrencyFormatter.formatPrice(
      price,
      from: asset1,
      to: asset2
    )

    // Then
    XCTAssertEqual(currencyString, "Ξ 0.000000000000000000")
  }

  func testNilPriceModel() {
    // Given
    let asset1 = AssetBankModel.usd
    let asset2 = AssetBankModel.ethereum
    let price = SymbolPriceBankModel(symbol: "$", buyPrice: nil, sellPrice: nil, buyPriceLastUpdatedAt: nil, sellPriceLastUpdatedAt: nil)

    // When
    let cryptoPriceModel = CryptoPriceModel(symbolPrice: price, lhAsset: asset1, rhAsset: asset2)

    // Then
    XCTAssertEqual(cryptoPriceModel.formattedPrice, "Ξ 0.000000000000000000")
  }

  func testTrimTrailingSymbol() {
    // Given
    let formattedAmount = "2 000,00 $"

    // When
    let trimmedAmount = CybridCurrencyFormatter.trimTrailingSymbol("$", formattedAmount: formattedAmount)

    // Then
    XCTAssertEqual(trimmedAmount, "2 000,00")
  }

  func testTrimTrailingSymbol_withAlreadyFormattedString() {
    // Given
    let formattedAmount = "2 000,00"

    // When
    let trimmedAmount = CybridCurrencyFormatter.trimTrailingSymbol("", formattedAmount: formattedAmount)

    // Then
    XCTAssertEqual(trimmedAmount, "2 000,00")
  }

  func testTrimTrailingSymbol_withoutSymbol() {
    // Given
    let formattedAmount = "2 000,00 $"

    // When
    let trimmedAmount = CybridCurrencyFormatter.trimTrailingSymbol("", formattedAmount: formattedAmount)

    // Then
    XCTAssertEqual(trimmedAmount, "2 000,00")
  }

  func testFormat_withNilFormattedAmount() {
    // Given
    let asset2 = AssetBankModel.usd
    let price = Decimal(string: "2789123")
    XCTAssertNotNil(price)
    let divisor = pow(BigDecimal(10), asset2.decimals)
    let baseUnit = price! / divisor
    let formatter = MockNumberFormatter()
    formatter.setFixedFormattedNumber(nil)

    // When
    let formattedAmount = CybridCurrencyFormatter.format(
      baseUnit: baseUnit,
      targetAsset: asset2,
      formatter: formatter,
      locale: Locale.current
    )

    // Then
    XCTAssertEqual(formattedAmount, "$0.00")
  }

  func testFormat_withInvalidLocale() {
    // Given
    let asset2 = AssetBankModel.usd
    let price = Decimal(string: "2789123")
    XCTAssertNotNil(price)
    let divisor = pow(BigDecimal(10), asset2.decimals)
    let baseUnit = price! / divisor
    let formatter = MockNumberFormatter()
    formatter.setFixedFormattedNumber(nil)

    // When
    let formattedAmount = CybridCurrencyFormatter.format(
      baseUnit: baseUnit,
      targetAsset: asset2,
      formatter: formatter,
      locale: Locale(identifier: "NaN")
    )

    // Then
    XCTAssertEqual(formattedAmount, "$0.00")
  }

  func testZeroDecimalsAmount() {
    // Given
    let asset1 = AssetBankModel.ethereum
    let asset2 = AssetBankModel(type: .fiat, code: "USD", name: "Whole Dollar", symbol: "$", decimals: 0)
    let price: NSNumber = 200_000

    // When
    let currencyString = CybridCurrencyFormatter.formatPrice(
      price,
      from: asset1,
      to: asset2
    )

    // Then
    XCTAssertEqual(currencyString, "$200,000")
  }
}
