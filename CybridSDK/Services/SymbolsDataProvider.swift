//
//  SymbolsDataProvider.swift
//  CybridSDK
//
//  Created by Cybrid on 13/07/22.
//

import CybridApiBankSwift

// MARK: - SymbolsDataProvider

typealias FetchSymbolsCompletion = (Result<[String], ErrorResponse>) -> Void

protocol SymbolsDataProvider {
  static func fetchSymbols(_ completion: @escaping FetchSymbolsCompletion)
}

protocol SymbolsDataProviding: AnyObject, AuthenticatedServiceProvider {
  var symbolsDataProvider: SymbolsDataProvider.Type { get set }
}

extension SymbolsDataProviding {
  func fetchAvailableSymbols(_ completion: @escaping FetchSymbolsCompletion) {
    authenticatedRequest(symbolsDataProvider.fetchSymbols, completion: completion)
  }
}

extension CybridSession: SymbolsDataProviding {}

extension SymbolsAPI: SymbolsDataProvider {
  static func fetchSymbols(_ completion: @escaping FetchSymbolsCompletion) {
    listSymbols(completion: completion)
  }
}
