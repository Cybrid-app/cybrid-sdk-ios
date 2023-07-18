//
//  DepositAddressRepository.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 18/07/23.
//

import CybridApiBankSwift

typealias FetchListDepositAddressCompletion = (Result<DepositAddressListBankModel, ErrorResponse>) -> Void
typealias FetchDepositAddressCompletion = (Result<DepositAddressBankModel, ErrorResponse>) -> Void
typealias CreateDepositAddressCompletion = (Result<DepositAddressBankModel, ErrorResponse>) -> Void

protocol DepositAddressRepoProvider: AuthenticatedServiceProvider {

    var depositAddressRepository: DepositAddressRepository.Type { get set }
}

extension DepositAddressRepoProvider {

    func fetchListDepositAddress(_ completion: @escaping FetchListDepositAddressCompletion) {
        authenticatedRequest(depositAddressRepository.fetchListDepositAddress, completion: completion)
    }

    func fetchDepositAddress(depositAddressGuid: String, _ completion: @escaping FetchDepositAddressCompletion) {
        authenticatedRequest(depositAddressRepository.fetchDepositAddress, parameters: depositAddressGuid, completion: completion)
    }

    func createDepositAddress(postDepositAdrress: PostDepositAddressBankModel, _ completion: @escaping CreateDepositAddressCompletion) {
        authenticatedRequest(depositAddressRepository.createDepositAddress, parameters: postDepositAdrress, completion: completion)
    }
}

extension CybridSession: DepositAddressRepoProvider {}

protocol DepositAddressRepository {

    static func fetchListDepositAddress(_ completion: @escaping FetchListDepositAddressCompletion)

    static func fetchDepositAddress(depositAddressGuid: String, _ completion: @escaping FetchDepositAddressCompletion)

    static func createDepositAddress(postDepositAdrress: PostDepositAddressBankModel, _ completion: @escaping CreateDepositAddressCompletion)
}

extension DepositAddressesAPI: DepositAddressRepository {

    static func fetchListDepositAddress(_ completion: @escaping FetchListDepositAddressCompletion) {
        listDepositAddresses(completion: completion)
    }

    static func fetchDepositAddress(depositAddressGuid: String, _ completion: @escaping FetchDepositAddressCompletion) {
        getDepositAddress(depositAddressGuid: depositAddressGuid, completion: completion)
    }

    static func createDepositAddress(postDepositAdrress: PostDepositAddressBankModel, _ completion: @escaping CreateDepositAddressCompletion) {
        createDepositAddress(postDepositAddressBankModel: postDepositAdrress, completion: completion)
    }
}
