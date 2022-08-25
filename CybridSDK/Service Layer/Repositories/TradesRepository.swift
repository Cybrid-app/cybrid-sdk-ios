//
//  TradesRepository.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 25/08/22.
//

import Foundation
import CybridApiBankSwift

typealias FetchTradesCompletition = (Result<TradeListBankModel, ErrorResponse>) -> Void

protocol TradesRepository {
    static func fetchTrades(accountGuid: String, _ completiton: @escaping FetchTradesCompletition)
}

// MARK: - TradesRepoProvider
protocol TradesRepoProvider: AuthenticatedServiceProvider {
  var tradesRepository: TradesRepository.Type { get set }
}

extension TradesRepoProvider {
    func fetchTrades(accountGuid: String, _ completion: @escaping FetchTradesCompletition) {
        tradesRepository.fetchTrades(accountGuid: accountGuid, completion)
  }
}

// MARK: - Protocol Conformance
extension CybridSession: TradesRepoProvider {}

extension TradesAPI: TradesRepository {
    static func fetchTrades(accountGuid: String, _ completion: @escaping FetchTradesCompletition) {
        listTrades(accountGuid: accountGuid, completion: completion)
    }
}
