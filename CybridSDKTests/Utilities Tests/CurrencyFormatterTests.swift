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

// MARK: - Formatting Happy Paths

class CurrencyFormatterTests: XCTestCase {
  func testAmountFormatting_withDifferentCurrencies() {
    // Given
    let price = BigInt(123_456_789_123_456_789)

    // When
    let bitcoinString = CybridCurrencyFormatter.formatPrice(
      BigDecimal(price, AssetBankModel.bitcoin.decimals), // 8 decimal digits
      with: AssetBankModel.bitcoin.symbol
    )
    let ethereumString = CybridCurrencyFormatter.formatPrice(
      BigDecimal(price, AssetBankModel.ethereum.decimals), // 18 decimal digits
      with: AssetBankModel.ethereum.symbol
    )
    let dogecoinString = CybridCurrencyFormatter.formatPrice(
      BigDecimal(price, AssetBankModel.dogecoin.decimals), // 8 decimal digits
      with: AssetBankModel.dogecoin.symbol
    )
    let usdString = CybridCurrencyFormatter.formatPrice(
      BigDecimal(price, AssetBankModel.usd.decimals), // 2 decimal digits
      with: AssetBankModel.usd.symbol
    )

    // Then
    XCTAssertEqual(bitcoinString, "₿1,234,567,891.23456789")
    XCTAssertEqual(ethereumString, "Ξ 0.123456789123456789")
    XCTAssertEqual(dogecoinString, "∂1,234,567,891.23456789")
    XCTAssertEqual(usdString, "$1,234,567,891,234,567.89")
  }

  func testAmountFormatting_withGroupingSeparator() {
    // Given
    let price = BigDecimal(BigInt(200_032), AssetBankModel.usd.decimals)

    // When
    let currencyString = CybridCurrencyFormatter.formatPrice(price, with: AssetBankModel.usd.symbol)

    // Then
    XCTAssertEqual(currencyString, "$2,000.32")
  }

  func testAmountFormatting_withoutGroupingSeparator() {
    // Given
    let price = BigDecimal(BigInt(20_032), AssetBankModel.usd.decimals)

    // When
    let currencyString = CybridCurrencyFormatter.formatPrice(price, with: AssetBankModel.usd.symbol)

    // Then
    XCTAssertEqual(currencyString, "$200.32")
  }

  func testNegativeAmountFormatting() {
    // Given
    let price = BigDecimal(BigInt(-20_032), AssetBankModel.usd.decimals)

    // When
    let currencyString = CybridCurrencyFormatter.formatPrice(price, with: AssetBankModel.usd.symbol)

    // Then
    XCTAssertEqual(currencyString, "-$200.32")
  }

  func testZeroAmountFormatting() {
    // Given
    let price = BigInt(0)

    // When
    let bitcoinString = CybridCurrencyFormatter.formatPrice(
      BigDecimal(price, AssetBankModel.bitcoin.decimals),
      with: AssetBankModel.bitcoin.symbol
    )
    let ethereumString = CybridCurrencyFormatter.formatPrice(
      BigDecimal(price, AssetBankModel.ethereum.decimals),
      with: AssetBankModel.ethereum.symbol
    )
    let dogecoinString = CybridCurrencyFormatter.formatPrice(
      BigDecimal(price, AssetBankModel.dogecoin.decimals),
      with: AssetBankModel.dogecoin.symbol
    )
    let usdString = CybridCurrencyFormatter.formatPrice(
      BigDecimal(price, AssetBankModel.usd.decimals),
      with: AssetBankModel.usd.symbol
    )

    // Then
    XCTAssertEqual(bitcoinString, "₿0.00000000")
    XCTAssertEqual(ethereumString, "Ξ 0.000000000000000000")
    XCTAssertEqual(dogecoinString, "∂0.00000000")
    XCTAssertEqual(usdString, "$0.00")
  }

