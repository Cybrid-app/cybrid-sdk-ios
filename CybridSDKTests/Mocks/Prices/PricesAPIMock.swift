//
//  PricesAPIMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 19/07/22.
//

import CybridApiBankSwift
import CybridSDK

final class PricesAPIMock: PricesAPI {

    typealias AssetsListCompletion = (_ result: Result<[SymbolPriceBankModel], ErrorResponse>) -> Void
    private static var listPricesCompletion: AssetsListCompletion?

    override class func listPrices(symbol: String? = nil,
                                   apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                   completion: @escaping ((Result<[SymbolPriceBankModel], ErrorResponse>) -> Void)) -> RequestTask {
        listPricesCompletion = completion
        return listPricesWithRequestBuilder().requestTask
    }

    class func didFetchPricesSuccessfully(_ prices: [SymbolPriceBankModel]? = nil) {
        listPricesCompletion?(.success(prices ?? .mockPrices))
    }

    class func didFetchPricesWithError() {
        listPricesCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }
}
