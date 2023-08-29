//
//  ExternalWalletRepository.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 21/08/23.
//

import CybridApiBankSwift

typealias FetchListExternalWalletCompletion = (Result<ExternalWalletListBankModel, ErrorResponse>) -> Void
typealias CreateExternalWalletCompletion = (Result<ExternalWalletBankModel, ErrorResponse>) -> Void
typealias DeleteExternalWalletAccount = (Result<ExternalWalletBankModel, ErrorResponse>) -> Void

protocol ExternalWalletRepository {

    static func fetchListExternalWallet(_ completion: @escaping FetchListExternalWalletCompletion)

    static func createExternalWallet(postExternalWalletBankModel: PostExternalWalletBankModel, _ completion: @escaping CreateExternalWalletCompletion)

    static func deleteExternalWallet(guid: String, _ completion: @escaping DeleteExternalWalletAccount)
}

protocol ExternalWalletRepoProvider: AuthenticatedServiceProvider {

    var externalWalletRepository: ExternalWalletRepository.Type { get set }
}

extension ExternalWalletRepoProvider {

    func fetchListExternalWallet(_ completion: @escaping FetchListExternalWalletCompletion) {
        authenticatedRequest(externalWalletRepository.fetchListExternalWallet, completion: completion)
    }

    func createExternalWallet(postExternalWalletBankModel: PostExternalWalletBankModel, _ completion: @escaping CreateExternalWalletCompletion) {
        authenticatedRequest(externalWalletRepository.createExternalWallet, parameters: postExternalWalletBankModel, completion: completion)
    }

    func deleteExternalWallet(guid: String, _ completion: @escaping DeleteExternalWalletAccount) {
        authenticatedRequest(externalWalletRepository.deleteExternalWallet, parameters: guid, completion: completion)
    }
}

extension CybridSession: ExternalWalletRepoProvider {}

extension ExternalWalletsAPI: ExternalWalletRepository {

    static func fetchListExternalWallet(_ completion: @escaping FetchListExternalWalletCompletion) {
        listExternalWallets(completion: completion)
    }

    static func createExternalWallet(postExternalWalletBankModel: PostExternalWalletBankModel, _ completion: @escaping CreateExternalWalletCompletion) {
        createExternalWallet(postExternalWalletBankModel: postExternalWalletBankModel, completion: completion)
    }

    static func deleteExternalWallet(guid: String, _ completion: @escaping DeleteExternalWalletAccount) {
        deleteExternalWallet(externalWalletGuid: guid, completion: completion)
    }
}