  func testAmountFormatting_withoutFractions() {
    // Given
    let jpy = AssetBankModel(type: .fiat, code: "JPY", name: "Japanes Yen", symbol: "¥", decimals: 0)
    let price = BigDecimal(BigInt(200_000), jpy.decimals)

    // When
    let currencyString = CybridCurrencyFormatter.formatPrice(price, with: jpy.symbol)

    // Then
    XCTAssertEqual(currencyString, "¥200,000")
  }
}

// MARK: - Formatter Configuration Tests

extension CurrencyFormatterTests {
  func testFormatter_withDefaultSeparatorsFallback() {
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

  func testFormatter_withLeadingLocalizedCurrencySymbol() {
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

  func testFormatter_withTrailingLocalizedCurrencySymbol() {
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
}

// MARK: - Formatting Edge Cases

extension CurrencyFormatterTests {
  func testMaxAmountFormatting() {
    // Given
    let price = BigDecimal(BigInt("123456789123456789123456789123"), AssetBankModel.ethereum.decimals)
    let shaNumber = BigDecimal(
      BigInt( "115792089237316195423570985008687907853269984665640564039457584007913129639935"),
      AssetBankModel.ethereum.decimals
    )

    // When
    let ethPrice = CybridCurrencyFormatter.formatPrice(price, with: AssetBankModel.ethereum.symbol)
    let ethShaNumber = CybridCurrencyFormatter.formatPrice(shaNumber, with: AssetBankModel.ethereum.symbol)

    // Then
    XCTAssertEqual(ethPrice, "Ξ 123,456,789,123.456789123456789123")
    XCTAssertEqual(ethShaNumber, "Ξ 115,792,089,237,316,195,423,570,985,008,687,907,853,269,984,665,640,564,039,457.584007913129639935")
  }

  func testNilAmountFormatting() {
    // Given
    let asset1 = AssetBankModel.usd
    let asset2 = AssetBankModel.ethereum
    let price = SymbolPriceBankModel(symbol: "$", buyPrice: nil, sellPrice: nil, buyPriceLastUpdatedAt: nil, sellPriceLastUpdatedAt: nil)

    // When
    let cryptoPriceModel = CryptoPriceModel(symbolPrice: price, asset: asset1, counterAsset: asset2)

    // Then
    XCTAssertEqual(cryptoPriceModel.formattedPrice, "Ξ 0.000000000000000000")
  }

  func testFormatter_withNilFormattedAmount() {
    // Given
    let formatter = MockNumberFormatter()
    formatter.setFixedFormattedNumber(nil)

    // When
    let formattedZero = CybridCurrencyFormatter.zeroCurrencyAmount(formatter: formatter)

    // Then
    XCTAssertEqual(formattedZero, "$0.00")
  }

  func testFormatter_withoutLocalizedCurrencySymbol() {
    // Given
    let locale = Locale(identifier: "fr_CAD")
    let currencySymbol = "$"
    let formatter = MockNumberFormatter()
    formatter.setFixedFormattedNumber("20.00")

    // When
    let localizedSymbol = CybridCurrencyFormatter.localizedCurrencySymbol(
      locale: locale,
      currencySymbol: currencySymbol,
      formatter: formatter
    )

    // Then - fallsback to default leading symbol
    XCTAssertEqual(localizedSymbol, .leading(symbol: "$"))
  }
}

// MARK: - Localized Currencies Tests
// swiftlint:disable identifier_name
extension CurrencyFormatterTests {
  func testAmountFormatting_toUSD_withMultipleLocales() {
    // Given
    let price = BigDecimal(BigInt(200_032), AssetBankModel.usd.decimals)

    // When
    let en_USFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: AssetBankModel.usd.symbol,
      locale: Locale(identifier: "en_US")
    )
    let en_CAFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: AssetBankModel.usd.symbol,
      locale: Locale(identifier: "en_CA")
    )
    let en_GBFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: AssetBankModel.usd.symbol,
      locale: Locale(identifier: "en_GB")
    )
    let fr_CAFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: AssetBankModel.usd.symbol,
      locale: Locale(identifier: "fr_CA")
    )
    let es_ESFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: AssetBankModel.usd.symbol,
      locale: Locale(identifier: "es_ES")
    )
    let es_MXFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: AssetBankModel.usd.symbol,
      locale: Locale(identifier: "es_MX")
    )
    let es_PEFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: AssetBankModel.usd.symbol,
      locale: Locale(identifier: "es_PE")
    )

    // Then
    XCTAssertEqual(en_USFormattedString, "$2,000.32")
    XCTAssertEqual(en_CAFormattedString, "$2,000.32")
    XCTAssertEqual(en_GBFormattedString, "$2,000.32")
    XCTAssertEqual(fr_CAFormattedString, "2 000,32 $")
    XCTAssertEqual(es_ESFormattedString, "2.000,32 $")
    XCTAssertEqual(es_MXFormattedString, "$2,000.32")
    XCTAssertEqual(es_PEFormattedString, "$ 2,000.32")
  }

  func testAmountFormatting_toGBP_withMultipleLocales() {
    // Given
    let pounds = AssetBankModel(type: .fiat, code: "GBP", name: "Pounds", symbol: "£", decimals: 2)
    let price = BigDecimal(BigInt(200_032), pounds.decimals)

    // When
    let en_USFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: pounds.symbol,
      locale: Locale(identifier: "en_US")
    )
    let en_CAFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: pounds.symbol,
      locale: Locale(identifier: "en_CA")
    )
    let en_GBFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: pounds.symbol,
      locale: Locale(identifier: "en_GB")
    )
    let fr_CAFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: pounds.symbol,
      locale: Locale(identifier: "fr_CA")
    )
    let es_ESFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: pounds.symbol,
      locale: Locale(identifier: "es_ES")
    )
    let es_MXFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: pounds.symbol,
      locale: Locale(identifier: "es_MX")
    )
    let es_PEFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: pounds.symbol,
      locale: Locale(identifier: "es_PE")
    )

    // Then
    XCTAssertEqual(en_USFormattedString, "£2,000.32")
    XCTAssertEqual(en_CAFormattedString, "£2,000.32")
    XCTAssertEqual(en_GBFormattedString, "£2,000.32")
    XCTAssertEqual(fr_CAFormattedString, "2 000,32 £")
    XCTAssertEqual(es_ESFormattedString, "2.000,32 £")
    XCTAssertEqual(es_MXFormattedString, "£2,000.32")
    XCTAssertEqual(es_PEFormattedString, "£ 2,000.32")
  }

  func testAmountFormatting_toEUR_withMultipleLocales() {
    // Given
    let price = BigDecimal(BigInt(200_032), AssetBankModel.eur.decimals)

    // When
    let en_USFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: AssetBankModel.eur.symbol,
      locale: Locale(identifier: "en_US")
    )
    let en_CAFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: AssetBankModel.eur.symbol,
      locale: Locale(identifier: "en_CA")
    )
    let en_GBFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: AssetBankModel.eur.symbol,
      locale: Locale(identifier: "en_GB")
    )
    let fr_CADFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: AssetBankModel.eur.symbol,
      locale: Locale(identifier: "fr_CA")
    )
    let es_ESFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: AssetBankModel.eur.symbol,
      locale: Locale(identifier: "es_ES")
    )
    let es_MXFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: AssetBankModel.eur.symbol,
      locale: Locale(identifier: "es_MX")
    )
    let es_PEFormattedString = CybridCurrencyFormatter.formatPrice(
      price,
      with: AssetBankModel.eur.symbol,
      locale: Locale(identifier: "es_PE")
    )

    // Then
    XCTAssertEqual(en_USFormattedString, "€2,000.32")
    XCTAssertEqual(en_CAFormattedString, "€2,000.32")
    XCTAssertEqual(en_GBFormattedString, "€2,000.32")
    XCTAssertEqual(fr_CADFormattedString, "2 000,32 €")
    XCTAssertEqual(es_ESFormattedString, "2.000,32 €")
    XCTAssertEqual(es_MXFormattedString, "€2,000.32")
    XCTAssertEqual(es_PEFormattedString, "€ 2,000.32")
  }
}
