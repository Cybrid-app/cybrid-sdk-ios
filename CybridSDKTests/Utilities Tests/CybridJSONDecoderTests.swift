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

    func test_QuoteBankModel_Decoding() throws {

        let quoteData = getJSONData(from: "createQuoteResponse")
        XCTAssertNotNil(quoteData)
        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(QuoteBankModel.self, from: quoteData!)
        XCTAssertNotNil(result?.guid)
        XCTAssertNotNil(result?.receiveAmount)
        XCTAssertNotNil(result?.deliverAmount)
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

    func test_TradesBankModel_Decoding() throws {

        let tradeData = getJSONData(from: "listTradesResponse")
        XCTAssertNotNil(tradeData)
        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(TradeListBankModel.self, from: tradeData!)
        XCTAssertNotNil(result?.total)
        XCTAssertNotNil(result?.page)
        XCTAssertNotNil(result?.perPage)
        XCTAssertNotNil(result?.objects)
        XCTAssertNotNil(result?.objects[0])
        XCTAssertNotNil(result?.objects[0].guid)
        XCTAssertNotNil(result?.objects[0].customerGuid)
        XCTAssertNotNil(result?.objects[0].quoteGuid)
        XCTAssertNotNil(result?.objects[0].symbol)
        XCTAssertNotNil(result?.objects[0].side)
        XCTAssertNotNil(result?.objects[0].state)
        XCTAssertNotNil(result?.objects[0].receiveAmount)
        XCTAssertNotNil(result?.objects[0].deliverAmount)
        XCTAssertNotNil(result?.objects[0].fee)
        XCTAssertNotNil(result?.objects[0].createdAt)
    }

    func test_TradesBankModel_Decoding_Default() throws {

        let tradeData = getJSONData(from: "listTradesResponseIncomplete")
        XCTAssertNotNil(tradeData)

        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(TradeListBankModel.self, from: tradeData!)
        XCTAssertNotNil(result?.total)
        XCTAssertEqual(result?.total, 0)
        XCTAssertNotNil(result?.page)
        XCTAssertEqual(result?.page, 0)
        XCTAssertNotNil(result?.perPage)
        XCTAssertEqual(result?.perPage, 0)
        XCTAssertNotNil(result?.objects)
    }

    func test_TradesBankModel_withInvalidJSON() throws {

        let tradeData = getJSONData(from: "listPricesResponse")
        XCTAssertNotNil(tradeData)
        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(TradeListBankModel.self, from: tradeData!)
        XCTAssertNil(result)
    }

    func test_TradesBankModel_withInvalidArrayOfJSON() throws {

        let tradeData = getJSONData(from: "listPricesResponse")
        XCTAssertNotNil(tradeData)
        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(TradeListBankModel.self, from: tradeData!)
        XCTAssertNil(result)
    }

    func test_AccountBankModel_Decoding() throws {

        let tradeData = getJSONData(from: "accountResponse")
        XCTAssertNotNil(tradeData)

        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(AccountListBankModel.self, from: tradeData!)
        XCTAssertNotNil(result?.total)
        XCTAssertEqual(result?.total, 1)
        XCTAssertNotNil(result?.page)
        XCTAssertEqual(result?.page, 1)
        XCTAssertNotNil(result?.perPage)
        XCTAssertEqual(result?.perPage, 0)
        XCTAssertNotNil(result?.objects)
        XCTAssertNotNil(result?.objects[0])
        XCTAssertNotNil(result?.objects[0].type)
        XCTAssertNotNil(result?.objects[0].guid)
        XCTAssertNotNil(result?.objects[0].asset)
        XCTAssertNotNil(result?.objects[0].name)
        XCTAssertNotNil(result?.objects[0].platformBalance)
        XCTAssertNotNil(result?.objects[0].platformAvailable)
        XCTAssertNotNil(result?.objects[0].state)
    }

    func test_AccountBankModel_Decoding_Default() throws {

        let tradeData = getJSONData(from: "accountResponseIncomplete")
        XCTAssertNotNil(tradeData)

        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(AccountListBankModel.self, from: tradeData!)
        XCTAssertNotNil(result?.total)
        XCTAssertEqual(result?.total, 0)
        XCTAssertNotNil(result?.page)
        XCTAssertEqual(result?.page, 0)
        XCTAssertNotNil(result?.perPage)
        XCTAssertEqual(result?.perPage, 0)
        XCTAssertNotNil(result?.objects)
        XCTAssertNotNil(result?.objects[0])
        XCTAssertNotNil(result?.objects[0].type)
        XCTAssertNotNil(result?.objects[0].guid)
        XCTAssertNotNil(result?.objects[0].asset)
        XCTAssertNotNil(result?.objects[0].name)
        XCTAssertNotNil(result?.objects[0].platformBalance)
        XCTAssertNotNil(result?.objects[0].platformAvailable)
        XCTAssertNotNil(result?.objects[0].state)
    }

    func test_AccountBankModel_Decoding_Nil() throws {

        let data = Data()
        let decoder = CybridJSONDecoder()
        let result = try? decoder.decode(AccountListBankModel.self, from: data)

        XCTAssertThrowsError(try decoder.decode(AccountListBankModel.self, from: data))
        XCTAssertNil(result)
    }

    func test_AccountBankModel_withInvalidJSON() throws {

        let tradeData = getJSONData(from: "listPricesResponse")
        XCTAssertNotNil(tradeData)
        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(TradeBankModel.self, from: tradeData!)
        XCTAssertNil(result)
    }

    func test_AccountBankModel_withInvalidArrayOfJSON() throws {

        let tradeData = getJSONData(from: "listPricesResponse")
        XCTAssertNotNil(tradeData)
        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(TradeBankModel.self, from: tradeData!)
        XCTAssertNil(result)
    }

    // MARK: Customer Functions

    func test_CustomerBankModel_Decoding() throws {

        let customerData = getJSONData(from: "createCustomerBankModel")
        XCTAssertNotNil(customerData)

        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(CustomerBankModel.self, from: customerData!)
        XCTAssertNotNil(result?.guid)
        XCTAssertNotNil(result?.type)
        XCTAssertNotNil(result?.createdAt)
        XCTAssertNotNil(result?.state)
    }

    func test_CustomerBankModel_Decoding_Init_Nil() throws {

        let customerData = getJSONData(from: "createCustomerBankModel_Incomplete")
        XCTAssertNotNil(customerData)

        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(CustomerBankModel.self, from: customerData!)
        XCTAssertNil(result?.guid)
    }

    func test_CustomerBankModel_Decoding_Nil() throws {

        let data = Data()
        let decoder = CybridJSONDecoder()
        let result = try? decoder.decode(CustomerBankModel.self, from: data)

        XCTAssertThrowsError(try decoder.decode(CustomerBankModel.self, from: data))
        XCTAssertNil(result)
    }

    func test_CustomerBankModel_withInvalidJSON() throws {

        let tradeData = getJSONData(from: "listPricesResponse")
        XCTAssertNotNil(tradeData)
        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(CustomerBankModel.self, from: tradeData!)
        XCTAssertNil(result)
    }

    // MARK: List Identity Verification

    func test_IdentityVerificationListBankModel_Decoding() throws {

        let data = getJSONData(from: "listIdentityVerifications")
        XCTAssertNotNil(data)

        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(IdentityVerificationListBankModel.self, from: data!)
        XCTAssertNotNil(result?.total)
        XCTAssertEqual(result?.total, 1)
        XCTAssertNotNil(result?.page)
        XCTAssertEqual(result?.page, 0)
        XCTAssertNotNil(result?.perPage)
        XCTAssertEqual(result?.perPage, 1)
        XCTAssertNotNil(result?.objects)
        XCTAssertNotNil(result?.objects[0])
        XCTAssertNotNil(result?.objects[0].type)
        XCTAssertNotNil(result?.objects[0].guid)
        XCTAssertNotNil(result?.objects[0].customerGuid)
        XCTAssertNotNil(result?.objects[0].method)
        XCTAssertNotNil(result?.objects[0].state)
        XCTAssertNotNil(result?.objects[0].outcome)
        XCTAssertNil(result?.objects[0].failureCodes)
    }

    func test_IdentityVerificationListBankModel_Decoding_Incomplete() throws {

        let data = getJSONData(from: "listIdentityVerifications_Incomplete")
        XCTAssertNotNil(data)

        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(IdentityVerificationListBankModel.self, from: data!)
        XCTAssertNotNil(result?.total)
        XCTAssertEqual(result?.total, 0)
        XCTAssertNotNil(result?.page)
        XCTAssertEqual(result?.page, 0)
        XCTAssertNotNil(result?.perPage)
        XCTAssertEqual(result?.perPage, 0)
        XCTAssertNotNil(result?.objects)
        XCTAssertNotNil(result?.objects[0])
        XCTAssertNotNil(result?.objects[0].type)
        XCTAssertNotNil(result?.objects[0].guid)
        XCTAssertNotNil(result?.objects[0].customerGuid)
        XCTAssertNotNil(result?.objects[0].method)
        XCTAssertNotNil(result?.objects[0].state)
        XCTAssertNotNil(result?.objects[0].outcome)
        XCTAssertNil(result?.objects[0].failureCodes)
    }

    func test_IdentityVerificationListBankModel_Decoding_Nil() throws {

        let data = Data()
        let decoder = CybridJSONDecoder()
        let result = try? decoder.decode(IdentityVerificationListBankModel.self, from: data)

        XCTAssertThrowsError(try decoder.decode(IdentityVerificationListBankModel.self, from: data))
        XCTAssertNil(result)
    }

    func test_IdentityVerificationListBankModel_withInvalidJSON() throws {

        let tradeData = getJSONData(from: "listPricesResponse")
        XCTAssertNotNil(tradeData)
        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(IdentityVerificationListBankModel.self, from: tradeData!)
        XCTAssertNil(result)
    }

    func test_IdentityVerificationListBankModel_withInvalidArrayOfJSON() throws {

        let tradeData = getJSONData(from: "listPricesResponse")
        XCTAssertNotNil(tradeData)
        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(IdentityVerificationListBankModel.self, from: tradeData!)
        XCTAssertNil(result)
    }

    // MARK: IdentityVerificationBankModel

    func test_IdentityVerificationBankModel_Decoding() throws {

        let data = getJSONData(from: "createIdentityVerificationModel")
        XCTAssertNotNil(data)

        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(IdentityVerificationBankModel.self, from: data!)
        XCTAssertNotNil(result?.type)
        XCTAssertNotNil(result?.guid)
        XCTAssertNotNil(result?.customerGuid)
        XCTAssertNotNil(result?.createdAt)
        XCTAssertNotNil(result?.method)
        XCTAssertNotNil(result?.state)
        XCTAssertNotNil(result?.outcome)
        XCTAssertNil(result?.failureCodes)
        // XCTAssertNotNil(result?.personaInquiryId)
        // XCTAssertNotNil(result?.personaState)
    }

    func test_IdentityVerificationBankModel_Decoding_Init_Nil() throws {

        let data = getJSONData(from: "createIdentityVerificationModel_Incomplete")
        XCTAssertNotNil(data)

        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(IdentityVerificationBankModel.self, from: data!)
        XCTAssertNil(result?.guid)
    }

    func test_IdentityVerificationBankModel_Decoding_Nil() throws {

        let data = Data()
        let decoder = CybridJSONDecoder()
        let result = try? decoder.decode(IdentityVerificationBankModel.self, from: data)

        XCTAssertThrowsError(try decoder.decode(IdentityVerificationBankModel.self, from: data))
        XCTAssertNil(result)
    }

    func test_IdentityVerificationBankModel_withInvalidJSON() throws {

        let data = getJSONData(from: "listPricesResponse")
        XCTAssertNotNil(data)
        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(IdentityVerificationBankModel.self, from: data!)
        XCTAssertNil(result)
    }

    // MARK: IdentityVerificationWithDetailsBankModel

    func test_IdentityVerificationWithDetailsBankModel_Decoding() throws {

        let data = getJSONData(from: "createIdentityVerificationModel")
        XCTAssertNotNil(data)

        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(IdentityVerificationWithDetailsBankModel.self, from: data!)
        XCTAssertNotNil(result?.type)
        XCTAssertNotNil(result?.guid)
        XCTAssertNotNil(result?.customerGuid)
        XCTAssertNotNil(result?.createdAt)
        XCTAssertNotNil(result?.method)
        XCTAssertNotNil(result?.state)
        XCTAssertNotNil(result?.outcome)
        XCTAssertNil(result?.failureCodes)
        XCTAssertNotNil(result?.personaInquiryId)
        XCTAssertNotNil(result?.personaState)
    }

    func test_IdentityVerificationWithDetailsBankModel_Decoding_Init_Nil() throws {

        let data = getJSONData(from: "createIdentityVerificationModel_Incomplete")
        XCTAssertNotNil(data)

        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(IdentityVerificationWithDetailsBankModel.self, from: data!)
        XCTAssertNil(result?.guid)
    }

    func test_IdentityVerificationWithDetailsBankModel_Decoding_Nil() throws {

        let data = Data()
        let decoder = CybridJSONDecoder()
        let result = try? decoder.decode(IdentityVerificationWithDetailsBankModel.self, from: data)

        XCTAssertThrowsError(try decoder.decode(IdentityVerificationWithDetailsBankModel.self, from: data))
        XCTAssertNil(result)
    }

    func test_IdentityVerificationWithDetailsBankModel_withInvalidJSON() throws {

        let data = getJSONData(from: "listPricesResponse")
        XCTAssertNotNil(data)
        let decoder = CybridJSONDecoder()

        let result = try? decoder.decode(IdentityVerificationWithDetailsBankModel.self, from: data!)
        XCTAssertNil(result)
    }
}
