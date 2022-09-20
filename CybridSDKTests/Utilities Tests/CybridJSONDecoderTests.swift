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
    XCTAssertNotNil(result)

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
    XCTAssertNotNil(result)

    let btc = result?.first

    XCTAssertEqual(btc?.symbol, "BTC-USD")
    XCTAssertEqual(btc?.buyPrice, "2387700")
    XCTAssertEqual(btc?.sellPrice, "2387600")
  }

  func test_AssetBankModel_defaultDecoder_fallback() throws {
    let listAssetsData = getJSONData(from: "listAssetsResponse")
    XCTAssertNotNil(listAssetsData)
    let decoder = CybridJSONDecoder()

    let result = try? decoder.decode(AssetListBankModel.self, from: listAssetsData!)
    XCTAssertNotNil(result)

    let cad = result?.objects.first

    XCTAssertEqual(cad?.code, "CAD")
    XCTAssertEqual(cad?.symbol, "$")
  }

  func test_AssetBankModel_decodingWrongType() throws {
    let listAssetsData = getJSONData(from: "listAssetsResponse")
    XCTAssertNotNil(listAssetsData)
    let decoder = CybridJSONDecoder()

    let result = try? decoder.decode(Array<SymbolPriceBankModel>.self, from: listAssetsData!)
    XCTAssertNil(result)
  }

  func test_SymbolPriceBankModel_LargestNumber_Decoding() throws {
    let listPricesData = getJSONData(from: "listLargestPricesResponse")
    XCTAssertNotNil(listPricesData)
    let decoder = CybridJSONDecoder()

    let result = try? decoder.decode(Array<SymbolPriceBankModel>.self, from: listPricesData!)
    XCTAssertNotNil(result)

    let model = result?.first

    XCTAssertEqual(model?.buyPrice, "115792089237316195423570985008687907853269984665640564039457584007913129639935")
    XCTAssertEqual(model?.sellPrice, "115792089237316195423570985008687907853269954665640564039457584007913129639935")
  }

  func test_SymbolPriceBankModel_withInvalidJSON() throws {
    let jsonDict: [String: Any] = [
      "symbol": "BTC-USD",
      "buy_price": 2_387_700,
      "sell_price": 2_387_600,
      "buy_price_last_updated_at": "2022-07-29T19:11:22.209Z",
      "sell_price_last_updated_at": "2022-07-29T19:11:22.209Z"
    ]
    let symbolPriceBankModel = SymbolPriceBankModel(json: jsonDict)

    XCTAssertNil(symbolPriceBankModel)
  }

  func test_QuoteBankModel_Decoding() throws {
    let quoteData = getJSONData(from: "createQuoteResponse")
    XCTAssertNotNil(quoteData)
    let decoder = CybridJSONDecoder()

    let result = try? decoder.decode(QuoteBankModel.self, from: quoteData!)
    XCTAssertNotNil(result?.guid)
    XCTAssertNotNil(result?.receiveAmount)
    XCTAssertNotNil(result?.deliverAmount)
  }

  func test_QuoteBankModel_withInvalidJSON() throws {
    let quoteData = getJSONData(from: "listAssetsResponse")
    XCTAssertNotNil(quoteData)
    let decoder = CybridJSONDecoder()

    let result = try? decoder.decode(QuoteBankModel.self, from: quoteData!)
    XCTAssertNil(result)
  }

  func test_QuoteBankModel_withInvalidArrayOfJSON() throws {
    let quoteData = getJSONData(from: "listPricesResponse")
    XCTAssertNotNil(quoteData)
    let decoder = CybridJSONDecoder()

    let result = try? decoder.decode(QuoteBankModel.self, from: quoteData!)
    XCTAssertNil(result)
  }

  func test_TradeBankModel_Decoding() throws {
    let tradeData = getJSONData(from: "createTradeResponse")
    XCTAssertNotNil(tradeData)
    let decoder = CybridJSONDecoder()

    let result = try? decoder.decode(TradeBankModel.self, from: tradeData!)
    XCTAssertNotNil(result?.guid)
    XCTAssertNotNil(result?.receiveAmount)
    XCTAssertNotNil(result?.deliverAmount)
  }

  func test_TradeBankModel_withInvalidJSON() throws {
    let tradeData = getJSONData(from: "listAssetsResponse")
    XCTAssertNotNil(tradeData)
    let decoder = CybridJSONDecoder()

    let result = try? decoder.decode(TradeBankModel.self, from: tradeData!)
    XCTAssertNil(result)
  }

  func test_TradeBankModel_withInvalidArrayOfJSON() throws {
    let tradeData = getJSONData(from: "listPricesResponse")
    XCTAssertNotNil(tradeData)
    let decoder = CybridJSONDecoder()

    let result = try? decoder.decode(TradeBankModel.self, from: tradeData!)
    XCTAssertNil(result)
  }
}
