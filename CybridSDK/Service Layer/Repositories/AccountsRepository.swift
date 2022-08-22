//
//  AccountsRepository.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 18/08/22.
//

import Foundation
import CybridApiBankSwift

typealias FetchAccountsCompletion = (Result<AccountListBankModel, ErrorResponse>) -> Void

protocol AccountsRepository {
  static func fetchAccounts(_ completion: @escaping FetchAccountsCompletion)
}

// MARK: - AccountsRepoProvider
protocol AccountsRepoProvider: AuthenticatedServiceProvider {
  var accountsRepository: AccountsRepository.Type { get set }
}

extension AccountsRepoProvider {
  func fetchAccounts(_ completion: @escaping FetchAccountsCompletion) {
      authenticatedRequest(accountsRepository.fetchAccounts, completion: completion)
  }
}

// MARK: - Protocol Conformance
extension CybridSession: AccountsRepoProvider {}

extension AccountsAPI: AccountsRepository {
    static func fetchAccounts(_ completion: @escaping FetchAccountsCompletion) {
        listAccounts(customerGuid: "bf10305829337d106b82c521bb6c8fd2", completion: completion)
    }
}
