//
//  SymbolsDataProvider.swift
//  CybridSDK
//
//  Created by Cybrid on 13/07/22.
//

import CybridApiBankSwift

// MARK: - SymbolsDataProvider

typealias FetchSymbolsCompletion = (Result<[String], ErrorResponse>) -> Void

protocol SymbolsRepository {
  static func fetchSymbols(_ completion: @escaping FetchSymbolsCompletion)
}

protocol SymbolsRepoProvider: AuthenticatedServiceProvider {
  var symbolsRepository: SymbolsRepository.Type { get set }
}

extension SymbolsRepoProvider {
  func fetchAvailableSymbols(_ completion: @escaping FetchSymbolsCompletion) {
    authenticatedRequest(symbolsRepository.fetchSymbols, completion: completion)
  }
}

extension CybridSession: SymbolsRepoProvider {}

extension SymbolsAPI: SymbolsRepository {
  static func fetchSymbols(_ completion: @escaping FetchSymbolsCompletion) {
    listSymbols(completion: completion)
  }
}
