//
//  TradeTypeTests.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 01/11/23.
//

import XCTest
@testable import CybridSDK

class TradeTypeTests: XCTestCase {

    func testLocalizationKeyForBuy() {
        let tradeType = TradeType.buy
        XCTAssertEqual(tradeType.localizationKey, CybridLocalizationKey.trade(.buy(.title)))
    }

    func testLocalizationKeyForSell() {
        let tradeType = TradeType.sell
        XCTAssertEqual(tradeType.localizationKey, CybridLocalizationKey.trade(.sell(.title)))
    }

    func testSideBankModelForBuy() {
        let tradeType = TradeType.buy
        XCTAssertEqual(tradeType.sideBankModel, "buy")
    }

    func testSideBankModelForSell() {
        let tradeType = TradeType.sell
        XCTAssertEqual(tradeType.sideBankModel, "sell")
    }
}
