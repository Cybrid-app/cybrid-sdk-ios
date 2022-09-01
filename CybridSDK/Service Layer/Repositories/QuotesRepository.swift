//
//  QuotesRepository.swift
//  CybridSDK
//
//  Created by Cybrid on 22/08/22.
//

import BigInt
import CybridApiBankSwift

// MARK: - QuotesRepository

typealias CreateQuoteCompletion = (Result<QuoteBankModel, ErrorResponse>) -> Void

protocol QuotesRepository {
  static func createQuote(_ params: PostQuoteBankModel,
                          _ completion: @escaping CreateQuoteCompletion)
}

protocol QuotesRepoProvider: AuthenticatedServiceProvider {
  var quotesRepository: QuotesRepository.Type { get set }
//  var quotesScheduler: TaskScheduler { get }
}

extension QuotesRepoProvider {
  func createQuote(symbol: String,
                   type: TradeType,
                   receiveAmount: String?,
                   deliverAmount: String?,
                   _ completion: @escaping CreateQuoteCompletion) {
    let params = PostQuoteBankModel(
      customerGuid: Cybrid.customerGUID,
      symbol: symbol,
      side: type.sideBankModel,
      receiveAmount: receiveAmount,
      deliverAmount: deliverAmount
    )
    authenticatedRequest(quotesRepository.createQuote, parameters: params, completion: completion)
  }
}

extension CybridSession: QuotesRepoProvider {}

extension QuotesAPI: QuotesRepository {
  static func createQuote(_ params: PostQuoteBankModel,
                          _ completion: @escaping CreateQuoteCompletion) {
    createQuote(
      postQuoteBankModel: params,
      completion: completion
    )
  }
}
