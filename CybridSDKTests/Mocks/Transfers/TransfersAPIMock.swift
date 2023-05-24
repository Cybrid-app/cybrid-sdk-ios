//
//  TransfersAPIMock.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 28/03/23.
//

import CybridApiBankSwift
import CybridSDK

final class TransfersAPIMock: TransfersAPI {

    typealias CreateTransferCompletion = (_ result: Result<TransferBankModel, ErrorResponse>) -> Void
    typealias TransfersListCompletition = (_ resutl: Result<TransferListBankModel, ErrorResponse>) -> Void

    private static var createTransferCompletion: CreateTransferCompletion?
    private static var transfersListCompletition: TransfersListCompletition?

    @discardableResult
    override class func createTransfer(postTransferBankModel: PostTransferBankModel,
                                       apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                       completion: @escaping ((Result<TransferBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        createTransferCompletion = completion
        return createTransferWithRequestBuilder(postTransferBankModel: postTransferBankModel).requestTask
    }

    override class func listTransfers(page: Int? = nil, perPage: Int? = nil, guid: String? = nil, bankGuid: String? = nil, customerGuid: String? = nil, accountGuid: String? = nil, apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue, completion: @escaping ((Result<TransferListBankModel, ErrorResponse>) -> Void)) -> RequestTask {

        transfersListCompletition = completion
        return listTransfersWithRequestBuilder().requestTask
    }

    class func didCreateTransferSuccessfully() {
        createTransferCompletion?(.success(mock()))
    }

    class func didCreateTransferFailed() {
        createTransferCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }

    @discardableResult
    class func didFetchTransfersListSuccessfully(_ transfers: TransferListBankModel? = nil) -> TradeListBankModel {

        transfersListCompletition?(.success(transfers ?? TransfersAPIMock.mockList))
        return TradesAPIMock.mock
    }

    class func didFetchTransfersListWithError() {
        transfersListCompletition?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }
}

extension TransfersAPIMock {

    static func mock() -> TransferBankModel {
        return TransferBankModel(
            guid: "1234",
            transferType: .funding,
            customerGuid: "1234",
            quoteGuid: "1234",
            asset: "USD",
            side: .deposit,
            state: .storing,
            amount: 1000,
            fee: 0,
            createdAt: Date()
        )
    }

    static func mockTransfers() -> [TransferBankModel] {
        return [mock()]
    }

    static let mockList = TransferListBankModel(total: 1, page: 1, perPage: 1, objects: mockTransfers())
}
