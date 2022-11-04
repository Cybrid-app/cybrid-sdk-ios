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
                                 AccountsRepoProvider,
                                 CustomersRepoProvider,
                                 IdentityVerificationRepoProvider {    

    var apiManager: CybridAPIManager.Type = MockAPIManager.self

    // MARK: Repositories
    var assetsRepository: AssetsRepository.Type = AssetsAPIMock.self
    var pricesRepository: PricesRepository.Type = PricesAPIMock.self
    var quotesRepository: QuotesRepository.Type = QuotesAPIMock.self
    var tradesRepository: TradesRepository.Type = TradesAPIMock.self
    var accountsRepository: AccountsRepository.Type = AccountsAPIMock.self
    var customerRepository: CustomersRepository.Type = CustomersAPIMock.self
    var identityVerificationRepository: identityVerificationRepository.Type = IdentityVerificationsAPI.self

    // MARK: Cache
    var assetsCache: [AssetBankModel]?

    init() { }

    func didFetchPricesSuccessfully(_ prices: [SymbolPriceBankModel]? = nil) {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        PricesAPIMock.didFetchPricesSuccessfully(prices)
    }

    func didFetchPricesWithError() {

        PricesAPIMock.didFetchPricesWithError()
    }

    func didFetchAssetsSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        assetsCache = AssetsAPIMock.didFetchAssetsSuccessfully().objects
    }

    func didFetchAssetsWithError() {

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

    func didFetchTradesListSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        TradesAPIMock.didFetchTradesListSuccessfully()
    }

    func didFetchTradesListWithError() {

        TradesAPIMock.didFetchTradesListWithError()
    }

    func didFetchAccountsSuccessfully() {

        AccountsAPIMock.didFetchAccountsSuccessfully()
    }

    func didFetchAccountsWithError() {

        AccountsAPIMock.didFetchAccountsWithError()
    }

    func didCreateCustomerSuccessfully() {

        CustomersAPIMock.didCreateCustomerSuccessfully(nil)
    }

    func didCreateCustomerFailed() {

        CustomersAPIMock.didCreateCustomerFailed()
    }

    func didFetchCustomerSuccessfully() {

        CustomersAPIMock.didFetchCustomerSuccessfully(nil)
    }

    func didFetchCustomerFailed() {

        CustomersAPIMock.didFetchCustomerFailed()
    }
}
