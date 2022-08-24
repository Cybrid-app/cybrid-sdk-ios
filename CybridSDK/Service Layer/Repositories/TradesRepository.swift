//
//  TradesRepository.swift
//  CybridSDK
//
//  Created by Cybrid on 23/08/22.
//

import BigInt
import CybridApiBankSwift

// MARK: - TradesRepository

typealias CreateTradeCompletion = (Result<TradeBankModel, ErrorResponse>) -> Void

protocol TradesRepository {
  static func createTrade(quoteGuid: String,
                          _ completion: @escaping CreateTradeCompletion)
}

protocol TradesRepoProvider: AuthenticatedServiceProvider {
  var tradesRepository: TradesRepository.Type { get set }
}

extension TradesRepoProvider {
  func createTrade(quoteGuid: String,
                   _ completion: @escaping CreateTradeCompletion) {
    tradesRepository.createTrade(quoteGuid: quoteGuid,
                                 completion)
  }
}

extension CybridSession: TradesRepoProvider {}

extension TradesAPI: TradesRepository {
  static func createTrade(quoteGuid: String,
                          _ completion: @escaping CreateTradeCompletion) {
    createTrade(
      postTradeBankModel: PostTradeBankModel(quoteGuid: quoteGuid),
      completion: completion
    )
  }
}
