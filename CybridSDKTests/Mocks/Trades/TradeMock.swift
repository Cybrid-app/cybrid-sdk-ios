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
    side: .buy,
    state: .initiating,
    receiveAmount: BigInt(stringLiteral: "12343"),
    deliverAmount: BigInt(stringLiteral: "268"),
    fee: BigInt(stringLiteral: "259"),
    createdAt: nil
  )

  static let sellBitcoin = TradeBankModel(
    guid: "MOCK_TRADE_GUID",
    customerGuid: "MOCK_CUSTOMER_GUID",
    quoteGuid: "MOCK_QUOTE_GUID",
    symbol: "BTC-USD",
    side: .sell,
    state: .initiating,
    receiveAmount: BigInt(stringLiteral: "268"),
    deliverAmount: BigInt(stringLiteral: "12343"),
    fee: BigInt(stringLiteral: "259"),
    createdAt: nil
  )
}
