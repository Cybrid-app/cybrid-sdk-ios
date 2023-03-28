//
//  TransferRepository.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 26/03/23.
//
import CybridApiBankSwift

// MARK: - TransfersRepository

typealias CreateTransferCompletion = (Result<TransferBankModel, ErrorResponse>) -> Void
typealias FetchTransfersCompletition = (Result<TransferListBankModel, ErrorResponse>) -> Void

protocol TransfersRepoProvider: AuthenticatedServiceProvider {

    var transfersRepository: TransfersRepository.Type { get set }
}

extension TransfersRepoProvider {

    func createTransfer(postTransferBankModel: PostTransferBankModel, _ completion: @escaping CreateTransferCompletion) {

        authenticatedRequest(transfersRepository.createTransfer, parameters: postTransferBankModel, completion: completion)
    }

    func fetchTransfers(accountGuid: String, _ completion: @escaping FetchTransfersCompletition) {

        authenticatedRequest(transfersRepository.fetchTransfers, parameters: accountGuid, completion: completion)
    }
}

extension CybridSession: TransfersRepoProvider {}

protocol TransfersRepository {

    static func createTransfer(postTransferBankModel: PostTransferBankModel, _ completion: @escaping CreateTransferCompletion)

    static func fetchTransfers(accountGuid: String, _ completiton: @escaping FetchTransfersCompletition)
}

extension TransfersAPI: TransfersRepository {

    static func createTransfer(postTransferBankModel: PostTransferBankModel, _ completion: @escaping CreateTransferCompletion) {

        createTransfer(postTransferBankModel: postTransferBankModel,
                       completion: completion
        )
    }

    static func fetchTransfers(accountGuid: String, _ completion: @escaping FetchTransfersCompletition) {
        listTransfers(accountGuid: accountGuid, completion: completion)
    }
}
