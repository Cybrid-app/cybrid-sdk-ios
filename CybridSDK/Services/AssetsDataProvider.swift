//
//  AssetsDataProvider.swift
//  CybridSDK
//
//  Created by Cybrid on 18/07/22.
//

import CybridApiBankSwift

// MARK: - AssetsDataProvider

typealias FetchAssetsCompletion = (Result<[AssetBankModel], ErrorResponse>) -> Void

protocol AssetsDataProvider {
  static func fetchAssets(_ completion: @escaping FetchAssetsCompletion)
}

protocol AssetsDataProviding: AuthenticatedServiceProvider {
  var assetsDataProvider: AssetsDataProvider.Type { get set }
}

extension AssetsDataProviding {
  func fetchAssetsList(_ completion: @escaping FetchAssetsCompletion) {
    authenticatedRequest(assetsDataProvider.fetchAssets, completion: completion)
  }
}

extension CybridSession: AssetsDataProviding {}

extension AssetsAPI: AssetsDataProvider {
  static func fetchAssets(_ completion: @escaping FetchAssetsCompletion) {
    listAssets { result in
      switch result {
      case .failure(let error):
        completion(.failure(error))
      case .success(let listModel):
        completion(.success(listModel.objects))
      }
    }
  }
}
