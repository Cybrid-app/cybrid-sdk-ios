//
//  QuoteMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 24/08/22.
//

import BigInt
import CybridApiBankSwift

extension QuoteBankModel {
  static let buyBitcoin = QuoteBankModel(
    guid: "MOCK_GUID",
    customerGuid: "MOCK_CUSTOMER_GUID",
    symbol: "BTC-USD",
    side: "buy",
    receiveAmount: "12343",
    deliverAmount: "268",
    fee: "259",
    issuedAt: nil,
    expiresAt: nil
  )

  static let sellBitcoin = QuoteBankModel(
    guid: "MOCK_GUID",
    customerGuid: "MOCK_CUSTOMER_GUID",
    symbol: "BTC-USD",
    side: "sell",
    receiveAmount: "268",
    deliverAmount: "12343",
    fee: "259",
    issuedAt: nil,
    expiresAt: nil
  )

  static let invalidQuote = QuoteBankModel(
    guid: nil,
    customerGuid: "MOCK_CUSTOMER_GUID",
    symbol: "BTC-USD",
    side: "sell",
    receiveAmount: "268",
    deliverAmount: "12343",
    fee: "259",
    issuedAt: nil,
    expiresAt: nil
  )

  static let buyBitcoinZeroFee = QuoteBankModel(
    guid: "MOCK_GUID",
    customerGuid: "MOCK_CUSTOMER_GUID",
    symbol: "BTC-USD",
    side: "buy",
    receiveAmount: "12343",
    deliverAmount: "268",
    fee: nil,
    issuedAt: nil,
    expiresAt: nil
  )
}
