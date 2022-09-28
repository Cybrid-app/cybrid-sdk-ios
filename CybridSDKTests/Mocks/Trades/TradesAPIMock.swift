//
//  TradesAPIMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 24/08/22.
//

import CybridApiBankSwift
import CybridSDK

final class TradesAPIMock: TradesAPI {

    typealias CreateTradeCompletion = (_ result: Result<TradeBankModel, ErrorResponse>) -> Void
    typealias TradesListCompletition = (_ resutl: Result<TradeListBankModel, ErrorResponse>) -> Void

    private static var createTradeCompletion: CreateTradeCompletion?
    private static var tradesListCompletition: TradesListCompletition?

    @discardableResult
    override class func createTrade(postTradeBankModel: PostTradeBankModel,
                                    apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                    completion: @escaping ((Result<TradeBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        createTradeCompletion = completion
        return createTradeWithRequestBuilder(postTradeBankModel: postTradeBankModel).requestTask
    }
    
    override class func listTrades(page: Int? = nil, perPage: Int? = nil, guid: String? = nil, bankGuid: String? = nil, customerGuid: String? = nil, accountGuid: String? = nil, apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue, completion: @escaping ((Result<TradeListBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        
        tradesListCompletition = completion
        return listTradesWithRequestBuilder().requestTask
    }

    class func didCreateTradeSuccessfully(mockTrade: TradeBankModel) {
        createTradeCompletion?(.success(mockTrade))
    }

    class func didCreateTradeFailed() {
        createTradeCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }

    @discardableResult
    class func didFetchTradesListSuccessfully(_ trades: TradeListBankModel? = nil) -> TradeListBankModel {

        tradesListCompletition?(.success(trades ?? TradesAPIMock.mock))
        return TradesAPIMock.mock
    }

    class func didFetchTradesListWithError() {
        tradesListCompletition?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }
}

extension TradesAPIMock {

    static func getMockTrades() -> [TradeBankModel] {

        return [
            TradeBankModel(
                guid: "GUID",
                customerGuid: "CUSTOMER_GUID",
                quoteGuid: "QUOTE_GUID",
                symbol: "ETH-USD",
                side: .buy,
                state: .completed,
                receiveAmount: "100000000000000000",
                deliverAmount: "13390",
                fee: "0",
                createdAt: Date())
        ]
    }
    
    static let mock = TradeListBankModel(total: 1, page: 1, perPage: 1, objects: getMockTrades())
}
