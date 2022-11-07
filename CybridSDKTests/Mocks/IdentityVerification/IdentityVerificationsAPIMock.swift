//
//  IdentityVerificationsAPIMock.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 04/11/22.
//

import CybridApiBankSwift
import CybridSDK

final class IdentityVerificationsAPIMock: IdentityVerificationsAPI {

    typealias FetchIdentityCompletion = (_ result: Result<IdentityVerificationBankModel, ErrorResponse>) -> Void
    typealias FetchIdentityListCompletion = (_ result: Result<IdentityVerificationListBankModel, ErrorResponse>) -> Void
    typealias CreateIdentityCompletion = (_ result: Result<IdentityVerificationBankModel, ErrorResponse>) -> Void

    private static var fetchIdentityCompletion: FetchIdentityCompletion?
    private static var fetchIdentityListCompletion: FetchIdentityListCompletion?
    private static var createIdentityCompletion: CreateIdentityCompletion?

    override class func getIdentityVerification(identityVerificationGuid: String,
                                                apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                                completion: @escaping ((Result<IdentityVerificationBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        fetchIdentityCompletion = completion
        return getIdentityVerificationWithRequestBuilder(identityVerificationGuid: identityVerificationGuid).requestTask
    }

    override class func listIdentityVerifications(page: Int? = nil,
                                                  perPage: Int? = nil,
                                                  guid: String? = nil,
                                                  bankGuid: String? = nil,
                                                  customerGuid: String? = nil,
                                                  apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                                  completion: @escaping ((Result<IdentityVerificationListBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        fetchIdentityListCompletion = completion
        return listIdentityVerificationsWithRequestBuilder().requestTask
    }

    override class func createIdentityVerification(postIdentityVerificationBankModel: PostIdentityVerificationBankModel,
                                                   apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                                   completion: @escaping ((Result<IdentityVerificationBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        createIdentityCompletion = completion
        return createIdentityVerificationWithRequestBuilder(postIdentityVerificationBankModel: postIdentityVerificationBankModel).requestTask
    }

    // MARK: Class Functions

    class func getIdentityVerificationSuccessfully() {
        fetchIdentityCompletion?(.success(IdentityVerificationBankModel.getMock()))
    }

    class func getIdentityVerificationError() {
        fetchIdentityCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }

    class func listIdentityVerificationsSuccessfully() {
        fetchIdentityListCompletion?(.success(IdentityVerificationBankModel.getListMock()))
    }

    class func listIdentityVerificationsError() {
        fetchIdentityListCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }

    class func createIdentityVerificationSuccessfully() {
        createIdentityCompletion?(.success(IdentityVerificationBankModel.getMock()))
    }

    class func createIdentityVerificationError() {
        createIdentityCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }
}

extension IdentityVerificationBankModel {

    static func getMock() -> IdentityVerificationBankModel {
        return IdentityVerificationBankModel(
            guid: "12345",
            customerGuid: "12345",
            type: .kyc,
            method: .idAndSelfie,
            createdAt: Date(),
            state: .storing,
            outcome: .passed,
            failureCodes: [],
            personaInquiryId: "12345",
            personaState: .waiting)
    }

    static func getListMock() -> IdentityVerificationListBankModel {
        return IdentityVerificationListBankModel(total: 1,
                                                 page: 0,
                                                 perPage: 1,
                                                 objects: [getMock()])
    }
}
