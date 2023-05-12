//
//  AccountAssetPriceModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 09/03/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class BalanceUIModelTest: XCTestCase {

    func test_init_with_emptys() {

        // -- Given
        let account = AccountBankModel(
            type: AccountBankModel.TypeBankModel.fiat,
            guid: "1234",
            createdAt: nil,
            asset: "USD-BTC",
            name: "USD Bit",
            bankGuid: "1234",
            customerGuid: "1234",
            platformBalance: nil,
            platformAvailable: nil,
            state: AccountBankModel.StateBankModel.storing
        )

        let price = SymbolPriceBankModel(
            symbol: "USD-BTC",
            buyPrice: nil,
            sellPrice: nil,
            buyPriceLastUpdatedAt: nil,
            sellPriceLastUpdatedAt: nil
        )

        // -- When
        let balance = BalanceUIModel(
            account: account,
            asset: AssetBankModel.usd,
            counterAsset: AssetBankModel.bitcoin,
            price: price)

        // -- Then
        XCTAssertEqual(balance.accountBalance.value, BigDecimal(0).value)
        XCTAssertEqual(balance.accountAvailable.value, BigDecimal(0).value)
        XCTAssertEqual(balance.buyPriceFormatted, "₿0.00000000")
    }

    func test_init_with_undefined() {

        // -- Given
        let account = AccountBankModel(
            type: AccountBankModel.TypeBankModel.fiat,
            guid: "1234",
            createdAt: nil,
            asset: nil,
            name: "USD Bit",
            bankGuid: "1234",
            customerGuid: "1234",
            platformBalance: "cybrid",
            platformAvailable: "cybrid",
            state: AccountBankModel.StateBankModel.storing
        )

        let price = SymbolPriceBankModel(
            symbol: "USD-BTC",
            buyPrice: "cybrid",
            sellPrice: "cybrid",
            buyPriceLastUpdatedAt: nil,
            sellPriceLastUpdatedAt: nil
        )

        // -- When
        let balance = BalanceUIModel(
            account: account,
            asset: AssetBankModel.usd,
            counterAsset: AssetBankModel.bitcoin,
            price: price)

        // -- Then
        XCTAssertEqual(balance.accountBalance.value, BigDecimal(0).value)
        XCTAssertEqual(balance.accountAvailable.value, BigDecimal(0).value)
        XCTAssertEqual(balance.buyPriceFormatted, "₿0.00")
        XCTAssertEqual(balance.accountAssetURL, "https://images.cybrid.xyz/sdk/assets/pdf/color/.pdf")
    }
}
