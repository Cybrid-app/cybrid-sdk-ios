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
  var assetsCache: [AssetBankModel]? { get set }
  var assetsRepository: AssetsRepository.Type { get set }
}

extension AssetsRepoProvider {
  func fetchAssetsList(_ completion: @escaping FetchAssetsCompletion) {
    if let cachedData = assetsCache {
      completion(.success(cachedData))
    } else {
      authenticatedRequest(assetsRepository.fetchAssets) { [weak self] result in
        switch result {
        case .success(let newAssets):
          self?.assetsCache = newAssets
          fallthrough
        default:
          completion(result)
        }
      }
    }
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
