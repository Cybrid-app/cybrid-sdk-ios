//
//  ExternalWalletAPIMock.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 23/08/23.
//

import CybridApiBankSwift
import CybridSDK

final class ExternalWalletAPIMock: ExternalWalletsAPI {

    typealias FetchExternalWalletListBankModelCompletion = (_ result: Result<ExternalWalletListBankModel, ErrorResponse>) -> Void
    typealias FetchExternalWalletBankModelCompletion = (_ result: Result<ExternalWalletBankModel, ErrorResponse>) -> Void
    typealias CreateExternalWalletBankModelCompletion = (_ result: Result<ExternalWalletBankModel, ErrorResponse>) -> Void
    typealias DeleteExternalWalletBankModelCompletion = (_ result: Result<ExternalWalletBankModel, ErrorResponse>) -> Void

    // swiftlint:disable:next identifier_name
    private static var fetchExternalWalletListBankModelCompletion: FetchExternalWalletListBankModelCompletion?
    private static var fetchExternalWalletBankModelCompletion: FetchExternalWalletBankModelCompletion?
    private static var createExternalWalletBankModelCompletion: CreateExternalWalletBankModelCompletion?
    private static var deleteExternalWalletBankModelCompletion: DeleteExternalWalletBankModelCompletion?

    override class func listExternalWallets(page: Int? = nil, perPage: Int? = nil, owner: ListRequestOwnerBankModel? = nil, guid: String? = nil, bankGuid: String? = nil, customerGuid: String? = nil, state: String? = nil, apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue, completion: @escaping ((Result<ExternalWalletListBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        fetchExternalWalletListBankModelCompletion = completion
        return listExternalWalletsWithRequestBuilder().requestTask
    }

    class func didFetchListExternalWalletsSuccessfully() {
        fetchExternalWalletListBankModelCompletion?(.success(ExternalWalletListBankModel.mock))
    }

    class func didFetchListExternalWalletsFailed() {
        fetchExternalWalletListBankModelCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }

    @discardableResult
    override class func getExternalWallet(externalWalletGuid: String, apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue, completion: @escaping ((Result<ExternalWalletBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        fetchExternalWalletBankModelCompletion = completion
        return getExternalWalletWithRequestBuilder(externalWalletGuid: externalWalletGuid).requestTask
    }

    class func didFetchExternalWalletSuccessfully() {
        fetchExternalWalletBankModelCompletion?(.success(ExternalWalletBankModel.mock))
    }

    class func didFetchExternalWalletFailed() {
        fetchExternalWalletBankModelCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }

    @discardableResult
    override class func createExternalWallet(postExternalWalletBankModel: PostExternalWalletBankModel, apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue, completion: @escaping ((Result<ExternalWalletBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        createExternalWalletBankModelCompletion = completion
        return createExternalWalletWithRequestBuilder(postExternalWalletBankModel: postExternalWalletBankModel).requestTask
    }

    class func didCreateExternalWalletSuccessfully() {
        createExternalWalletBankModelCompletion?(.success(ExternalWalletBankModel.mock))
    }

    class func didCreateExternalWalletFailed() {
        createExternalWalletBankModelCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }

    override class func deleteExternalWallet(externalWalletGuid: String, apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue, completion: @escaping ((Result<ExternalWalletBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        deleteExternalWalletBankModelCompletion = completion
        return deleteExternalWalletWithRequestBuilder(externalWalletGuid: externalWalletGuid).requestTask
    }

    class func didDeleteExternalWalletSuccessfully() {
        deleteExternalWalletBankModelCompletion?(.success(ExternalWalletBankModel.mock))
    }

    class func didDeleteExternalWalletFailed() {
        deleteExternalWalletBankModelCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }
}
