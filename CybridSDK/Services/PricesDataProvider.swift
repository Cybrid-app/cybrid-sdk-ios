//
//  PricesDataProvider.swift
//  CybridSDK
//
//  Created by Cybrid on 18/07/22.
//

import CybridApiBankSwift

// MARK: - PricesDataProvider

typealias FetchPricesCompletion = (Result<[SymbolPriceBankModel], ErrorResponse>) -> Void

protocol PricesDataProvider {
  static func fetchPrices(_ completion: @escaping FetchPricesCompletion)
}

protocol PricesDataProviding: AuthenticatedServiceProvider {
  var pricesDataProvider: PricesDataProvider.Type { get set }
}

extension PricesDataProviding {
  func fetchPriceList(_ completion: @escaping FetchPricesCompletion) {
    authenticatedRequest(pricesDataProvider.fetchPrices, completion: completion)
  }
}

extension CybridSession: PricesDataProviding {}

extension PricesAPI: PricesDataProvider {
  static func fetchPrices(_ completion: @escaping FetchPricesCompletion) {
    listPrices(completion: completion)
  }
}
