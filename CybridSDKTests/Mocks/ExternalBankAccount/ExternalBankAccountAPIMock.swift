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

    private static var createExternalBankAccountCompletion: CreateExternalBankAccountCompletion?

    override class func createExternalBankAccount(
        postExternalBankAccountBankModel: PostExternalBankAccountBankModel,
        apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
        completion: @escaping ((Result<ExternalBankAccountBankModel, ErrorResponse>) -> Void)) -> RequestTask {
            createExternalBankAccountCompletion = completion
            return createExternalBankAccountWithRequestBuilder(postExternalBankAccountBankModel: postExternalBankAccountBankModel).requestTask
    }

    // MARK: Create Bank
    @discardableResult
    class func createExternalBankAccountSuccessfully() -> ExternalBankAccountBankModel {
        createExternalBankAccountCompletion?(.success(ExternalBankAccountBankModel.mock()))
        return ExternalBankAccountBankModel.mock()
    }

    class func createExternalBankAccountError() {
        createExternalBankAccountCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }
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
}
