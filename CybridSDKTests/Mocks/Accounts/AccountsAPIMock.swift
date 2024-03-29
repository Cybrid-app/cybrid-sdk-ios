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

    override class func listAccounts(page: Int? = nil,
                                     perPage: Int? = nil,
                                     owner: ListRequestOwnerBankModel? = nil,
                                     guid: String? = nil,
                                     type: String? = nil,
                                     bankGuid: String? = nil,
                                     customerGuid: String? = nil,
                                     label: String? = nil,
                                     apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                     completion: @escaping ((Result<AccountListBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        accountsCompletion = completion
        return listAccountsWithRequestBuilder().requestTask
    }

    @discardableResult
    class func didFetchAccountsSuccessfully(mock: AccountListBankModel) -> AccountListBankModel {

        accountsCompletion?(.success(mock))
        return AccountListBankModel.mock
    }

    class func didFetchAccountsWithError() {
        accountsCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }
}

extension AccountListBankModel {

    static let mock = AccountListBankModel(total: 1, page: 1, perPage: 1, objects: AccountBankModel.mock)
}

extension AccountBankModel {

    static let trading = AccountBankModel(
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

    static let tradingETH = AccountBankModel(
        type: .trading,
        guid: "GUID",
        createdAt: Date(),
        asset: "ETH",
        name: "ETH-USD",
        bankGuid: "BANK_GUID",
        customerGuid: "CUSTOMER_GUID",
        platformBalance: "200000000",
        platformAvailable: "2000000000",
        state: .created
    )

    static let tradingBalanceNil = AccountBankModel(
        type: .trading,
        guid: "GUID",
        createdAt: Date(),
        asset: "BTC",
        name: "BTC-USD",
        bankGuid: "BANK_GUID",
        customerGuid: "CUSTOMER_GUID",
        platformBalance: nil,
        platformAvailable: nil,
        state: .created
    )

    static let tradingBalanceUndefined = AccountBankModel(
        type: .trading,
        guid: "GUID",
        createdAt: Date(),
        asset: "BTC",
        name: "BTC-USD",
        bankGuid: "BANK_GUID",
        customerGuid: "CUSTOMER_GUID",
        platformBalance: "Hello",
        platformAvailable: "Hello",
        state: .created
    )

    static let fiat = AccountBankModel(
        type: .fiat,
        guid: "GUID",
        createdAt: Date(),
        asset: "USD",
        name: "USD",
        bankGuid: "BANK_GUID",
        customerGuid: "CUSTOMER_GUID",
        platformBalance: "200000000",
        platformAvailable: "2000000000",
        state: .created
    )

    static let fiatBalanceNil = AccountBankModel(
        type: .fiat,
        guid: "GUID",
        createdAt: Date(),
        asset: "USD",
        name: "USD",
        bankGuid: "BANK_GUID",
        customerGuid: "CUSTOMER_GUID",
        platformBalance: nil,
        platformAvailable: nil,
        state: .created
    )

    static let fiatBalanceUndefined = AccountBankModel(
        type: .fiat,
        guid: "GUID",
        createdAt: Date(),
        asset: "USD",
        name: "USD",
        bankGuid: "BANK_GUID",
        customerGuid: "CUSTOMER_GUID",
        platformBalance: "Hello",
        platformAvailable: "Hello",
        state: .created
    )

    static let mockMxn = AccountBankModel(
        type: .fiat,
        guid: "GUID",
        createdAt: Date(),
        asset: "MXN",
        name: "MXN",
        bankGuid: "BANK_GUID",
        customerGuid: "CUSTOMER_GUID",
        platformBalance: "2000",
        platformAvailable: "2000",
        state: .created
    )

    static let fee = AccountBankModel(
        type: .fee,
        guid: "GUID",
        createdAt: Date(),
        asset: "ETH",
        name: "ETH",
        bankGuid: "BANK_GUID",
        customerGuid: "CUSTOMER_GUID",
        platformBalance: "200000000",
        platformAvailable: "2000000000",
        state: .created
    )

    static let gas = AccountBankModel(
        type: .gas,
        guid: "GUID",
        createdAt: Date(),
        asset: "ETH",
        name: "ETH",
        bankGuid: "BANK_GUID",
        customerGuid: "CUSTOMER_GUID",
        platformBalance: "200000000",
        platformAvailable: "2000000000",
        state: .created
    )

    static let mockWithNoAsset = AccountBankModel(
        type: .gas,
        guid: "GUID",
        createdAt: Date(),
        asset: "",
        name: "ETH",
        bankGuid: "BANK_GUID",
        customerGuid: "CUSTOMER_GUID",
        platformBalance: "200000000",
        platformAvailable: "2000000000",
        state: .created
    )

    static let mockWithNilAsset = AccountBankModel(
        type: .gas,
        guid: "GUID",
        createdAt: Date(),
        name: "ETH",
        bankGuid: "BANK_GUID",
        customerGuid: "CUSTOMER_GUID",
        platformBalance: "200000000",
        platformAvailable: "2000000000",
        state: .created
    )

    static let mock = [
        AccountBankModel.trading,
        AccountBankModel.fiat,
        AccountBankModel(
            type: .fiat,
            guid: "GUID",
            createdAt: Date(),
            asset: "USD",
            name: "USD",
            bankGuid: "BANK_GUID",
            customerGuid: "CUSTOMER_GUID",
            platformAvailable: "2000000000",
            state: .created
        )
    ]

    static let mockWithBackstopped = [
        AccountBankModel.tradingETH,
        AccountBankModel.trading,
        AccountBankModel.fiat,
        AccountBankModel.fee,
        AccountBankModel.gas
    ]
}
