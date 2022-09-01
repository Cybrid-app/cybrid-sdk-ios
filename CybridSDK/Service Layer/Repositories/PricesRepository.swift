//
//  PricesDataProvider.swift
//  CybridSDK
//
//  Created by Cybrid on 18/07/22.
//

import CybridApiBankSwift

// MARK: - PricesRepository

typealias FetchPricesCompletion = (Result<[SymbolPriceBankModel], ErrorResponse>) -> Void

protocol PricesRepository {
  static func fetchPrices(symbol: String?, _ completion: @escaping FetchPricesCompletion)
}

// MARK: - PricesRepoProvider

protocol PricesRepoProvider: AuthenticatedServiceProvider {
  var pricesRepository: PricesRepository.Type { get set }
}

extension PricesRepoProvider {
  func fetchPriceList(symbol: String? = nil, with scheduler: TaskScheduler? = nil, _ completion: @escaping FetchPricesCompletion) {
    if let scheduler = scheduler {
      scheduler.start { [weak self] in
        guard let self = self else {
          scheduler.cancel()
          return
        }
        self.authenticatedRequest(self.pricesRepository.fetchPrices, parameters: symbol, completion: completion)
      }
    } else {
      authenticatedRequest(pricesRepository.fetchPrices, parameters: symbol, completion: completion)
    }
  }
}

// MARK: - Protocol Conformance

extension CybridSession: PricesRepoProvider {}

extension PricesAPI: PricesRepository {
  static func fetchPrices(symbol: String?, _ completion: @escaping FetchPricesCompletion) {
    listPrices(symbol: symbol, completion: completion)
  }
}
