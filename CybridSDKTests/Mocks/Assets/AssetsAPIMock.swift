//
//  AssetsAPIMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 19/07/22.
//

import CybridApiBankSwift
import CybridSDK

final class AssetsAPIMock: AssetsAPI {
  typealias AssetsListCompletion = (_ result: Result<AssetListBankModel, ErrorResponse>) -> Void
  private static var listAssetsCompletion: AssetsListCompletion?

  @discardableResult
  override class func listAssets(page: Int? = nil,
                                 perPage: Int? = nil,
                                 apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                 completion: @escaping ((_ result: Result<AssetListBankModel, ErrorResponse>) -> Void)) -> RequestTask {
    listAssetsCompletion = completion
    return listAssetsWithRequestBuilder().requestTask
  }

  @discardableResult
  class func didFetchAssetsSuccessfully() -> AssetListBankModel {
    listAssetsCompletion?(.success(.mock))
    return .mock
  }

  class func didFetchAssetsWithError() {
    listAssetsCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
  }
}
