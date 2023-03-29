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

    func test_setForTrade_1_to_100_USD() {

        // -- Given
        let fiatAmount = CDecimal("1")
        let asset = AssetBankModel.usd
        let result = "100"

        // -- When
        let formatted = AssetFormatter.forTrade(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_setForTrade_1_5_to_150_USD() {

        // -- Given
        let fiatAmount = CDecimal("1.5")
        let asset = AssetBankModel.usd
        let result = "150"

        // -- When
        let formatted = AssetFormatter.forTrade(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_setForTrade_10_to_1000_USD() {

        // -- Given
        let fiatAmount = CDecimal("10")
        let asset = AssetBankModel.usd
        let result = "1000"

        // -- When
        let formatted = AssetFormatter.forTrade(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }

    func test_setForTrade_10_5_to_1050_USD() {

        // -- Given
        let fiatAmount = CDecimal("10.5")
        let asset = AssetBankModel.usd
        let result = "1050"

        // -- When
        let formatted = AssetFormatter.forTrade(asset, amount: fiatAmount)

        // -- Then
        XCTAssertEqual(formatted, result)
    }
}
