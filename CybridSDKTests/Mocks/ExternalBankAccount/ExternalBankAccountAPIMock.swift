//
//  ExternalBankAccountAPIMock.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 09/12/22.
//

import CybridApiBankSwift
import CybridSDK

final class ExternalBankAccountAPIMock: ExternalBankAccountsAPI {

    typealias CreateExternalBankAccountCompletion = (_ result: Result<ExternalBankAccountBankModel, ErrorResponse>) -> Void
    typealias FetchExternalBankAccountCompletion = (_ result: Result<ExternalBankAccountBankModel, ErrorResponse>) -> Void
    typealias FetchExternalBankAccountsCompletion = (_ result: Result<ExternalBankAccountListBankModel, ErrorResponse>) -> Void

    private static var createExternalBankAccountCompletion: CreateExternalBankAccountCompletion?
    private static var fetchExternalBankAccountCompletion: FetchExternalBankAccountCompletion?
    private static var fetchExternalBankAccountsCompletion: FetchExternalBankAccountsCompletion?

    override class func createExternalBankAccount(
        postExternalBankAccountBankModel: PostExternalBankAccountBankModel,
        apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
        completion: @escaping ((Result<ExternalBankAccountBankModel, ErrorResponse>) -> Void)) -> RequestTask {
            createExternalBankAccountCompletion = completion
            return createExternalBankAccountWithRequestBuilder(postExternalBankAccountBankModel: postExternalBankAccountBankModel).requestTask
    }

    override class func getExternalBankAccount(
        externalBankAccountGuid: String,
        apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
        completion: @escaping ((Result<ExternalBankAccountBankModel, ErrorResponse>) -> Void)) -> RequestTask {
            fetchExternalBankAccountCompletion = completion
            return getExternalBankAccountWithRequestBuilder(externalBankAccountGuid: externalBankAccountGuid).requestTask
    }

    override class func listExternalBankAccounts(
        page: Int? = nil,
        perPage: Int? = nil,
        guid: String? = nil,
        bankGuid: String? = nil,
        customerGuid: String? = nil,
        apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
        completion: @escaping ((Result<ExternalBankAccountListBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        fetchExternalBankAccountsCompletion = completion
            return listExternalBankAccountsWithRequestBuilder().requestTask
    }

    // MARK: Create External Bank Account
    @discardableResult
    class func createExternalBankAccountSuccessfully() -> ExternalBankAccountBankModel {
        createExternalBankAccountCompletion?(.success(ExternalBankAccountBankModel.mock()))
        return ExternalBankAccountBankModel.mock()
    }

    class func createExternalBankAccountError() {
        createExternalBankAccountCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }

    // MARK: Fetch External Bank Account
    @discardableResult
    class func fetchExternalBankAccountSuccessfully() -> ExternalBankAccountBankModel {
        fetchExternalBankAccountCompletion?(.success(ExternalBankAccountBankModel.mock()))
        return ExternalBankAccountBankModel.mock()
    }

    class func fetchExternalBankAccountError() {
        fetchExternalBankAccountCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }

    // MARK: Fetch External Bank Accounts
    @discardableResult
    class func fetchExternalBankAccountsSuccessfully() -> ExternalBankAccountListBankModel {
        fetchExternalBankAccountsCompletion?(.success(ExternalBankAccountListBankModel.mock))
        return ExternalBankAccountListBankModel.mock
    }

    class func fetchExternalBankAccountsError() {
        fetchExternalBankAccountsCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }
}

extension ExternalBankAccountListBankModel {

    static let mock = ExternalBankAccountListBankModel(total: 1, page: 0, perPage: 1, objects: ExternalBankAccountBankModel.list)
}

extension ExternalBankAccountBankModel {

    static func mock() -> Self {
        return ExternalBankAccountBankModel(
        guid: "1234",
        name: "test",
        asset: "test",
        accountKind: .plaid,
        environment: .sandbox,
        bankGuid: "1234",
        customerGuid: "1234",
        createdAt: Date(),
        plaidInstitutionId: "1234",
        plaidAccountMask: "1234",
        plaidAccountName: "test",
        state: .storing)
    }

    static func mockCompleted() -> Self {
        return ExternalBankAccountBankModel(
        guid: "1234",
        name: "test",
        asset: "test",
        accountKind: .plaid,
        environment: .sandbox,
        bankGuid: "1234",
        customerGuid: "1234",
        createdAt: Date(),
        plaidInstitutionId: "1234",
        plaidAccountMask: "1234",
        plaidAccountName: "test",
        state: .completed)
    }
    
    static let list = [
        mock()
    ]
}
