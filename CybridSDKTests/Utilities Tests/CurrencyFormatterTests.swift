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
    let bitcoinString = CybridCurrencyFormatter.formatPrice(price, from: .usd, to: .bitcoin) // 8 decimal digits
    let ethereumString = CybridCurrencyFormatter.formatPrice(price, from: .usd, to: .ethereum) // 18 decimal digits
    let dogecoinString = CybridCurrencyFormatter.formatPrice(price, from: .usd, to: .dogecoin) // 8 decimal digits
    let usdString = CybridCurrencyFormatter.formatPrice(price, from: .bitcoin, to: .usd) // 2 decimal digits

    // Then
    XCTAssertEqual(bitcoinString, "₿1,234,567,891.23456789")
    XCTAssertEqual(ethereumString, "Ξ 0.123456789123456789")
    XCTAssertEqual(dogecoinString, "∂1,234,567,891.23456789")
    XCTAssertEqual(usdString, "$1,234,567,891,234,567.89")
  }

  func testAmountFormatting_withGroupingSeparator() {
    // Given
    let asset1 = AssetBankModel.bitcoin
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

  func testAmountFormatting_withoutGroupingSeparator() {
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

  func testZeroAmountFormatting() {
    // Given
    let price = BigInt(0)

    // When
    let bitcoinString = CybridCurrencyFormatter.formatPrice(price, from: .usd, to: .bitcoin)
    let ethereumString = CybridCurrencyFormatter.formatPrice(price, from: .usd, to: .ethereum)
    let dogecoinString = CybridCurrencyFormatter.formatPrice(price, from: .usd, to: .dogecoin)
    let usdString = CybridCurrencyFormatter.formatPrice(price, from: .bitcoin, to: .usd)

    // Then
    XCTAssertEqual(bitcoinString, "₿0.00000000")
    XCTAssertEqual(ethereumString, "Ξ 0.000000000000000000")
    XCTAssertEqual(dogecoinString, "∂0.00000000")
    XCTAssertEqual(usdString, "$0.00")
  }

  func testAmountFormatting_withoutFractions() {
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

  func testNilAmountFormatting() {
    // Given
    let asset1 = AssetBankModel.usd
    let asset2 = AssetBankModel.ethereum
    let price = SymbolPriceBankModel(symbol: "$", buyPrice: nil, sellPrice: nil, buyPriceLastUpdatedAt: nil, sellPriceLastUpdatedAt: nil)

    // When
    let cryptoPriceModel = CryptoPriceModel(symbolPrice: price, lhAsset: asset1, rhAsset: asset2)

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
    let localizedSymbol = CybridCurrencyFormatter.localizedCurrencySymbol(locale: locale,
                                                                          currencySymbol: currencySymbol,
                                                                          formatter: formatter)

    // Then - fallsback to default leading symbol
    XCTAssertEqual(localizedSymbol, .leading(symbol: "$"))
  }
}

// MARK: - Localized Currencies Tests
// swiftlint:disable identifier_name
extension CurrencyFormatterTests {
  func testAmountFormatting_toUSD_withMultipleLocales() {
    // Given
    let price = BigInt(200_032)

    // When
    let en_USFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: .usd, locale: Locale(identifier: "en_US"))
    let en_CAFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: .usd, locale: Locale(identifier: "en_CA"))
    let en_GBFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: .usd, locale: Locale(identifier: "en_GB"))
    let fr_CAFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: .usd, locale: Locale(identifier: "fr_CA"))
    let es_ESFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: .usd, locale: Locale(identifier: "es_ES"))
    let es_MXFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: .usd, locale: Locale(identifier: "es_MX"))
    let es_PEFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: .usd, locale: Locale(identifier: "es_PE"))

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
    let price = BigInt(200_032)

    // When
    let en_USFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: pounds, locale: Locale(identifier: "en_US"))
    let en_CAFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: pounds, locale: Locale(identifier: "en_CA"))
    let en_GBFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: pounds, locale: Locale(identifier: "en_GB"))
    let fr_CAFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: pounds, locale: Locale(identifier: "fr_CA"))
    let es_ESFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: pounds, locale: Locale(identifier: "es_ES"))
    let es_MXFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: pounds, locale: Locale(identifier: "es_MX"))
    let es_PEFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: pounds, locale: Locale(identifier: "es_PE"))

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
    let price = BigInt(200_032)

    // When
    let en_USFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: .eur, locale: Locale(identifier: "en_US"))
    let en_CAFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: .eur, locale: Locale(identifier: "en_CA"))
    let en_GBFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: .eur, locale: Locale(identifier: "en_GB"))
    let fr_CADFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: .eur, locale: Locale(identifier: "fr_CA"))
    let es_ESFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: .eur, locale: Locale(identifier: "es_ES"))
    let es_MXFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: .eur, locale: Locale(identifier: "es_MX"))
    let es_PEFormattedString = CybridCurrencyFormatter.formatPrice(price, from: .ethereum, to: .eur, locale: Locale(identifier: "es_PE"))

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
