//
//  PricesDataProvider.swift
//  CybridSDK
//
//  Created by Cybrid on 18/07/22.
//

import CybridApiBankSwift

// MARK: - PricesDataProvider

typealias FetchPricesCompletion = (Result<[SymbolPriceBankModel], ErrorResponse>) -> Void

protocol PricesRepository {
  static func fetchPrices(_ completion: @escaping FetchPricesCompletion)
}

protocol PricesRepoProvider: AuthenticatedServiceProvider {
  var pricesRepository: PricesRepository.Type { get set }
}

extension PricesRepoProvider {
  func fetchPriceList(_ completion: @escaping FetchPricesCompletion) {
    authenticatedRequest(pricesRepository.fetchPrices, completion: completion)
  }
}

extension CybridSession: PricesRepoProvider {}

extension PricesAPI: PricesRepository {
  static func fetchPrices(_ completion: @escaping FetchPricesCompletion) {
    listPrices(completion: completion)
  }
}
