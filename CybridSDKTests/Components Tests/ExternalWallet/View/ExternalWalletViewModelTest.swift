//
//  ExternalWalletViewModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 23/08/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class ExternalWalletViewModelTest: XCTestCase {
    
    lazy var dataProvider = ServiceProviderMock()
    
    private func createViewModel(balance: BalanceUIModel) -> DepositAddressViewModel {
        return DepositAddressViewModel(
            dataProvider: self.dataProvider,
            logger: nil,
            accountBalance: balance)
    }
}
