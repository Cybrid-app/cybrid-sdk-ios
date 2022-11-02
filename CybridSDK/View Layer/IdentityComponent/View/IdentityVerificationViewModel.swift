//
//  IdentityVerificationViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 01/11/22.
//

import Foundation
import CybridApiBankSwift

class IdentityVerificationViewModel: NSObject {

    // MARK: Private properties
    private var dataProvider: CustomersRepoProvider & IdentityVerificationRepoProvider
    private var logger: CybridLogger?

    // MARK: Internal properties
    internal var customerJob: Polling?
    internal var identityJob: Polling?
    internal var customerGuid = Cybrid.customerGUID

    // MARK: Public properties
    var UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
    var latestIdentityVerification: IdentityVerificationBankModel?

    // MARK: Constructor
    init(dataProvider: CustomersRepoProvider & IdentityVerificationRepoProvider,
         UIState: Observable<IdentityVerificationViewController.KYCViewState>,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.logger = logger
    }

    // MARK: ViewModel Methods
    func createCustomerTest() {

        self.dataProvider.createCustomer { [weak self] customerResponse in

            switch customerResponse {

            case .success(let customer):
                self?.logger?.log(.component(.accounts(.pricesDataFetching)))
                print("CREATE CUSTOMER")
                print(customer)
                print("---------------------------")
                self?.customerGuid = customer.guid ?? (self?.customerGuid ?? "")

            case .failure:
                self?.logger?.log(.component(.accounts(.pricesDataError)))
            }
        }
    }
}
