//
//  AssetPipeTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 28/09/22.
//

@testable import CybridSDK
import XCTest
import CybridApiBankSwift

class AssetPipeTest: XCTestCase {

    func test_transfrom_BigDecimal() {

        // -- Given
        let value = BigDecimal(10)
        let asset = AssetBankModel.bitcoin

        // -- when
        let result = AssetPipe.transform(value: value, asset: asset, unit: .trade)

        // -- Then
        XCTAssertEqual(result, BigDecimal("0.0000001"))
    }

    func test_transfrom_String_Trade() {

        // -- Given
        let value = "10"
        let asset = AssetBankModel.bitcoin

        // -- when
        let result = AssetPipe.transform(value: value, asset: asset, unit: .trade)

        // -- Then
        XCTAssertEqual(result, BigDecimal("0.0000001"))
    }

    func test_transfrom_String_Base() {

        // -- Given
        let value = "10"
        let asset = AssetBankModel.bitcoin

        // -- when
        let result = AssetPipe.transform(value: value, asset: asset, unit: .base)

        // -- Then
        XCTAssertEqual(result, BigDecimal("1000000000"))
    }

    func test_transfrom_BigDecimal_Trade_Deciamls() {

        // -- Given
        let value = BigDecimal(10)
        let decimals = AssetBankModel.bitcoin.decimals

        // -- when
        let result = AssetPipe.transform(value: value, decimals: decimals, unit: .trade)

        // -- Then
        XCTAssertEqual(result, BigDecimal("0.0000001"))
    }

    func test_transfrom_BigDecimal_Base_Deciamls() {

        // -- Given
        let value = BigDecimal(10)
        let decimals = AssetBankModel.bitcoin.decimals

        // -- when
        let result = AssetPipe.transform(value: value, decimals: decimals, unit: .base)

        // -- Then
        XCTAssertEqual(result, BigDecimal("1000000000"))
    }

    func test_transfrom_String_Trade_Deciamls() {

        // -- Given
        let value = "10"
        let decimals = AssetBankModel.bitcoin.decimals

        // -- when
        let result = AssetPipe.transform(value: value, decimals: decimals, unit: .trade)

        // -- Then
        XCTAssertEqual(result, BigDecimal("0.0000001"))
    }

    func test_transfrom_String_Base_Deciamls() {

        // -- Given
        let value = "10"
        let decimals = AssetBankModel.bitcoin.decimals

        // -- when
        let result = AssetPipe.transform(value: value, decimals: decimals, unit: .base)

        // -- Then
        XCTAssertEqual(result, BigDecimal("1000000000"))
    }

    func test_transfrom_SBigDecimal_Trade() {

        // -- Given
        let value = SBigDecimal(12345678912)
        let asset = AssetBankModel.bitcoin

        // -- when
        let result = AssetPipe.transform(value: value, asset: asset, unit: .trade)

        // -- Then
        XCTAssertEqual(result, "0.0000001")
    }
}
