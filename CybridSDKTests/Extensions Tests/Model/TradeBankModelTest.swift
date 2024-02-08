//
//  TradeBankModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 28/09/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class TradeBankModelTest: XCTestCase {

    func test_init_Incomplete() throws {

        // -- Given
        let json: [String: Any] = [
            "receive_amount": "100000000000000000",
            "deliver_amount": "13390",
            "fee": "0",
            "created_at": "2022-09-20T18:41:40.183Z"
        ]

        // -- When
        let model = TradeBankModel(json: json)

        // -- Then
        XCTAssertNotNil(model)
        XCTAssertEqual(model?.guid, "")
        XCTAssertEqual(model?.customerGuid, "")
        XCTAssertEqual(model?.quoteGuid, "")
        XCTAssertEqual(model?.symbol, "")
        XCTAssertEqual(model?.side, "buy")
        XCTAssertEqual(model?.state, "settling")
    }
}
