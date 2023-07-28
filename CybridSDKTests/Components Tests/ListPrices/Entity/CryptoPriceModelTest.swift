//
//  CryptoPriceModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 09/02/23.
//

import Foundation
import BigInt
import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class CryptoPriceModelTest: XCTestCase {

    func test_init() {

        // -- Given
        let symbolPrice = SymbolPriceBankModel.btcUSD1
        let asset = AssetBankModel.bitcoin
        let counterAsset = AssetBankModel.usd

        // -- When
        let model = CryptoPriceModel(
            symbolPrice: symbolPrice,
            asset: asset,
            counterAsset: counterAsset)

        // -- Then
        XCTAssertEqual(model?.assetCode, "BTC")
        XCTAssertEqual(model?.assetName, "Bitcoin")
        XCTAssertEqual(model?.imageURL, "https://images.cybrid.xyz/sdk/assets/pdf/color/btc.pdf")
        XCTAssertEqual(model?.counterAssetCode, "USD")
        XCTAssertEqual(model?.formattedPrice, "$20,198.91")
    }

    func test_init_Nil() {

        // -- Given
        let symbolPrice = SymbolPriceBankModel.btcUsdBuyPriceNil
        let asset = AssetBankModel.bitcoin
        let counterAsset = AssetBankModel.usd

        // -- When
        let model = CryptoPriceModel(
            symbolPrice: symbolPrice,
            asset: asset,
            counterAsset: counterAsset)

        // -- Then
        XCTAssertNil(model)
    }

    func test_init_Undefined() {

        // -- Given
        let symbolPrice = SymbolPriceBankModel.btcUsdBuyPriceUndefined
        let asset = AssetBankModel.bitcoin
        let counterAsset = AssetBankModel.usd

        // -- When
        let model = CryptoPriceModel(
            symbolPrice: symbolPrice,
            asset: asset,
            counterAsset: counterAsset)

        // -- Then
        XCTAssertEqual(model?.assetCode, "BTC")
        XCTAssertEqual(model?.assetName, "Bitcoin")
        XCTAssertEqual(model?.imageURL, "https://images.cybrid.xyz/sdk/assets/pdf/color/btc.pdf")
        XCTAssertEqual(model?.counterAssetCode, "USD")
        XCTAssertEqual(model?.formattedPrice, "$0.00")
    }
}
