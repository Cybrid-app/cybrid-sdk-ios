//
//  AccountsAPIMock.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 27/09/22.
//

import CybridApiBankSwift
import CybridSDK

final class AccountsAPIMock: AccountsAPI {

    typealias AccountsListCompletion = (_ result: Result<AccountListBankModel, ErrorResponse>) -> Void
    private static var accountsCompletion: AccountsListCompletion?

    @discardableResult
    override class func listAccounts(page: Int? = nil, perPage: Int? = nil, guid: String? = nil, bankGuid: String? = nil, customerGuid: String? = nil, apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue, completion: @escaping ((Result<AccountListBankModel, ErrorResponse>) -> Void)) -> RequestTask {

        accountsCompletion = completion
        return listAccountsWithRequestBuilder().requestTask
    }

    @discardableResult
    class func didFetchAccountsSuccessfully(_ accounts: AccountListBankModel? = nil) -> AccountListBankModel {

        accountsCompletion?(.success(accounts ?? AccountsAPIMock.mock))
        return AccountsAPIMock.mock
    }

    class func didFetchAccountsWithError() {
        accountsCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }
}

extension AccountsAPIMock {

    static func getMockAccounts() -> [AccountBankModel] {

        return [
            AccountBankModel(
                type: .trading,
                guid: "GUID",
                createdAt: Date(),
                asset: "BTC",
                name: "BTC-USD",
                bankGuid: "BANK_GUID",
                customerGuid: "CUSTOMER_GUID",
                platformBalance: "200000000",
                platformAvailable: "2000000000",
                state: .created
            )
        ]
    }

    static let mock = AccountListBankModel(total: 1, page: 1, perPage: 1, objects: getMockAccounts())
}
