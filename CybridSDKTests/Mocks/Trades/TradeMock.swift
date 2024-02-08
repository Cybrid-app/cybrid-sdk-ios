//
//  TradeMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 24/08/22.
//

import BigInt
import CybridApiBankSwift

extension TradeBankModel {
  static let buyBitcoin = TradeBankModel(
    guid: "MOCK_TRADE_GUID",
    customerGuid: "MOCK_CUSTOMER_GUID",
    quoteGuid: "MOCK_QUOTE_GUID",
    symbol: "BTC-USD",
    side: "buy",
    state: "storing",
    receiveAmount: "12343",
    deliverAmount: "268",
    fee: "259",
    createdAt: nil
  )

  static let sellBitcoin = TradeBankModel(
    guid: "MOCK_TRADE_GUID",
    customerGuid: "MOCK_CUSTOMER_GUID",
    quoteGuid: "MOCK_QUOTE_GUID",
    symbol: "BTC-USD",
    side: "sell",
    state: "storing",
    receiveAmount: "268",
    deliverAmount: "12343",
    fee: "259",
    createdAt: nil
  )

  static let invalidData = TradeBankModel(
    guid: nil,
    customerGuid: "MOCK_CUSTOMER_GUID",
    quoteGuid: "MOCK_QUOTE_GUID",
    symbol: "BTC-USD",
    side: "sell",
    state: "storing",
    receiveAmount: "268",
    deliverAmount: "12343",
    fee: "259",
    createdAt: nil
  )

  static let buyBitcoinZeroFee = TradeBankModel(
    guid: "MOCK_TRADE_GUID",
    customerGuid: "MOCK_CUSTOMER_GUID",
    quoteGuid: "MOCK_QUOTE_GUID",
    symbol: "BTC-USD",
    side: "buy",
    state: "storing",
    receiveAmount: "12343",
    deliverAmount: "268",
    fee: nil,
    createdAt: nil
  )
}
