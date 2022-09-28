//
//  TradeUIModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 28/09/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class TradeUIModelTest: XCTestCase {

    func test_init_fee_empty() {

        // -- Given
        let trade = TradeBankModel(
            guid: "GUID",
            customerGuid: "CUSTOMER_GUID",
            quoteGuid: "QUOTE_GUID",
            symbol: "ETH-USD",
            side: .buy,
            state: .completed,
            receiveAmount: "100000000000000000",
            deliverAmount: "13390",
            createdAt: Date())
        let model = TradeUIModel(
            tradeBankModel: trade,
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            accountGuid: "")

        // -- Then
        XCTAssertEqual(model?.feeValue, SBigDecimal("0"))
    }

    func test_init_fee_no_number() {

        // -- Given
        let trade = TradeBankModel(
            guid: "GUID",
            customerGuid: "CUSTOMER_GUID",
            quoteGuid: "QUOTE_GUID",
            symbol: "ETH-USD",
            side: .buy,
            state: .completed,
            receiveAmount: "100000000000000000",
            deliverAmount: "13390",
            fee: "NaN",
            createdAt: Date())
        let model = TradeUIModel(
            tradeBankModel: trade,
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            accountGuid: "")

        // -- Then
        XCTAssertEqual(model?.feeValue, SBigDecimal("0"))
    }

    func test_getTradeAmount_Sell() {

        // -- Given
        let trade = TradeBankModel(
            guid: "GUID",
            customerGuid: "CUSTOMER_GUID",
            quoteGuid: "QUOTE_GUID",
            symbol: "ETH-USD",
            side: .sell,
            state: .completed,
            receiveAmount: "100000000000000000",
            deliverAmount: "13390",
            fee: "0",
            createdAt: Date())
        let model = TradeUIModel(
            tradeBankModel: trade,
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            accountGuid: "")

        // -- When
        let resutlt = model?.getTradeAmount()

        // -- Then
        XCTAssertEqual(resutlt, "0.1339")
    }

    func test_getTradeAmount_Sell_Zero() {

        // -- Given
        let trade = TradeBankModel(
            guid: "GUID",
            customerGuid: "CUSTOMER_GUID",
            quoteGuid: "QUOTE_GUID",
            symbol: "ETH-USD",
            side: .sell,
            state: .completed,
            receiveAmount: "100000000000000000",
            fee: "0",
            createdAt: Date())
        let model = TradeUIModel(
            tradeBankModel: trade,
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            accountGuid: "")

        // -- When
        let resutlt = model?.getTradeAmount()

        // -- Then
        XCTAssertEqual(resutlt, "0.")
    }

    func test_getTradeAmount_Buy_Zero() {

        // -- Given
        let trade = TradeBankModel(
            guid: "GUID",
            customerGuid: "CUSTOMER_GUID",
            quoteGuid: "QUOTE_GUID",
            symbol: "ETH-USD",
            side: .buy,
            state: .completed,
            deliverAmount: "100000000000000000",
            fee: "0",
            createdAt: Date())
        let model = TradeUIModel(
            tradeBankModel: trade,
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            accountGuid: "")

        // -- When
        let resutlt = model?.getTradeAmount()

        // -- Then
        XCTAssertEqual(resutlt, "0.")
    }

    func test_getTradeFiatAmount_Sell() {

        // -- Given
        let trade = TradeBankModel(
            guid: "GUID",
            customerGuid: "CUSTOMER_GUID",
            quoteGuid: "QUOTE_GUID",
            symbol: "ETH-USD",
            side: .sell,
            state: .completed,
            receiveAmount: "100000000000000000",
            deliverAmount: "13390",
            fee: "0",
            createdAt: Date())
        let model = TradeUIModel(
            tradeBankModel: trade,
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            accountGuid: "")

        // -- When
        let resutlt = model?.getTradeFiatAmount()

        // -- Then
        XCTAssertEqual(resutlt, "$1,000,000,000,000,000.00")
    }

    func test_getTradeFiatAmount_Sell_Zero() {

        // -- Given
        let trade = TradeBankModel(
            guid: "GUID",
            customerGuid: "CUSTOMER_GUID",
            quoteGuid: "QUOTE_GUID",
            symbol: "ETH-USD",
            side: .sell,
            state: .completed,
            deliverAmount: "13390",
            fee: "0",
            createdAt: Date())
        let model = TradeUIModel(
            tradeBankModel: trade,
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            accountGuid: "")

        // -- When
        let resutlt = model?.getTradeFiatAmount()

        // -- Then
        XCTAssertEqual(resutlt, "$0.00")
    }

    func test_getTradeFiatAmount_Sell_NaN() {

        // -- Given
        let trade = TradeBankModel(
            guid: "GUID",
            customerGuid: "CUSTOMER_GUID",
            quoteGuid: "QUOTE_GUID",
            symbol: "ETH-USD",
            side: .sell,
            state: .completed,
            receiveAmount: "NaN",
            deliverAmount: "13390",
            fee: "0",
            createdAt: Date())
        let model = TradeUIModel(
            tradeBankModel: trade,
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            accountGuid: "")

        // -- When
        let resutlt = model?.getTradeFiatAmount()

        // -- Then
        XCTAssertEqual(resutlt, "$0.00")
    }

    func test_getTradeFiatAmount_Buy_Zero() {

        // -- Given
        let trade = TradeBankModel(
            guid: "GUID",
            customerGuid: "CUSTOMER_GUID",
            quoteGuid: "QUOTE_GUID",
            symbol: "ETH-USD",
            side: .buy,
            state: .completed,
            receiveAmount: "100000000000000000",
            fee: "0",
            createdAt: Date())
        let model = TradeUIModel(
            tradeBankModel: trade,
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            accountGuid: "")

        // -- When
        let resutlt = model?.getTradeFiatAmount()

        // -- Then
        XCTAssertEqual(resutlt, "$0.00")
    }

    func test_getTradeFiatAmount_Buy_NaN() {

        // -- Given
        let trade = TradeBankModel(
            guid: "GUID",
            customerGuid: "CUSTOMER_GUID",
            quoteGuid: "QUOTE_GUID",
            symbol: "ETH-USD",
            side: .buy,
            state: .completed,
            deliverAmount: "NaN",
            fee: "0",
            createdAt: Date())
        let model = TradeUIModel(
            tradeBankModel: trade,
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            accountGuid: "")

        // -- When
        let resutlt = model?.getTradeFiatAmount()

        // -- Then
        XCTAssertEqual(resutlt, "$0.00")
    }
}
