//
//  PricesAPIMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 19/07/22.
//

import CybridApiBankSwift
import CybridSDK

final class PricesAPIMock: PricesAPI {
  typealias AssetsListCompletion = (_ result: Result<[SymbolPriceBankModel], ErrorResponse>) -> Void
  private static var listPricesCompletion: AssetsListCompletion?

  @discardableResult
  override class func listPrices(symbol: String? = nil,
                                 apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                 completion: @escaping ((_ result: Swift.Result<[SymbolPriceBankModel], ErrorResponse>) -> Void)) -> RequestTask {
    listPricesCompletion = completion
    return listPricesWithRequestBuilder().requestTask
  }

  class func didFetchPricesSuccessfully() {
    listPricesCompletion?(.success(.mockPrices))
  }

  class func didFetchPricesWithError() {
    listPricesCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
  }
}

extension Array where Element == SymbolPriceBankModel {
  static let mockPrices: Self = [
    SymbolPriceBankModel(
      symbol: "BTC-USD",
      buyPrice: 2_019_891,
      sellPrice: 2_019_881,
      buyPriceLastUpdatedAt: nil,
      sellPriceLastUpdatedAt: nil
    ),
    SymbolPriceBankModel(
      symbol: "ETH-USD",
      buyPrice: 209_891,
      sellPrice: 209_881,
      buyPriceLastUpdatedAt: nil,
      sellPriceLastUpdatedAt: nil
    )
  ]
}
