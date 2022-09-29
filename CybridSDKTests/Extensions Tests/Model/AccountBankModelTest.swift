//
//  AccountBankModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 27/09/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class AccountBankModelTest: XCTestCase {

    func test_init_Successfully() throws {

        // -- Given
        let json: [String: Any] = [
            "type": "trading",
            "guid": "5b13ffda9fc47c322af321434818709a",
            "created_at": "2022-06-27T19:46:42.504Z",
            "asset": "ETH",
            "name": "BTC-USD",
            "customer_guid": "bf10305829337d106b82c521bb6c8fd2",
            "platform_balance": "6000000000000000000",
            "platform_available": "0",
            "state": "created"
        ]

        // -- When
        let model = AccountBankModel(json: json)

        // -- Then
        XCTAssertNotNil(model)
    }

    func test_init_Error() throws {

        // -- Given
        let json: [String: Any] = [
            "type": "trading",
            "guid": "5b13ffda9fc47c322af321434818709a",
            "created_at": "2022-06-27T19:46:42.504Z",
            "asset": "ETH",
            "name": "BTC-USD",
            "customer_guid": "bf10305829337d106b82c521bb6c8fd2",
            "state": "created"
        ]

        // -- When
        let model = AccountBankModel(json: json)

        // -- Then
        XCTAssertNil(model)
    }
}
