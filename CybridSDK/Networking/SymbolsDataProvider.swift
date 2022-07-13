//
//  SymbolsDataProvider.swift
//  CybridSDK
//
//  Created by Cybrid on 13/07/22.
//

import CybridApiBankSwift

// MARK: - SymbolsDataProvider

typealias FetchSymbolsCompletion = (Result<[String], Error>) -> Void

protocol SymbolsDataProvider {
  func fetchAvailableSymbols(_ completion: @escaping FetchSymbolsCompletion)
}

extension CybridSession: SymbolsDataProvider {
  func fetchAvailableSymbols(_ completion: @escaping FetchSymbolsCompletion) {
    request({ completion in
      SymbolsAPI.listSymbols(completion: completion)
    },
    completion: { result in
      switch result {
      case .success(let symbols):
        completion(.success(symbols))
      case .failure(let error):
        completion(.failure(error))
      }
    })
  }
}
