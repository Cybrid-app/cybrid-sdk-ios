//
//  ExternalBankAccountRepository.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 09/12/22.
//

import CybridApiBankSwift

typealias CreateExternalBankAccount = (Result<ExternalBankAccountBankModel, ErrorResponse>) -> Void
typealias FetchExternalBankAccount = (Result<ExternalBankAccountBankModel, ErrorResponse>) -> Void
typealias FetchExternalBankAccounts = (Result<ExternalBankAccountListBankModel, ErrorResponse>) -> Void

protocol ExternalBankAccountRepository {

    static func createExternalBankAccount(postExternalBankAccountBankModel: PostExternalBankAccountBankModel, _ completion: @escaping CreateExternalBankAccount)

    static func fetchExternalBankAccount(externalBankAccountGuid: String, _ completion: @escaping FetchExternalBankAccount)

    static func fetchExternalBankAccounts(customerGuid: String, _ completion: @escaping FetchExternalBankAccounts)
}

protocol ExternalBankAccountProvider: AuthenticatedServiceProvider {
    var externalBankAccountRepository: ExternalBankAccountRepository.Type { get set }
}

// MARK: ExternalBankAccountProvider Extensions
extension ExternalBankAccountProvider {

    func createExternalBankAccount(postExternalBankAccountBankModel: PostExternalBankAccountBankModel, _ completion: @escaping CreateExternalBankAccount) {
        authenticatedRequest(externalBankAccountRepository.createExternalBankAccount,
                             parameters: postExternalBankAccountBankModel,
                             completion: completion)
    }

    func fetchExternalBankAccount(externalBankAccountGuid: String, _ completion: @escaping FetchExternalBankAccount) {
        authenticatedRequest(externalBankAccountRepository.fetchExternalBankAccount,
                             parameters: externalBankAccountGuid,
                             completion: completion)
    }

    func fetchExternalBankAccounts(customerGuid: String, _ completion: @escaping FetchExternalBankAccounts) {
        authenticatedRequest(externalBankAccountRepository.fetchExternalBankAccounts,
                             parameters: customerGuid,
                             completion: completion)
    }
}

// MARK: CybridSession Extensions
extension CybridSession: ExternalBankAccountProvider {}

// MARK: ExternalBankAccountsAPI Extensions
extension ExternalBankAccountsAPI: ExternalBankAccountRepository {

    static func createExternalBankAccount(postExternalBankAccountBankModel: PostExternalBankAccountBankModel, _ completion: @escaping CreateExternalBankAccount) {
        createExternalBankAccount(postExternalBankAccountBankModel: postExternalBankAccountBankModel, completion: completion)
    }

    static func fetchExternalBankAccount(externalBankAccountGuid: String, _ completion: @escaping FetchExternalBankAccount) {
        getExternalBankAccount(externalBankAccountGuid: externalBankAccountGuid, completion: completion)
    }

    static func fetchExternalBankAccounts(customerGuid: String, _ completion: @escaping FetchExternalBankAccounts) {
        listExternalBankAccounts(customerGuid: customerGuid, completion: completion)
    }
}
