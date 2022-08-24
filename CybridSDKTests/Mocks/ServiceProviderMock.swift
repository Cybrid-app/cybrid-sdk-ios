//
//  PriceListDataProviderMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 13/07/22.
//

import CybridApiBankSwift
@testable import CybridSDK

final class ServiceProviderMock: AssetsRepoProvider,
                                 PricesRepoProvider,
                                 QuotesRepoProvider,
                                 TradesRepoProvider {
  var apiManager: CybridAPIManager.Type = MockAPIManager.self
  var authenticator: CybridAuthenticator? = MockAuthenticator()

  // MARK: Repositories
  var assetsRepository: AssetsRepository.Type = AssetsAPIMock.self
  var pricesRepository: PricesRepository.Type = PricesAPIMock.self
  var pricesFetchScheduler: TaskScheduler
  var quotesRepository: QuotesRepository.Type = QuotesAPIMock.self
  var tradesRepository: TradesRepository.Type = TradesAPIMock.self

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
    assetsCache = AssetsAPIMock.didFetchAssetsSuccessfully().objects
  }

  func didFetchAssetsWithError() {
    (authenticator as? MockAuthenticator)?.authenticationSuccess()
    AssetsAPIMock.didFetchAssetsWithError()
  }

  func didCreateQuoteSuccessfully(_ dataModel: QuoteBankModel) {
    QuotesAPIMock.didCreateQuoteSuccessfully(mockQuote: dataModel)
  }

  func didCreateQuoteFailed() {
    QuotesAPIMock.didCreateQuoteFailed()
  }

  func didCreateTradeSuccessfully(_ dataModel: TradeBankModel) {
    TradesAPIMock.didCreateTradeSuccessfully(mockTrade: dataModel)
  }

  func didCreateTradeFailed() {
    TradesAPIMock.didCreateTradeFailed()
  }
}
