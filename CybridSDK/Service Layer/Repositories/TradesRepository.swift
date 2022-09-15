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
typealias FetchTradesCompletition = (Result<TradeListBankModel, ErrorResponse>) -> Void

protocol TradesRepoProvider: AuthenticatedServiceProvider {

    var tradesRepository: TradesRepository.Type { get set }
}

extension TradesRepoProvider {

    func createTrade(quoteGuid: String, _ completion: @escaping CreateTradeCompletion) {

        authenticatedRequest(tradesRepository.createTrade, parameters: quoteGuid, completion: completion)
    }

    func fetchTrades(accountGuid: String, _ completion: @escaping FetchTradesCompletition) {

        authenticatedRequest(tradesRepository.fetchTrades, parameters: accountGuid, completion: completion)
    }
}

extension CybridSession: TradesRepoProvider {}

protocol TradesRepository {

    static func createTrade(quoteGuid: String, _ completion: @escaping CreateTradeCompletion)

    static func fetchTrades(accountGuid: String, _ completiton: @escaping FetchTradesCompletition)
}

extension TradesAPI: TradesRepository {

    static func createTrade(quoteGuid: String, _ completion: @escaping CreateTradeCompletion) {

        createTrade(
            postTradeBankModel: PostTradeBankModel(quoteGuid: quoteGuid),
            completion: completion
        )
    }

    static func fetchTrades(accountGuid: String, _ completion: @escaping FetchTradesCompletition) {
        listTrades(accountGuid: accountGuid, completion: completion)
    }
}
