//
//  AccountAssetUIModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 10/02/23.
//

import Foundation
import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class AccountAssetUIModelTest: XCTestCase {

    func test_init_trading() {

        // -- Given
        let account = AccountBankModel.trading
        let asset = AssetBankModel.bitcoin

        // -- When
        let model = AccountAssetUIModel(account: account, asset: asset)

        // -- Then
        XCTAssertEqual(model.account, account)
        XCTAssertEqual(model.asset, asset)
        XCTAssertEqual(model.balanceFormatted, "2.0")
        XCTAssertEqual(model.assetURL, "https://images.cybrid.xyz/sdk/assets/pdf/color/btc.pdf")
    }

    func test_init_fiat() {

        // -- Given
        let account = AccountBankModel.fiat
        let asset = AssetBankModel.usd

        // -- When
        let model = AccountAssetUIModel(account: account, asset: asset)

        // -- Then
        XCTAssertEqual(model.account, account)
        XCTAssertEqual(model.asset, asset)
        XCTAssertEqual(model.balanceFormatted, "$20,000,000.00")
        XCTAssertEqual(model.assetURL, "https://images.cybrid.xyz/sdk/assets/pdf/color/usd.pdf")
    }

    func test_init_trading_balance_nil() {

        // -- Given
        let account = AccountBankModel.tradingBalanceNil
        let asset = AssetBankModel.bitcoin

        // -- When
        let model = AccountAssetUIModel(account: account, asset: asset)

        // -- Then
        XCTAssertEqual(model.account, account)
        XCTAssertEqual(model.asset, asset)
        XCTAssertEqual(model.balanceFormatted, "0.0")
        XCTAssertEqual(model.assetURL, "https://images.cybrid.xyz/sdk/assets/pdf/color/btc.pdf")
    }

    func test_init_fiat_balance_nil() {

        // -- Given
        let account = AccountBankModel.fiatBalanceNil
        let asset = AssetBankModel.usd

        // -- When
        let model = AccountAssetUIModel(account: account, asset: asset)

        // -- Then
        XCTAssertEqual(model.account, account)
        XCTAssertEqual(model.asset, asset)
        XCTAssertEqual(model.balanceFormatted, "$0.00")
        XCTAssertEqual(model.assetURL, "https://images.cybrid.xyz/sdk/assets/pdf/color/usd.pdf")
    }

    func test_init_trading_balance_undefined() {

        // -- Given
        let account = AccountBankModel.tradingBalanceUndefined
        let asset = AssetBankModel.bitcoin

        // -- When
        let model = AccountAssetUIModel(account: account, asset: asset)

        // -- Then
        XCTAssertEqual(model.account, account)
        XCTAssertEqual(model.asset, asset)
        XCTAssertEqual(model.balanceFormatted, "0.0")
        XCTAssertEqual(model.assetURL, "https://images.cybrid.xyz/sdk/assets/pdf/color/btc.pdf")
    }

    func test_init_fiat_balance_undefined() {

        // -- Given
        let account = AccountBankModel.fiatBalanceUndefined
        let asset = AssetBankModel.usd

        // -- When
        let model = AccountAssetUIModel(account: account, asset: asset)

        // -- Then
        XCTAssertEqual(model.account, account)
        XCTAssertEqual(model.asset, asset)
        XCTAssertEqual(model.balanceFormatted, "$0.00")
        XCTAssertEqual(model.assetURL, "https://images.cybrid.xyz/sdk/assets/pdf/color/usd.pdf")
    }
}
