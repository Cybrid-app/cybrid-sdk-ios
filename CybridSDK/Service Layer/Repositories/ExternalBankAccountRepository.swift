//
//  ExternalBankAccountRepository.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 09/12/22.
//

import CybridApiBankSwift

typealias CreateExternalBankAccount = (Result<ExternalBankAccountBankModel, ErrorResponse>) -> Void

protocol ExternalBankAccountRepository {

    static func createExternalBankAccount(postExternalBankAccountBankModel: PostExternalBankAccountBankModel, _ completion: @escaping CreateExternalBankAccount)
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
}

// MARK: CybridSession Extensions
extension CybridSession: ExternalBankAccountProvider {}

// MARK: ExternalBankAccountsAPI Extensions
extension ExternalBankAccountsAPI: ExternalBankAccountRepository {

    static func createExternalBankAccount(postExternalBankAccountBankModel: PostExternalBankAccountBankModel, _ completion: @escaping CreateExternalBankAccount) {
        createExternalBankAccount(postExternalBankAccountBankModel: postExternalBankAccountBankModel, completion: completion)
    }
}
