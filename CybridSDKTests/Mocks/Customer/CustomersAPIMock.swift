//
//  CustomersAPIMock.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 03/11/22.
//

import CybridApiBankSwift
import CybridSDK

final class CustomersAPIMock: CustomersAPI {

    typealias CreateCustomerCompletion = (_ result: Result<CustomerBankModel, ErrorResponse>) -> Void
    typealias FetchCustomerCompletion = (_ result: Result<CustomerBankModel, ErrorResponse>) -> Void

    private static var createCustomerCompletion: CreateCustomerCompletion?
    private static var fetchCustomerCompletion: FetchCustomerCompletion?

    @discardableResult
    override class func createCustomer(postCustomerBankModel: PostCustomerBankModel,
                                       apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                       completion: @escaping ((Result<CustomerBankModel, ErrorResponse>) -> Void)) -> RequestTask {

        createCustomerCompletion = completion
        return createCustomerWithRequestBuilder(postCustomerBankModel: postCustomerBankModel).requestTask
    }

    override class func getCustomer(customerGuid: String,
                                    apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                    completion: @escaping ((Result<CustomerBankModel, ErrorResponse>) -> Void)) -> RequestTask {

        fetchCustomerCompletion = completion
        return getCustomerWithRequestBuilder(customerGuid: customerGuid).requestTask
    }

    class func didCreateCustomerSuccessfully() {

        createCustomerCompletion?(.success(CustomerBankModel.mock))
    }

    class func didCreateCustomerFailed() {

        createCustomerCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }

    class func didFetchCustomerSuccessfully(_ mockCustomer: CustomerBankModel) {

        fetchCustomerCompletion?(.success(mockCustomer))
    }

    class func didFetchCustomerFailed() {

        fetchCustomerCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }
}

extension CustomerBankModel {

    static let mock = CustomerBankModel(guid: "12345",
                                        type: .individual,
                                        createdAt: Date(),
                                        state: .storing)

    static let mockEmpty = CustomerBankModel(guid: "12345",
                                        type: .individual,
                                        createdAt: Date())
}
