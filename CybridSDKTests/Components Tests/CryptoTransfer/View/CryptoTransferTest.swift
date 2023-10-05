//
//  CryptoTransferTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 04/10/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class CryptoTransferTest: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    internal func createViewModel() -> CryptoTransferViewModel {
        return CryptoTransferViewModel(
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
