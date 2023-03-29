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

    func test_forTrade_1_USD_to_100() {

        // -- Given
        let fiatAmount = CDecimal("1")
        let asset = AssetBankModel.usd
        let result = "100"

        // -- When
        let formatted = AssetFormatter.forTrade(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forTrade_1_5_USD_to_150() {

        // -- Given
        let fiatAmount = CDecimal("1.5")
        let asset = AssetBankModel.usd
        let result = "150"

        // -- When
        let formatted = AssetFormatter.forTrade(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forTrade_10_USD_to_1000() {

        // -- Given
        let fiatAmount = CDecimal("10")
        let asset = AssetBankModel.usd
        let result = "1000"

        // -- When
        let formatted = AssetFormatter.forTrade(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forTrade_10_5_USD_to_1050() {

        // -- Given
        let fiatAmount = CDecimal("10.5")
        let asset = AssetBankModel.usd
        let result = "1050"

        // -- When
        let formatted = AssetFormatter.forTrade(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forTrade_123456_7_USD_to_12345670() {

        // -- Given
        let fiatAmount = CDecimal("123456.7")
        let asset = AssetBankModel.usd
        let result = "12345670"

        // -- When
        let formatted = AssetFormatter.forTrade(asset, amount: fiatAmount)

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

    // MARK: ETH Test

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

    func test_forBase_6421809000000000000__6_421809000000009000_ETH() {

        // -- Given
        let amountToConvert = CDecimal("6421809000000000000")
        let asset = AssetBankModel.ethereum
        let result = "6.421809000000000000"

        // -- When
        let formatted = AssetFormatter.forBase(asset, amount: amountToConvert)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_forBase_64218090000000000000__64_218090000000090000_ETH() {

        // -- Given
        let amountToConvert = CDecimal("64218090000000000000")
        let asset = AssetBankModel.ethereum
        let result = "64.218090000000000000"

        // -- When
        let formatted = AssetFormatter.forBase(asset, amount: amountToConvert)

        // -- Then
        XCTAssertEqual(formatted, result)
    }
}
