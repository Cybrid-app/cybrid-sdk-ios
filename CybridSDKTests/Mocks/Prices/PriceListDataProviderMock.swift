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
  var assetsRepository: AssetsRepository.Type = AssetsAPIMock.self
  var pricesRepository: PricesRepository.Type = PricesAPIMock.self

  func didFetchPricesSuccessfully() {
    (authenticator as? MockAuthenticator)?.authenticationSuccess()
    PricesAPIMock.didFetchPricesSuccessfully()
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
