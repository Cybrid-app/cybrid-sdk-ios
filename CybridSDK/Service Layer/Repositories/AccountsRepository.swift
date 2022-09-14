//
//  AccountsRepository.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 14/09/22.
//

import Foundation
import CybridApiBankSwift

typealias FetchAccountsCompletion = (Result<AccountListBankModel, ErrorResponse>) -> Void

protocol AccountsRepoProvider: AuthenticatedServiceProvider {
  var accountsRepository: AccountsRepository.Type { get set }
}

extension AccountsRepoProvider {

    func fetchAccounts(customerGuid: String, _ completion: @escaping FetchAccountsCompletion) {
        authenticatedRequest(accountsRepository.fetchAccounts, parameters: customerGuid, completion: completion)
    }
}

extension CybridSession: AccountsRepoProvider {}

// MARK: - AccountsRepository, AccountsAPI
protocol AccountsRepository {
    static func fetchAccounts(customerGuid: String, _ completion: @escaping FetchAccountsCompletion)
}

extension AccountsAPI: AccountsRepository {

    static func fetchAccounts(customerGuid: String, _ completion: @escaping FetchAccountsCompletion) {
        listAccounts(customerGuid: customerGuid, completion: completion)
    }
}
