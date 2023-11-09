//
//  AccountTradesViewModel.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 27/09/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class AccountTradesViewModelTests: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func test_init() {
        
        Cybrid.assets = AssetListBankModel.mock.objects
        let viewModel = AccountTradesViewModel(
            dataProvider: self.dataProvider,
            logger: nil)

        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.assets)
    }

    func test_getTrades_Successfully() {

        // -- Given
        Cybrid.assets = AssetListBankModel.mock.objects
        let viewModel = AccountTradesViewModel(
            dataProvider: self.dataProvider,
            logger: nil)

        // -- When
        viewModel.getTrades(accountGuid: "")
        dataProvider.didFetchTradesListSuccessfully()

        // -- Then
        XCTAssertNotEqual(viewModel.tradesList, [])
    }

    func test_getTrades_Error() {

        // -- Given
        Cybrid.assets = AssetListBankModel.mock.objects
        let viewModel = AccountTradesViewModel(
            dataProvider: self.dataProvider,
            logger: nil)

        // -- When
        viewModel.getTrades(accountGuid: "")
        dataProvider.didFetchTradesListWithError()

        // -- Then
        XCTAssertEqual(viewModel.tradesList, [])
    }

    func test_buildModelList_Successfully() throws {

        // -- Given
        Cybrid.assets = AssetListBankModel.mock.objects
        let viewModel = AccountTradesViewModel(
            dataProvider: self.dataProvider,
            logger: nil)

        // -- When
        viewModel.getTrades(accountGuid: "")
        dataProvider.didFetchTradesListSuccessfully()

        // -- Then
        XCTAssertTrue(viewModel.trades.value.isEmpty)
    }

    func test_buildModelList_Error() throws {

        // -- Given
        Cybrid.assets = AssetListBankModel.mock.objects
        let viewModel = AccountTradesViewModel(
            dataProvider: self.dataProvider,
            logger: nil)

        // -- When
        viewModel.getTrades(accountGuid: "")
        dataProvider.didFetchTradesListWithError()

        // -- Then
        XCTAssertTrue(viewModel.trades.value.isEmpty)
    }

    func test_createUIModelList_Nil() throws {

        // -- Given
        Cybrid.assets = AssetListBankModel.mock.objects
        let viewModel = AccountTradesViewModel(
            dataProvider: self.dataProvider,
            logger: nil)

        // -- When
        viewModel.getTrades(accountGuid: "")
        dataProvider.didFetchTradesListSuccessfully()
        viewModel.tradesList[0].symbol = "MXN-BTC"

        let list = viewModel.createUIModelList(
            trades: viewModel.tradesList,
            assets: viewModel.assets,
            accountGuid: viewModel.currentAccountGUID)

        // -- Then
        XCTAssertEqual(list, [])
    }
}
