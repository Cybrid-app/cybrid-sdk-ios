//
//  CurrencyFormatterTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 29/06/22.
//

import BigInt
import CybridApiBankSwift
@testable import CybridSDK
import Foundation
import XCTest

class CurrencyFormatterTests: XCTestCase {
  func testExchangeEthereum_toUSD_CurrencyString_EN_US() {
    // Given
    let asset1 = AssetBankModel.ethereum
    let asset2 = AssetBankModel.usd
    let price = BigInt(200_032)

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
    let price = BigInt(200_032)

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

  func testSmallAmountFormatting() {
    // Given
    let asset1 = AssetBankModel.bitcoin
    let asset2 = AssetBankModel.usd
    let price = BigInt(20_032)

    // When
    let currencyString = CybridCurrencyFormatter.formatPrice(
      price,
      from: asset1,
      to: asset2
    )

    // Then
    XCTAssertEqual(currencyString, "$200.32")
  }

  func testNegativeAmountFormatting() {
    // Given
    let asset1 = AssetBankModel.bitcoin
    let asset2 = AssetBankModel.usd
    let price = BigInt(-20_032)

    // When
    let currencyString = CybridCurrencyFormatter.formatPrice(
      price,
      from: asset1,
      to: asset2
    )

    // Then
    XCTAssertEqual(currencyString, "-$200.32")
  }

  func testDecimalMaxEthereum() {
    // Given
    let asset1 = AssetBankModel.usd
    let asset2 = AssetBankModel.ethereum
    let price = BigInt("123456789123456789123456789123")
    let shaNumber = BigInt( "115792089237316195423570985008687907853269984665640564039457584007913129639935")

    // When
    let formattedPrice1 = CybridCurrencyFormatter.formatPrice(
      price,
      from: asset1,
      to: asset2
    )

    let formattedPrice2 = CybridCurrencyFormatter.formatPrice(
      shaNumber,
      from: asset1,
      to: asset2
    )

    // Then
    XCTAssertEqual(formattedPrice1, "Ξ 123,456,789,123.456789123456789123")
    XCTAssertEqual(formattedPrice2, "Ξ 115,792,089,237,316,195,423,570,985,008,687,907,853,269,984,665,640,564,039,457.584007913129639935")
  }

  func testZeroPrice() {
    // Given
    let asset1 = AssetBankModel.usd
    let asset2 = AssetBankModel.ethereum
    let price = BigInt(0)

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

  func testZeroDecimalsAmount() {
    // Given
    let asset1 = AssetBankModel.ethereum
    let asset2 = AssetBankModel(type: .fiat, code: "USD", name: "Whole Dollar", symbol: "$", decimals: 0)
    let price = BigInt(200_000)

    // When
    let currencyString = CybridCurrencyFormatter.formatPrice(
      price,
      from: asset1,
      to: asset2
    )

    // Then
    XCTAssertEqual(currencyString, "$200,000")
  }

  func testZeroCurrencyAmountGenerator() {
    // Given
    let formatter = MockNumberFormatter()
    formatter.setFixedFormattedNumber(nil)

    // When
    let formattedZero = CybridCurrencyFormatter.zeroCurrencyAmount(formatter: formatter)

    // Then
    XCTAssertEqual(formattedZero, "$0.00")
  }

  func testLocalizedCurrencySymbol_Leading() {
    // Given
    let locale = Locale(identifier: "en_US")
    let currencySymbol = "$"
    let formatter = CybridCurrencyFormatter.makeDefaultFormatter(locale: locale, precision: 2, currencySymbol: currencySymbol)

    // When
    let localizedSymbol = CybridCurrencyFormatter.localizedCurrencySymbol(locale: locale,
                                                                          currencySymbol: currencySymbol,
                                                                          formatter: formatter)

    // Then
    XCTAssertEqual(localizedSymbol, .leading(symbol: "$"))
  }

  func testLocalizedCurrencySymbol_Trailing() {
    // Given
    let locale = Locale(identifier: "fr_CAD")
    let currencySymbol = "$"
    let formatter = CybridCurrencyFormatter.makeDefaultFormatter(locale: locale, precision: 2, currencySymbol: currencySymbol)

    // When
    let localizedSymbol = CybridCurrencyFormatter.localizedCurrencySymbol(locale: locale,
                                                                          currencySymbol: currencySymbol,
                                                                          formatter: formatter)

    // Then
    XCTAssertEqual(localizedSymbol, .trailing(symbol: " $"))
  }

  func testLocalizedCurrencySymbol_withInvalidFormatter() {
    // Given
    let locale = Locale(identifier: "fr_CAD")
    let currencySymbol = "$"
    let formatter = MockNumberFormatter()
    formatter.setFixedFormattedNumber("20.00")

    // When
    let localizedSymbol = CybridCurrencyFormatter.localizedCurrencySymbol(locale: locale,
                                                                          currencySymbol: currencySymbol,
                                                                          formatter: formatter)

    // Then - fallsback to default leading symbol
    XCTAssertEqual(localizedSymbol, .leading(symbol: "$"))
  }

  func testDefaultSeparatorsFallback() {
    // Given
    let locale = Locale(identifier: "en_US")
    let currencySymbol = "$"
    let amount = BigDecimal(1_000_000, 2)

    // When
    let localizedCurrencyString = CybridCurrencyFormatter.localizedCurrencyString(
      from: amount,
      locale: locale,
      groupingSeparator: nil,
      decimalSeparator: nil,
      currencySymbol: currencySymbol)

    // Then - fallsback to default separators `.` and `,`
    XCTAssertEqual(localizedCurrencyString, "$10,000.00")
  }
}
