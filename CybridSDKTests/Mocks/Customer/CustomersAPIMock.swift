//
//  CustomersAPIMock.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 03/11/22.
//

import CybridApiBankSwift
import CybridSDK

final class CustomersAPIMock: CustomersAPI {

    typealias CreateCustomerCompletion = (Result<CustomerBankModel, ErrorResponse>) -> Void
    typealias FetchCustomerCompletion = (Result<CustomerBankModel, ErrorResponse>) -> Void

    private static var createCustomerCompletion: CreateCustomerCompletion?
    private static var fetchCustomerCompletion: FetchCustomerCompletion?

    override class func createCustomer(postCustomerBankModel: PostCustomerBankModel, apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue, completion: @escaping ((Result<CustomerBankModel, ErrorResponse>) -> Void)) -> RequestTask {

        createCustomerCompletion = completion
        return createCustomerWithRequestBuilder(postCustomerBankModel: postCustomerBankModel).requestTask
    }

    override class func getCustomer(customerGuid: String, apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue, completion: @escaping ((Result<CustomerBankModel, ErrorResponse>) -> Void)) -> RequestTask {

        fetchCustomerCompletion = completion
        return getCustomerWithRequestBuilder(customerGuid: customerGuid).requestTask
    }

    class func didCreateCustomerSuccessfully(_ mockCustomer: CustomerBankModel?) {

        createCustomerCompletion?(.success(CustomersAPIMock.customerMocker))
    }

    class func didCreateCustomerFailed() {

        createCustomerCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }

    class func didFetchCustomerSuccessfully(_ mockCustomer: CustomerBankModel?) {

        fetchCustomerCompletion?(.success(CustomersAPIMock.customerMocker))
    }

    class func didFetchCustomerFailed() {

        fetchCustomerCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }
}

extension CustomersAPIMock {
    
    static let customerMocker = CustomerBankModel(guid: "123",
                                                  type: .individual,
                                                  createdAt: Date(),
                                                  state: .storing)
}
