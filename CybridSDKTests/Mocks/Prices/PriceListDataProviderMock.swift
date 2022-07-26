//
//  PriceListDataProviderMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 13/07/22.
//

import CybridApiBankSwift
@testable import CybridSDK

final class PriceListDataProviderMock: AssetsRepoProvider, PricesRepoProvider {
  var apiManager: CybridAPIManager.Type = MockAPIManager.self
  var authenticator: CybridAuthenticator? = MockAuthenticator()

  // MARK: Repositories
  var assetsRepository: AssetsRepository.Type = AssetsAPIMock.self
  var pricesRepository: PricesRepository.Type = PricesAPIMock.self
  var pricesFetchScheduler: TaskScheduler

  // MARK: Cache
  var assetsCache: [AssetBankModel]?

  init(pricesFetchScheduler: TaskScheduler = TaskSchedulerMock()) {
    self.pricesFetchScheduler = pricesFetchScheduler
  }

  func didFetchPricesSuccessfully(_ prices: [SymbolPriceBankModel]? = nil) {
    (authenticator as? MockAuthenticator)?.authenticationSuccess()
    PricesAPIMock.didFetchPricesSuccessfully(prices)
  }

  func didFetchPricesWithError() {
    (authenticator as? MockAuthenticator)?.authenticationSuccess()
    PricesAPIMock.didFetchPricesWithError()
  }

  func didFetchAssetsSuccessfully() {
    (authenticator as? MockAuthenticator)?.authenticationSuccess()
    AssetsAPIMock.didFetchAssetsSuccessfully()
  }

  func didFetchAssetsWithError() {
    (authenticator as? MockAuthenticator)?.authenticationSuccess()
    AssetsAPIMock.didFetchAssetsWithError()
  }
}
