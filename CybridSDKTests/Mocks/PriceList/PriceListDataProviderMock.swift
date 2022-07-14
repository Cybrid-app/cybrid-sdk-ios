//
//  PriceListDataProviderMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 13/07/22.
//

import CybridApiBankSwift
@testable import CybridSDK

final class PriceListDataProviderMock: SymbolsDataProviding {
  var apiManager: CybridAPIManager.Type = MockAPIManager.self
  var authenticator: CybridAuthenticator? = MockAuthenticator()
  var symbolsDataProvider: SymbolsDataProvider.Type = SymbolsAPIMock.self

  func didFetchPricesSuccessfully() {
    (authenticator as? MockAuthenticator)?.authenticationSuccess()
    SymbolsAPIMock.didFetchSymbolsSuccessfully()
  }

  func didFetchPricesWithError() {
    (authenticator as? MockAuthenticator)?.authenticationSuccess()
    SymbolsAPIMock.didFetchSymbolsWithError()
  }
}
