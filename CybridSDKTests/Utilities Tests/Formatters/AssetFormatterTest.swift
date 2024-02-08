//
//  AssetFormatterTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 28/03/23.
//
@testable import CybridSDK
import CybridApiBankSwift
import XCTest

class AssetFormatterTest: XCTestCase {

    // MARK: USD Test

    func test_forInput_0_5_USD_to_50() {

        // -- Given
        let fiatAmount = CDecimal("0.5")
        let asset = AssetBankModel.usd
        let result = "50"

        // -- When
        let formatted = AssetFormatter.forInput(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forInput_1_USD_to_100() {

        // -- Given
        let fiatAmount = CDecimal("1")
        let asset = AssetBankModel.usd
        let result = "100"

        // -- When
        let formatted = AssetFormatter.forInput(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forInput_1_5_USD_to_150() {

        // -- Given
        let fiatAmount = CDecimal("1.5")
        let asset = AssetBankModel.usd
        let result = "150"

        // -- When
        let formatted = AssetFormatter.forInput(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forInput_10_USD_to_1000() {

        // -- Given
        let fiatAmount = CDecimal("10")
        let asset = AssetBankModel.usd
        let result = "1000"

        // -- When
        let formatted = AssetFormatter.forInput(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forInput_10_5_USD_to_1050() {

        // -- Given
        let fiatAmount = CDecimal("10.5")
        let asset = AssetBankModel.usd
        let result = "1050"

        // -- When
        let formatted = AssetFormatter.forInput(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forInput_123456_7_USD_to_12345670() {

        // -- Given
        let fiatAmount = CDecimal("123456.7")
        let asset = AssetBankModel.usd
        let result = "12345670"

        // -- When
        let formatted = AssetFormatter.forInput(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_100__1_USD() {

        // -- Given
        let amountToConvert = CDecimal("100")
        let asset = AssetBankModel.usd
        let result = "1.00"

        // -- When
        let formatted = AssetFormatter.forBase(asset, amount: amountToConvert)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_150__1_50_USD() {

        // -- Given
        let amountToConvert = CDecimal("150")
        let asset = AssetBankModel.usd
        let result = "1.50"

        // -- When
        let formatted = AssetFormatter.forBase(asset, amount: amountToConvert)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_1000__10_00_USD() {

        // -- Given
        let amountToConvert = CDecimal("1000")
        let asset = AssetBankModel.usd
        let result = "10.00"

        // -- When
        let formatted = AssetFormatter.forBase(asset, amount: amountToConvert)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_1050__10_50_USD() {

        // -- Given
        let amountToConvert = CDecimal("1050")
        let asset = AssetBankModel.usd
        let result = "10.50"

        // -- When
        let formatted = AssetFormatter.forBase(asset, amount: amountToConvert)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_12345670__123456_70_USD() {

        // -- Given
        let amountToConvert = CDecimal("12345670")
        let asset = AssetBankModel.usd
        let result = "123456.70"

        // -- When
        let formatted = AssetFormatter.forBase(asset, amount: amountToConvert)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    // MARK: BTC Test

    func test_forInput_1_to_100000000_BTC() {

        // -- Given
        let fiatAmount = CDecimal("1.00")
        let asset = AssetBankModel.bitcoin
        let result = "100000000"

        // -- When
        let formatted = AssetFormatter.forInput(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_maximunNumber_BTC() {

        // -- Given
        let amountToConvert = CDecimal("115792089237316195423570985008687907853269984665640564039457584007913129639935")
        let asset = AssetBankModel.bitcoin
        let result = "1157920892373161954235709850086879078532699846656405640394575840079131.29639935"

        // -- When
        let formatted = AssetFormatter.forBase(asset, amount: amountToConvert)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    // MARK: ETH Test

    func test_forInput_0_0642180900000_to_64218090000000000_ETH() {

        // -- Given
        let fiatAmount = CDecimal("0.0642180900000")
        let asset = AssetBankModel.ethereum
        let result = "64218090000000000"

        // -- When
        let formatted = AssetFormatter.forInput(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forInput_0_064218090000000000000000_to_64218090000000000_ETH() {

        // -- Given
        let fiatAmount = CDecimal("0.064218090000000000000000")
        let asset = AssetBankModel.ethereum
        let result = "64218090000000000"

        // -- When
        let formatted = AssetFormatter.forInput(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_0_064218090000000000_to_64218090000000000_ETH() {

        // -- Given
        let fiatAmount = CDecimal("0.064218090000000000")
        let asset = AssetBankModel.ethereum
        let result = "64218090000000000"

        // -- When
        let formatted = AssetFormatter.forInput(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_0_642180900000000000_to_642180900000000000_ETH() {

        // -- Given
        let fiatAmount = CDecimal("0.642180900000000000")
        let asset = AssetBankModel.ethereum
        let result = "642180900000000000"

        // -- When
        let formatted = AssetFormatter.forInput(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_6_421809000000000000_to_6421809000000000000_ETH() {

        // -- Given
        let fiatAmount = CDecimal("6.421809000000000000")
        let asset = AssetBankModel.ethereum
        let result = "6421809000000000000"

        // -- When
        let formatted = AssetFormatter.forInput(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_64_218090000000000000_to_64218090000000000000_ETH() {

        // -- Given
        let fiatAmount = CDecimal("64.218090000000000000")
        let asset = AssetBankModel.ethereum
        let result = "64218090000000000000"

        // -- When
        let formatted = AssetFormatter.forInput(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_64218090000000000__0_064218090000000000_ETH() {

        // -- Given
        let amountToConvert = CDecimal("64218090000000000")
        let asset = AssetBankModel.ethereum
        let result = "0.064218090000000000"

        // -- When
        let formatted = AssetFormatter.forBase(asset, amount: amountToConvert)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_642180900000000000__0_642180900000000000_ETH() {

        // -- Given
        let amountToConvert = CDecimal("642180900000000000")
        let asset = AssetBankModel.ethereum
        let result = "0.642180900000000000"

        // -- When
        let formatted = AssetFormatter.forBase(asset, amount: amountToConvert)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_6421809000000000000__6_421809000000000000_ETH() {

        // -- Given
        let amountToConvert = CDecimal("6421809000000000000")
        let asset = AssetBankModel.ethereum
        let result = "6.421809000000000000"

        // -- When
        let formatted = AssetFormatter.forBase(asset, amount: amountToConvert)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_64218090000000000000__64_218090000000000000_ETH() {

        // -- Given
        let amountToConvert = CDecimal("64218090000000000000")
        let asset = AssetBankModel.ethereum
        let result = "64.218090000000000000"

        // -- When
        let formatted = AssetFormatter.forBase(asset, amount: amountToConvert)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_mediumNumber_9007199254740991_BTC() {

        // -- Given
        let amountToConvert = CDecimal("9007199254740991")
        let asset = AssetBankModel.bitcoin
        let result = "90071992.54740991"

        // -- When
        let formatted = AssetFormatter.forBase(asset, amount: amountToConvert)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_mediumNumber_9007199254740991_ETH() {

        // -- Given
        let amountToConvert = CDecimal("9007199254740991")
        let asset = AssetBankModel.ethereum
        let result = "0.009007199254740991"

        // -- When
        let formatted = AssetFormatter.forBase(asset, amount: amountToConvert)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_maximunNumber_ETH() {

        // -- Given
        let amountToConvert = CDecimal("115792089237316195423570985008687907853269984665640564039457584007913129639935")
        let asset = AssetBankModel.ethereum
        let result = "115792089237316195423570985008687907853269984665640564039457.584007913129639935"

        // -- When
        let formatted = AssetFormatter.forBase(asset, amount: amountToConvert)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    // MARK: Format test

    func test_format__10_00__10_00_USD() {

        // -- Given
        let amountToFormat = "10.00"
        let asset = AssetBankModel.usd
        let resultToCheck = "$10.00 USD"

        // -- When
        let result = AssetFormatter.format(asset, amount: amountToFormat)

        // -- Then
        XCTAssertEqual(result, resultToCheck)
    }

    func test_format__10_00__10_00_CAD() {

        // -- Given
        let amountToFormat = "10.00"
        let asset = AssetBankModel.cad
        let resultToCheck = "$10.00 CAD"

        // -- When
        let result = AssetFormatter.format(asset, amount: amountToFormat)

        // -- Then
        XCTAssertEqual(result, resultToCheck)
    }

    func test_format_mediumNumber_BTC() {

        // -- Given
        let amountToFormat = "90071992.54740991"
        let asset = AssetBankModel.bitcoin
        let resultToCheck = "₿90,071,992.54740991"

        // -- When
        let result = AssetFormatter.format(asset, amount: amountToFormat)

        // -- Then
        XCTAssertEqual(result, resultToCheck)
    }

    func test_format_maximunNumber_BTC() {

        // -- Given
        let amountToFormat = "1157920892373161954235709850086879078532699846656405640394575840079131.29639935"
        let asset = AssetBankModel.bitcoin
        let resultToCheck = "₿1,157,920,892,373,161,954,235,709,850,086,879,078,532,699,846,656,405,640,394,575,840,079,131.29639935"

        // -- When
        let result = AssetFormatter.format(asset, amount: amountToFormat)

        // -- Then
        XCTAssertEqual(result, resultToCheck)
    }

    func test_format_maximunNumber_ETH() {

        // -- Given
        let amountToFormat = "115792089237316195423570985008687907853269984665640564039457.584007913129639935"
        let asset = AssetBankModel.ethereum
        let resultToCheck = "Ξ115,792,089,237,316,195,423,570,985,008,687,907,853,269,984,665,640,564,039,457.584007913129639935"

        // -- When
        let result = AssetFormatter.format(asset, amount: amountToFormat)

        // -- Then
        XCTAssertEqual(result, resultToCheck)
    }

    // MARK: Trade

    func test_trade_0_5_BTC_to_USD() {

        // -- Given
        let amount = CDecimal("0.5")
        let amountFormatted = AssetFormatter.forInput(AssetBankModel.bitcoin, amount: amount)
        let asset = AssetBankModel.bitcoin
        let price = SymbolPriceBankModel.btcUSD1

        // -- When
        let tradeValue = AssetFormatter.trade(
            amount: amountFormatted,
            cryptoAsset: asset,
            price: price.buyPrice!,
            base: "crypto")
        let tradeValueCDecimal = CDecimal(tradeValue)
        let tradeBase = AssetFormatter.forBase(AssetBankModel.usd, amount: tradeValueCDecimal)
        let tradeFormatted = AssetFormatter.format(AssetBankModel.usd, amount: tradeBase)

        // -- Then
        XCTAssertEqual(tradeValue, "1009945")
        XCTAssertEqual(tradeBase, "10099.45")
        XCTAssertEqual(tradeFormatted, "$10,099.45 USD")

    }

    func test_trade_1_BTC_to_USD() {

        // -- Given
        let amount = CDecimal("1")
        let amountFormatted = AssetFormatter.forInput(AssetBankModel.bitcoin, amount: amount)
        let asset = AssetBankModel.bitcoin
        let price = SymbolPriceBankModel.btcUSD1

        // -- When
        let tradeValue = AssetFormatter.trade(
            amount: amountFormatted,
            cryptoAsset: asset,
            price: price.buyPrice!,
            base: "crypto")
        let tradeValueCDecimal = CDecimal(tradeValue)
        let tradeBase = AssetFormatter.forBase(AssetBankModel.usd, amount: tradeValueCDecimal)
        let tradeFormatted = AssetFormatter.format(AssetBankModel.usd, amount: tradeBase)

        // -- Then
        XCTAssertEqual(tradeValue, "2019891")
        XCTAssertEqual(tradeBase, "20198.91")
        XCTAssertEqual(tradeFormatted, "$20,198.91 USD")
    }

    func test_trade_0_00495076_BTC_to_USD() {

        // -- Given
        let amount = CDecimal("0.00495076")
        let amountFormatted = AssetFormatter.forInput(AssetBankModel.bitcoin, amount: amount)
        let asset = AssetBankModel.bitcoin
        let price = SymbolPriceBankModel.btcUSD1

        // -- When
        let tradeValue = AssetFormatter.trade(
            amount: amountFormatted,
            cryptoAsset: asset,
            price: price.buyPrice!,
            base: "crypto")
        let tradeValueCDecimal = CDecimal(tradeValue)
        let tradeBase = AssetFormatter.forBase(AssetBankModel.usd, amount: tradeValueCDecimal)
        let tradeFormatted = AssetFormatter.format(AssetBankModel.usd, amount: tradeBase)

        // -- Then
        XCTAssertEqual(tradeValue, "9999")
        XCTAssertEqual(tradeBase, "99.99")
        XCTAssertEqual(tradeFormatted, "$99.99 USD")
    }

    func test_trade_100_USD_to_BTC() {

        // -- Given
        let amount = CDecimal("100")
        let amountFormatted = AssetFormatter.forInput(AssetBankModel.usd, amount: amount)
        let asset = AssetBankModel.bitcoin
        let price = SymbolPriceBankModel.btcUSD1

        // -- When
        let tradeValue = AssetFormatter.trade(
            amount: amountFormatted,
            cryptoAsset: asset,
            price: price.buyPrice!,
            base: "fiat")
        let tradeValueCDecimal = CDecimal(tradeValue)
        let tradeBase = AssetFormatter.forBase(AssetBankModel.bitcoin, amount: tradeValueCDecimal)
        let tradeFormatted = AssetFormatter.format(AssetBankModel.bitcoin, amount: tradeBase)

        // -- Then
        XCTAssertEqual(tradeValue, "495076")
        XCTAssertEqual(tradeBase, "0.00495076")
        XCTAssertEqual(tradeFormatted, "₿0.00495076")
    }
}
