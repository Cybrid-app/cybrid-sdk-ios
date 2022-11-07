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

    func createCustomer(postCustomerBankModel: PostCustomerBankModel, _ completion: @escaping CreateCustomerCompletion) {
        authenticatedRequest(customersRepository.createCustomer, parameters: postCustomerBankModel, completion: completion)
    }

    func getCustomer(customerGuid: String, _ completion: @escaping FetchCustomerCompletion) {
        authenticatedRequest(customersRepository.getCustomer, parameters: customerGuid, completion: completion)
    }
}

extension CybridSession: CustomersRepoProvider {}

protocol CustomersRepository {

    static func createCustomer(postCustomerBankModel: PostCustomerBankModel, _ completion: @escaping CreateCustomerCompletion)
    static func getCustomer(customerGuid: String, _ completion: @escaping FetchCustomerCompletion)
}

extension CustomersAPI: CustomersRepository {

    static func createCustomer(postCustomerBankModel: PostCustomerBankModel, _ completion: @escaping CreateCustomerCompletion) {
        createCustomer(postCustomerBankModel: postCustomerBankModel,
                       completion: completion)
    }

    static func getCustomer(customerGuid: String, _ completion: @escaping FetchCustomerCompletion) {
        getCustomer(customerGuid: customerGuid, completion: completion)
    }
}
