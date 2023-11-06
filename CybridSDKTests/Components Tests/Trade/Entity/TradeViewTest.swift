//
//  TradeViewTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 01/11/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class TradeViewTest: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    internal func createViewModel() -> TradeViewModel {
        return TradeViewModel(
            dataProvider: self.dataProvider,
            logger: nil)
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
        Cybrid.assets = AssetBankModel.mock
    }
}
