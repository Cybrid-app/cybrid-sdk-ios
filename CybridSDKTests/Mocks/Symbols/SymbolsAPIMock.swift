//
//  SymbolsAPIMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 13/07/22.
//

import CybridApiBankSwift
import CybridSDK

final class SymbolsAPIMock: SymbolsAPI {
  private static var listSymbolsCompletion: ((Result<[String], ErrorResponse>) -> Void)?

  @discardableResult
  override class func listSymbols(apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                  completion: @escaping ((_ result: Swift.Result<[String], ErrorResponse>) -> Void)) -> RequestTask {
    listSymbolsCompletion = completion
    return listSymbolsWithRequestBuilder().requestTask
  }

  class func didFetchSymbolsSuccessfully() {
    listSymbolsCompletion?(.success(.mockSymbols))
  }

  class func didFetchSymbolsWithError() {
    listSymbolsCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
  }
}
