//
//  CybridJSONDecoderTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 29/07/22.
//

import BigInt
@testable import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class CybridJSONDecoderTests: XCTestCase {

  func test_SymbolPriceBankModel_Decoding() throws {
    let listPricesData = getJSONData(from: "listPricesResponse")
    XCTAssertNotNil(listPricesData)
    let decoder = CybridJSONDecoder()

    let result = try? decoder.decode(Array<SymbolPriceBankModel>.self, from: listPricesData!)
    XCTAssertNotNil(listPricesData)

    result!.forEach { model in
      XCTAssertNotNil(model.symbol)
      XCTAssertNotNil(model.buyPrice)
      XCTAssertNotNil(model.sellPrice)
    }
  }

  func test_SymbolPriceBankModel_BTC_Decoding() throws {
    let listPricesData = getJSONData(from: "listPricesResponse")
    XCTAssertNotNil(listPricesData)
    let decoder = CybridJSONDecoder()

    let result = try? decoder.decode(Array<SymbolPriceBankModel>.self, from: listPricesData!)
    XCTAssertNotNil(listPricesData)

    let btc = result?.first

    XCTAssertEqual(btc?.symbol, "BTC-USD")
    XCTAssertEqual(btc?.buyPrice, BigInt("2387700"))
    XCTAssertEqual(btc?.sellPrice, BigInt("2387600"))
  }

  func test_SymbolPriceBankModel_LargestNumber_Decoding() throws {
    let listPricesData = getJSONData(from: "listLargestPricesResponse")
    XCTAssertNotNil(listPricesData)
    let decoder = CybridJSONDecoder()

    let result = try? decoder.decode(Array<SymbolPriceBankModel>.self, from: listPricesData!)
    XCTAssertNotNil(listPricesData)

    let model = result?.first

    XCTAssertEqual(model?.buyPrice, BigInt("115792089237316195423570985008687907853269984665640564039457584007913129639935"))
    XCTAssertEqual(model?.sellPrice, BigInt("115792089237316195423570985008687907853269954665640564039457584007913129639935"))
  }
}
