//
//  IdentityVerificationRepository.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 01/11/22.
//

import Foundation
import CybridApiBankSwift

typealias FetchIdentityCompletion = (Result<IdentityVerificationBankModel, ErrorResponse>) -> Void
typealias FetchIdentityListCompletion = (Result<IdentityVerificationListBankModel, ErrorResponse>) -> Void
typealias CreateIdentityCompletion = (Result<IdentityVerificationBankModel, ErrorResponse>) -> Void

protocol IdentityVerificationRepoProvider: AuthenticatedServiceProvider {
    var identityVerificationRepository: IdentityVerificationRepository.Type { get set }
}

extension IdentityVerificationRepoProvider {

    func getIdentityVerification(guid: String, _ completion: @escaping FetchIdentityCompletion) {
        authenticatedRequest(identityVerificationRepository.getIdentityVerification,
                             parameters: guid,
                             completion: completion)
    }

    func listIdentityVerifications(customerGuid: String, _ completion: @escaping FetchIdentityListCompletion) {
        authenticatedRequest(identityVerificationRepository.listIdentityVerifications,
                             parameters: customerGuid,
                             completion: completion)
    }

    func createIdentityVerification(postIdentityVerificationBankModel: PostIdentityVerificationBankModel, _ completion: @escaping CreateIdentityCompletion) {
        authenticatedRequest(identityVerificationRepository.createIdentityVerification,
                             parameters: postIdentityVerificationBankModel,
                             completion: completion)
    }
}

extension CybridSession: IdentityVerificationRepoProvider {}

protocol IdentityVerificationRepository {

    static func getIdentityVerification(guid: String, _ completion: @escaping FetchIdentityCompletion)
    static func listIdentityVerifications(customerGuid: String, _ completion: @escaping FetchIdentityListCompletion)
    static func createIdentityVerification(postIdentityVerificationBankModel: PostIdentityVerificationBankModel, _ completion: @escaping CreateIdentityCompletion)
}

extension IdentityVerificationsAPI: IdentityVerificationRepository {

    static func getIdentityVerification(guid: String, _ completion: @escaping FetchIdentityCompletion) {
        getIdentityVerification(identityVerificationGuid: guid, completion: completion)
    }

    static func listIdentityVerifications(customerGuid: String, _ completion: @escaping FetchIdentityListCompletion) {
        listIdentityVerifications(page: 0, perPage: 1, customerGuid: customerGuid, completion: completion)
    }

    static func createIdentityVerification(postIdentityVerificationBankModel: PostIdentityVerificationBankModel, _ completion: @escaping CreateIdentityCompletion) {
        createIdentityVerification(postIdentityVerificationBankModel: postIdentityVerificationBankModel, completion: completion)
    }
}
