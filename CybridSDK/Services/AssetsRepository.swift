//
//  AssetsDataProvider.swift
//  CybridSDK
//
//  Created by Cybrid on 18/07/22.
//

import CybridApiBankSwift

// MARK: - AssetsDataProvider

typealias FetchAssetsCompletion = (Result<[AssetBankModel], ErrorResponse>) -> Void

protocol AssetsRepository {
  static func fetchAssets(_ completion: @escaping FetchAssetsCompletion)
}

protocol AssetsRepoProvider: AuthenticatedServiceProvider {
  var assetsRepository: AssetsRepository.Type { get set }
}

extension AssetsRepoProvider {
  func fetchAssetsList(_ completion: @escaping FetchAssetsCompletion) {
    authenticatedRequest(assetsRepository.fetchAssets, completion: completion)
  }
}

extension CybridSession: AssetsRepoProvider {}

extension AssetsAPI: AssetsRepository {
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
