//
//  ExternalWalletTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 23/08/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class ExternalWalletTest: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    internal func createViewModel() -> ExternalWalletViewModel {
        return ExternalWalletViewModel(
            dataProvider: self.dataProvider, logger: nil)
    }

    override class func setUp() {

        super.setUp()
        Cybrid.setup(sdkConfig: SDKConfig(
            environment: .staging,
            bearer: "1234",
            customerGuid: "1234",
            customer: CustomerBankModel.mock,
            bank: BankBankModel.mock()
        )) {}
    }
}
