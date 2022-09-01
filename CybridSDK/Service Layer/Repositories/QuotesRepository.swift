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
}

extension QuotesRepoProvider {
  func createQuote(params: PostQuoteBankModel,
                   with scheduler: CybridTaskScheduler?,
                   _ completion: @escaping CreateQuoteCompletion) {
    if let scheduler = scheduler {
      scheduler.start { [weak self] in
        guard let self = self else { return }
        self.authenticatedRequest(self.quotesRepository.createQuote, parameters: params, completion: completion)
      }
    } else {
      authenticatedRequest(quotesRepository.createQuote, parameters: params, completion: completion)
    }
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
