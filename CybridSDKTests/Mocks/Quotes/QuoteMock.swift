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
    side: .buy,
    receiveAmount: BigInt(stringLiteral: "12343"),
    deliverAmount: BigInt(stringLiteral: "268"),
    fee: BigInt(stringLiteral: "259"),
    issuedAt: nil,
    expiresAt: nil
  )

  static let sellBitcoin = QuoteBankModel(
    guid: "MOCK_GUID",
    customerGuid: "MOCK_CUSTOMER_GUID",
    symbol: "BTC-USD",
    side: .sell,
    receiveAmount: BigInt(stringLiteral: "268"),
    deliverAmount: BigInt(stringLiteral: "12343"),
    fee: BigInt(stringLiteral: "259"),
    issuedAt: nil,
    expiresAt: nil
  )

  static let invalidQuote = QuoteBankModel(
    guid: nil,
    customerGuid: "MOCK_CUSTOMER_GUID",
    symbol: "BTC-USD",
    side: .sell,
    receiveAmount: BigInt(stringLiteral: "268"),
    deliverAmount: BigInt(stringLiteral: "12343"),
    fee: BigInt(stringLiteral: "259"),
    issuedAt: nil,
    expiresAt: nil
  )

  static let buyBitcoinZeroFee = QuoteBankModel(
    guid: "MOCK_GUID",
    customerGuid: "MOCK_CUSTOMER_GUID",
    symbol: "BTC-USD",
    side: .buy,
    receiveAmount: BigInt(stringLiteral: "12343"),
    deliverAmount: BigInt(stringLiteral: "268"),
    fee: nil,
    issuedAt: nil,
    expiresAt: nil
  )
}
