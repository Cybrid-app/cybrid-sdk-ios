//
//  QuotesRepository.swift
//  CybridSDK
//
//  Created by Cybrid on 22/08/22.
//

import BigInt
import CybridApiBankSwift

// MARK: - QuotesDataProvider

typealias CreateQuoteCompletion = (Result<QuoteBankModel, ErrorResponse>) -> Void

protocol QuotesRepository {
  static func createQuote(symbol: String,
                          type: TradeType,
                          receiveAmount: String?,
                          deliverAmount: String?,
                          _ completion: @escaping CreateQuoteCompletion)
}

protocol QuotesRepoProvider: AuthenticatedServiceProvider {
  var quotesRepository: QuotesRepository.Type { get set }
}

extension QuotesRepoProvider {
  func createQuote(symbol: String,
                   type: TradeType,
                   receiveAmount: String?,
                   deliverAmount: String?,
                   _ completion: @escaping CreateQuoteCompletion) {
    quotesRepository.createQuote(symbol: symbol,
                                 type: type,
                                 receiveAmount: receiveAmount,
                                 deliverAmount: deliverAmount,
                                 completion)
  }
}

extension CybridSession: QuotesRepoProvider {}

extension QuotesAPI: QuotesRepository {
  static func createQuote(symbol: String,
                          type: TradeType,
                          receiveAmount: String?,
                          deliverAmount: String?,
                          _ completion: @escaping CreateQuoteCompletion) {
    createQuote(
      postQuoteBankModel: PostQuoteBankModel(
        customerGuid: Cybrid.customerGUID,
        symbol: symbol,
        side: type.sideBankModel,
        receiveAmount: receiveAmount,
        deliverAmount: deliverAmount
      ),
      completion: completion
    )
  }
}
