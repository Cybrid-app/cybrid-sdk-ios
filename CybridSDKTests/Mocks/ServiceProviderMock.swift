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
                                 TradesRepoProvider,
                                 AccountsRepoProvider {

    var apiManager: CybridAPIManager.Type = MockAPIManager.self
    var authenticator: CybridAuthenticator? = MockAuthenticator()

    // MARK: Repositories
    var assetsRepository: AssetsRepository.Type = AssetsAPIMock.self
    var pricesRepository: PricesRepository.Type = PricesAPIMock.self
    var quotesRepository: QuotesRepository.Type = QuotesAPIMock.self
    var tradesRepository: TradesRepository.Type = TradesAPIMock.self
    var accountsRepository: AccountsRepository.Type = AccountsAPIMock.self

    // MARK: Cache
    var assetsCache: [AssetBankModel]?

    init() { }

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

    func didFetchAccountsSuccessfully() {

        (authenticator as? MockAuthenticator)?.authenticationSuccess()
        AccountsAPIMock.didFetchAccountsSuccessfully()
    }

    func didFetchAccountsWithError() {

        (authenticator as? MockAuthenticator)?.authenticationSuccess()
        AccountsAPIMock.didFetchAccountsWithError()
    }
}
