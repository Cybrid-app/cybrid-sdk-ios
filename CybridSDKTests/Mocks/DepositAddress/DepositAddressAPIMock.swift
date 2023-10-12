//
//  DepositAddressAPIMock.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 26/07/23.
//

import CybridApiBankSwift
import CybridSDK

final class DepositAddressAPIMock: DepositAddressesAPI {

    typealias FetchListDepositAddressCompletion = (_ result: Result<DepositAddressListBankModel, ErrorResponse>) -> Void
    typealias FetchDepositAddressCompletion = (_ result: Result<DepositAddressBankModel, ErrorResponse>) -> Void
    typealias CreateDepositAddressCompletion = (_ result: Result<DepositAddressBankModel, ErrorResponse>) -> Void

    private static var fetchListDepositAddressCompletion: FetchListDepositAddressCompletion?
    private static var fetchDepositAddressCompletion: FetchDepositAddressCompletion?
    private static var createDepositAddressCompletion: CreateDepositAddressCompletion?

    @discardableResult
    override class func listDepositAddresses(page: Int? = nil, perPage: Int? = nil, guid: String? = nil, bankGuid: String? = nil, customerGuid: String? = nil, label: String? = nil, apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue, completion: @escaping ((Result<DepositAddressListBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        fetchListDepositAddressCompletion = completion
        return listDepositAddressesWithRequestBuilder().requestTask
    }

    class func didFetchListDepositAddressSuccessfully() {
        fetchListDepositAddressCompletion?(.success(DepositAddressListBankModel.mock))
    }

    class func didFetchListDepositAddressFailed() {
        fetchListDepositAddressCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }

    @discardableResult
    override class func getDepositAddress(depositAddressGuid: String, apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue, completion: @escaping ((Result<DepositAddressBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        fetchDepositAddressCompletion = completion
        return getDepositAddressWithRequestBuilder(depositAddressGuid: depositAddressGuid).requestTask
    }

    class func didFetchDepositAddressSuccessfully() {
        fetchDepositAddressCompletion?(.success(DepositAddressBankModel.mock))
    }

    class func didFetchDepositAddressFailed() {
        fetchDepositAddressCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }

    @discardableResult
    override class func createDepositAddress(postDepositAddressBankModel: PostDepositAddressBankModel, apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue, completion: @escaping ((Result<DepositAddressBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        createDepositAddressCompletion = completion
        return createDepositAddressWithRequestBuilder(postDepositAddressBankModel: postDepositAddressBankModel).requestTask
    }

    class func didCreateDepositAddressSuccessfully() {
        createDepositAddressCompletion?(.success(DepositAddressBankModel.mock))
    }

    class func didCreateDepositAddressFailed() {
        createDepositAddressCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }
}
