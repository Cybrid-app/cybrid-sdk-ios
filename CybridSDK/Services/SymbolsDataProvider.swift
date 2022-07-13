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
  var listSymbolsService: SymbolsAPI.Type { get }
  func fetchAvailableSymbols(_ completion: @escaping FetchSymbolsCompletion)
}

extension CybridSession: SymbolsDataProvider {
  func fetchAvailableSymbols(_ completion: @escaping FetchSymbolsCompletion) {
    request({ [weak self] completion in
      self?.listSymbolsService.listSymbols(completion: completion)
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
