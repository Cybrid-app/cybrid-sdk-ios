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

    override class func listTransfers(
        page: Int? = nil,
        perPage: Int? = nil,
        guid: String? = nil,
        transferType: String? = nil,
        bankGuid: String? = nil,
        customerGuid: String? = nil,
        accountGuid: String? = nil,
        state: String? = nil,
        side: String? = nil,
        label: String? = nil,
        createdAtGte: String? = nil,
        createdAtLt: String? = nil,
        updatedAtGte: String? = nil,
        updatedAtLt: String? = nil,
        apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
        completion: @escaping ((Result<TransferListBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        transfersListCompletition = completion
        return listTransfersWithRequestBuilder().requestTask
    }

    class func didCreateTransferSuccessfully() {
        createTransferCompletion?(.success(TransferBankModel.mock()))
    }

    class func didCreateTransferFailed() {
        createTransferCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }

    @discardableResult
    class func didFetchTransfersListSuccessfully(_ transfers: TransferListBankModel? = nil) -> TradeListBankModel {

        transfersListCompletition?(.success(transfers ?? TransferBankModel.mockList))
        return TradesAPIMock.mock
    }

    class func didFetchTransfersListWithError() {
        transfersListCompletition?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }
}

extension TransferBankModel {

    static func mock() -> TransferBankModel {
        return TransferBankModel(
            guid: "1234",
            transferType: "funding",
            customerGuid: "1234",
            quoteGuid: "1234",
            asset: "USD",
            side: "deposit",
            state: "storing",
            amount: 1000,
            fee: 0,
            createdAt: Date()
        )
    }

    static func mockWithWAlletGuid() -> Self {
        return TransferBankModel(
            guid: "1234",
            transferType: "crypto",
            customerGuid: "12345",
            quoteGuid: "12345",
            asset: "BTC",
            side: "withdrawal",
            state: "completed",
            amount: 200000,
            fee: 0,
            destinationAccount: TransferDestinationAccountBankModel(
                guid: "wallet_guid",
                type: "externalWallet"
            ),
            createdAt: Date()
        )
    }

    static func mockTransfers() -> [TransferBankModel] {
        return [mock()]
    }

    static func mockTransfersWithWalletGuid() -> [Self] {
        return [mockWithWAlletGuid()]
    }

    static let mockList = TransferListBankModel(total: 1, page: 1, perPage: 1, objects: mockTransfers())
}
