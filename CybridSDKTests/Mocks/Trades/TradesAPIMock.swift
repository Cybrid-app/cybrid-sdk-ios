//
//  TradesAPIMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 24/08/22.
//

import CybridApiBankSwift
import CybridSDK

final class TradesAPIMock: TradesAPI {
  typealias CreateTradeCompletion = (_ result: Result<TradeBankModel, ErrorResponse>) -> Void
  private static var createTradeCompletion: CreateTradeCompletion?

  @discardableResult
  override class func createTrade(postTradeBankModel: PostTradeBankModel,
                                  apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                  completion: @escaping ((Result<TradeBankModel, ErrorResponse>) -> Void)) -> RequestTask {
    createTradeCompletion = completion
    return createTradeWithRequestBuilder(postTradeBankModel: postTradeBankModel).requestTask
  }

  class func didCreateTradeSuccessfully(mockTrade: TradeBankModel) {
    createTradeCompletion?(.success(mockTrade))
  }

  class func didCreateTradeFailed() {
    createTradeCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
  }
}
