//
//  CustomerRepository.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 31/10/22.
//

import Foundation
import CybridApiBankSwift

typealias CreateCustomerCompletion = (Result<CustomerBankModel, ErrorResponse>) -> Void
typealias FetchCustomerCompletion = (Result<CustomerBankModel, ErrorResponse>) -> Void

protocol CustomersRepoProvider: AuthenticatedServiceProvider {
    var customersRepository: CustomersRepository.Type { get set }
}

extension CustomersRepoProvider {

    func createCustomer(_ completion: @escaping CreateCustomerCompletion) {
        authenticatedRequest(customersRepository.createCustomer, completion: completion)
    }

    func getCustomer(customerGuid: String, _ completion: @escaping FetchCustomerCompletion) {
        authenticatedRequest(customersRepository.getCustomer, parameters: customerGuid, completion: completion)
    }
}

extension CybridSession: CustomersRepoProvider {}

protocol CustomersRepository {

    static func createCustomer(_ completion: @escaping CreateCustomerCompletion)
    static func getCustomer(customerGuid: String, _ completion: @escaping FetchCustomerCompletion)
}

extension CustomersAPI: CustomersRepository {

    static func createCustomer(_ completion: @escaping CreateCustomerCompletion) {
        createCustomer(postCustomerBankModel: PostCustomerBankModel(type: .individual),
                       completion: completion)
    }

    static func getCustomer(customerGuid: String, _ completion: @escaping FetchCustomerCompletion) {
        getCustomer(customerGuid: customerGuid, completion: completion)
    }
}
