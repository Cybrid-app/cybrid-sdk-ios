//
//  AccountsRepository.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 14/09/22.
//

import Foundation
import CybridApiBankSwift

typealias FetchAccountsCompletion = (Result<AccountListBankModel, ErrorResponse>) -> Void

protocol AccountsRepository {
    static func fetchAccounts(customerGuid: String, _ completion: @escaping FetchAccountsCompletion)
}

protocol AccountsRepoProvider: AuthenticatedServiceProvider {
  var accountsRepository: AccountsRepository.Type { get set }
}

// MARK: AccountsRepoProvider Extensions
extension AccountsRepoProvider {

    func fetchAccounts(customerGuid: String, _ completion: @escaping FetchAccountsCompletion) {
        authenticatedRequest(accountsRepository.fetchAccounts, parameters: customerGuid, completion: completion)
    }
}

// MARK: CybridSession Extensions
extension CybridSession: AccountsRepoProvider {}

// MARK: AccountsAPI Extensions
extension AccountsAPI: AccountsRepository {

    static func fetchAccounts(customerGuid: String, _ completion: @escaping FetchAccountsCompletion) {
        listAccounts(customerGuid: customerGuid, completion: completion)
    }
}
