//
//  BankAPIMock.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 09/12/22.
//

import CybridApiBankSwift
import CybridSDK

final class BankAPIMock: BanksAPI {

    typealias FetchBankCompletion = (_ result: Result<BankBankModel, ErrorResponse>) -> Void

    private static var fetchBankCompletion: FetchBankCompletion?

    override class func getBank(bankGuid: String,
                                apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                completion: @escaping ((Result<BankBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        fetchBankCompletion = completion
        return getBankWithRequestBuilder(bankGuid: bankGuid).requestTask
    }

    // MARK: Fetch Bank
    @discardableResult
    class func fetchBankSuccessfully() -> BankBankModel {
        fetchBankCompletion?(.success(BankBankModel.mock()))
        return BankBankModel.mock()
    }

    @discardableResult
    class func fetchBankSuccessfully_Without_Fiat_Assets() -> BankBankModel {
        fetchBankCompletion?(.success(BankBankModel.mock_without_fiat_assets()))
        return BankBankModel.mock_without_fiat_assets()
    }

    @discardableResult
    class func fetchBankSuccessfully_With_MXN_Fiat_Assets() -> BankBankModel {
        fetchBankCompletion?(.success(BankBankModel.mock_with_mxn_fiat_assets()))
        return BankBankModel.mock_with_mxn_fiat_assets()
    }

    @discardableResult
    class func fetchBankSuccessfully_Incomplete() -> BankBankModel {
        fetchBankCompletion?(.success(BankBankModel.mockIncomplete()))
        return BankBankModel.mockIncomplete()
    }

    class func fetchBankError() {
        fetchBankCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }
}

extension BankBankModel {

    static func mock() -> Self {
        return BankBankModel(
            guid: "1234",
            organizationGuid: "1234",
            name: "1234",
            type: "sandbox",
            supportedFiatAccountAssets: ["USD"],
            features: [],
            createdAt: Date())
    }

    static func mock_without_fiat_assets() -> Self {
        return BankBankModel(
            guid: "1234",
            organizationGuid: "1234",
            name: "1234",
            type: "sandbox",
            supportedFiatAccountAssets: nil,
            features: [],
            createdAt: Date())
    }

    static func mock_with_mxn_fiat_assets() -> Self {
        return BankBankModel(
            guid: "1234",
            organizationGuid: "1234",
            name: "1234",
            type: "sandbox",
            supportedFiatAccountAssets: ["MXN"],
            features: [],
            createdAt: Date())
    }

    static func mockIncomplete() -> Self {
        return BankBankModel(
            guid: "1234",
            organizationGuid: "1234",
            name: "1234",
            type: "sandbox",
            features: [],
            createdAt: Date())
    }
}
