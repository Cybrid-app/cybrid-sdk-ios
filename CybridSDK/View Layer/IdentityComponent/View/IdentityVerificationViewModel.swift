//
//  IdentityVerificationViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 01/11/22.
//

import Foundation

class IdentityVerificationViewModel: NSObject {

    // MARK: Private properties
    private var dataProvider: CustomersRepoProvider & IdentityVerificationRepoProvider
    private var logger: CybridLogger?

    init(dataProvider: CustomersRepoProvider & IdentityVerificationRepoProvider,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.logger = logger
    }
}
