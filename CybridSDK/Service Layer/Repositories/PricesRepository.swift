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
  static func fetchPrices(_ completion: @escaping FetchPricesCompletion)
}

// MARK: - PricesRepoProvider

protocol PricesRepoProvider: AuthenticatedServiceProvider {
  var pricesRepository: PricesRepository.Type { get set }
  var pricesFetchScheduler: TaskScheduler { get }
}

extension PricesRepoProvider {
  func fetchPriceList(liveUpdateEnabled: Bool = true, _ completion: @escaping FetchPricesCompletion) {
    if liveUpdateEnabled {
      pricesFetchScheduler.start { [weak self, pricesFetchScheduler] in
        guard let self = self else {
          pricesFetchScheduler.cancel()
          return
        }
        self.authenticatedRequest(self.pricesRepository.fetchPrices, completion: completion)
      }
    } else {
      authenticatedRequest(pricesRepository.fetchPrices, completion: completion)
    }
  }
}

// MARK: - Protocol Conformance

extension CybridSession: PricesRepoProvider {}

extension PricesAPI: PricesRepository {
  static func fetchPrices(_ completion: @escaping FetchPricesCompletion) {
    listPrices(completion: completion)
  }
}
