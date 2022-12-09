//
//  BankRepository.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 08/12/22.
//

import CybridApiBankSwift

typealias FetchBankCompletion = (Result<BankBankModel, ErrorResponse>) -> Void

protocol BankRepository {

    static func fetchBank(guid: String, _ completion: @escaping FetchBankCompletion)
}

protocol BankProvider: AuthenticatedServiceProvider {
    var bankRepository: BankRepository.Type { get set }
}

// MARK: BankProvider Extensions
extension BankProvider {

    func fetchBank(guid: String, _ completion: @escaping FetchBankCompletion) {
        authenticatedRequest(bankRepository.fetchBank,
                             parameters: guid,
                             completion: completion)
    }
}

// MARK: CybridSession Extensions
extension CybridSession: BankProvider {}

// MARK: BanksAPI Extensions
extension BanksAPI: BankRepository {

    static func fetchBank(guid: String, _ completion: @escaping FetchBankCompletion) {
        getBank(bankGuid: guid, completion: completion)
    }
}
