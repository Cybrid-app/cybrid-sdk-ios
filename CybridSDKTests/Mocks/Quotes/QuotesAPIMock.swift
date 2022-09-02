//
//  QuotesAPIMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 24/08/22.
//

import CybridApiBankSwift
import CybridSDK

final class QuotesAPIMock: QuotesAPI {
  typealias CreateQuoteCompletion = (_ result: Result<QuoteBankModel, ErrorResponse>) -> Void
  private static var createQuoteCompletion: CreateQuoteCompletion?

  @discardableResult
  override class func createQuote(postQuoteBankModel: PostQuoteBankModel,
                                  apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                  completion: @escaping ((Result<QuoteBankModel, ErrorResponse>) -> Void)) -> RequestTask {
    createQuoteCompletion = completion
    return createQuoteWithRequestBuilder(postQuoteBankModel: postQuoteBankModel).requestTask
  }

  class func didCreateQuoteSuccessfully(mockQuote: QuoteBankModel) {
    createQuoteCompletion?(.success(mockQuote))
  }

  class func didCreateQuoteFailed() {
    createQuoteCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
  }
}
