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
                                 IdentityVerificationRepoProvider,
                                 WorkflowProvider,
                                 ExternalBankAccountProvider,
                                 BankProvider,
                                 TransfersRepoProvider,
                                 DepositAddressRepoProvider,
                                 ExternalWalletRepoProvider {

    var apiManager: CybridAPIManager.Type = MockAPIManager.self

    // MARK: Repositories
    var assetsRepository: AssetsRepository.Type = AssetsAPIMock.self
    var pricesRepository: PricesRepository.Type = PricesAPIMock.self
    var quotesRepository: QuotesRepository.Type = QuotesAPIMock.self
    var tradesRepository: TradesRepository.Type = TradesAPIMock.self
    var accountsRepository: AccountsRepository.Type = AccountsAPIMock.self
    var customersRepository: CustomersRepository.Type = CustomersAPIMock.self
    var identityVerificationRepository: IdentityVerificationRepository.Type = IdentityVerificationsAPIMock.self
    var workflowRepository: WorkflowRepository.Type = WorkflowAPIMock.self
    var externalBankAccountRepository: ExternalBankAccountRepository.Type = ExternalBankAccountAPIMock.self
    var bankRepository: BankRepository.Type = BankAPIMock.self
    var transfersRepository: TransfersRepository.Type = TransfersAPIMock.self
    var depositAddressRepository: DepositAddressRepository.Type = DepositAddressAPIMock.self
    var externalWalletRepository: ExternalWalletRepository.Type = ExternalWalletAPIMock.self

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

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        QuotesAPIMock.didCreateQuoteSuccessfully(mockQuote: dataModel)
    }

    func didCreateQuoteFailed() {
        QuotesAPIMock.didCreateQuoteFailed()
    }

    func didCreateTradeSuccessfully(_ dataModel: TradeBankModel) {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
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

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        AccountsAPIMock.didFetchAccountsSuccessfully()
    }

    func didFetchAccountsWithError() {

        AccountsAPIMock.didFetchAccountsWithError()
    }

    func didCreateCustomerSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        CustomersAPIMock.didCreateCustomerSuccessfully()
    }

    func didCreateCustomerFailed() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        CustomersAPIMock.didCreateCustomerFailed()
    }

    func didFetchCustomerSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        CustomersAPIMock.didFetchCustomerSuccessfully(CustomerBankModel.mock)
    }

    func didFetchCustomerSuccessfully_Empty() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        CustomersAPIMock.didFetchCustomerSuccessfully(CustomerBankModel.mockEmpty)
    }

    func didFetchCustomerFailed() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        CustomersAPIMock.didFetchCustomerFailed()
    }

    func didFetchIdentityVerificationSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        IdentityVerificationsAPIMock.getIdentityVerificationSuccessfully()
    }

    func didFetchIdentityVerificationFailed() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        IdentityVerificationsAPIMock.getIdentityVerificationError()
    }

    func didFetchListIdentityVerificationSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        IdentityVerificationsAPIMock.listIdentityVerificationsSuccessfully()
    }

    func didFetchListEmptyIdentityVerificationSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        IdentityVerificationsAPIMock.listEmptyIdentityVerificationsSuccessfully()
    }

    func didFetchListExpiredIdentityVerificationSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        IdentityVerificationsAPIMock.listExpiredIdentityVerificationsSuccessfully()
    }

    func didFetchListPersonaExpiredIdentityVerificationSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        IdentityVerificationsAPIMock.listPersonaExpiredIdentityVerificationsSuccessfully()
    }

    func didFetchListIdentityVerificationFailed() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        IdentityVerificationsAPIMock.listIdentityVerificationsError()
    }

    func didCreateIdentityVerificationSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        IdentityVerificationsAPIMock.createIdentityVerificationSuccessfully()
    }

    func didCreateIdentityVerificationFailed() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        IdentityVerificationsAPIMock.createIdentityVerificationError()
    }

    // MARK: Workflow
    func didCreateWorkflowSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        WorkflowAPIMock.createWorkflowSuccessfully()
    }

    func didCreateWorkflowFailed() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        WorkflowAPIMock.createWorkflowError()
    }

    func didFetchWorkflowSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        WorkflowAPIMock.fetchWorkflowSuccessfully()
    }

    func didFetchWorkflow_Empty_Successfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        WorkflowAPIMock.fetchWorkflow_Empty_Successfully()
    }

    func didFetchWorkflow_Incomplete_Successfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        WorkflowAPIMock.fetchWorkflow_Incomplete_Successfully()
    }

    func didFetchWorkflowFailed() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        WorkflowAPIMock.fetchWorkflowError()
    }

    // MARK: Bank
    func didFetchBankSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        BankAPIMock.fetchBankSuccessfully()
    }

    func didFetchBankSuccessfully_Without_Fiat_Assets() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        BankAPIMock.fetchBankSuccessfully_Without_Fiat_Assets()
    }

    func didFetchBankSuccessfully_With_MXN_Fiat_Assets() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        BankAPIMock.fetchBankSuccessfully_With_MXN_Fiat_Assets()
    }

    func didFetchBankSuccessfully_Incomplete() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        BankAPIMock.fetchBankSuccessfully_Incomplete()
    }

    func didFetchBankFailed() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        BankAPIMock.fetchBankError()
    }

    // MARK: External Bank Account
    func createExternalBankAccountSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalBankAccountAPIMock.createExternalBankAccountSuccessfully()
    }

    func createExternalBankAccountFailed() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalBankAccountAPIMock.createExternalBankAccountError()
    }

    func fetchExternalBankAccountSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalBankAccountAPIMock.fetchExternalBankAccountSuccessfully()
    }

    func fetchExternalBankAccountFailed() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalBankAccountAPIMock.fetchExternalBankAccountError()
    }

    func fetchExternalBankAccountsSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalBankAccountAPIMock.fetchExternalBankAccountsSuccessfully()
    }

    func fetchExternalBankAccountsSuccessfully_Empty() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalBankAccountAPIMock.fetchExternalBankAccountsSuccessfully_Empty()
    }

    func fetchExternalBankAccountsFailed() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalBankAccountAPIMock.fetchExternalBankAccountsError()
    }

    func deleteExternalBankAccountSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalBankAccountAPIMock.deleteExternalBankAccountSuccessfully()
    }

    func deleteExternalBankAccountFailed() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalBankAccountAPIMock.deleteExternalBankAccountError()
    }

    func didCreateTransferSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        TransfersAPIMock.didCreateTransferSuccessfully()
    }

    func didCreateTransferFailed() {
        TransfersAPIMock.didCreateTransferFailed()
    }

    func didFetchTransfersListSuccessfully() {

        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        TransfersAPIMock.didFetchTransfersListSuccessfully()
    }

    func didFetchTransfersListWithError() {

        TransfersAPIMock.didFetchTransfersListWithError()
    }

    // MARK: Deposit Address
    func didFetchListDepositAddressSuccessfully() {
        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        DepositAddressAPIMock.didFetchListDepositAddressSuccessfully()
    }

    func didFetchListDepositAddressFailed() {
        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        DepositAddressAPIMock.didFetchListDepositAddressFailed()
    }

    func didFetchDepositAddressSuccessfully() {
        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        DepositAddressAPIMock.didFetchDepositAddressSuccessfully()
    }

    func didFetchDepositAddressFailed() {
        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        DepositAddressAPIMock.didFetchDepositAddressFailed()
    }

    func didCreateDepositAddressSuccessfully() {
        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        DepositAddressAPIMock.didCreateDepositAddressSuccessfully()
    }

    func didCreateDepositAddressFailed() {
        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        DepositAddressAPIMock.didCreateDepositAddressFailed()
    }

    // MARK: External Wallet
    func didFetchListExternalWalletsSuccessfully(mock: ExternalWalletListBankModel = ExternalWalletListBankModel.mock) {
        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalWalletAPIMock.didFetchListExternalWalletsSuccessfully(mock: mock)
    }

    func didFetchListExternalWalletsFailed() {
        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalWalletAPIMock.didFetchListExternalWalletsFailed()
    }

    func didFetchExternalWalletSuccessfully() {
        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalWalletAPIMock.didFetchExternalWalletSuccessfully()
    }

    func didFetchExternalWalletFailed() {
        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalWalletAPIMock.didFetchExternalWalletFailed()
    }

    func didCreateExternalWalletSuccessfully() {
        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalWalletAPIMock.didCreateExternalWalletSuccessfully()
    }

    func didCreateExternalWalletFailed() {
        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalWalletAPIMock.didCreateExternalWalletFailed()
    }

    func didDeleteExternalWalletSuccessfully() {
        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalWalletAPIMock.didDeleteExternalWalletSuccessfully()
    }

    func didDeleteExternalWalletFailed() {
        Cybrid.session.setupSession(authToken: "TEST-TOKEN")
        ExternalWalletAPIMock.didDeleteExternalWalletFailed()
    }
}
