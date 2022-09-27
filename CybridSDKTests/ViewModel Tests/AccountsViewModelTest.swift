//
//  AccountsViewModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 27/09/22.
//

import Foundation
@testable import CybridSDK
import XCTest

class AccountsViewModelTests: XCTestCase {

    let pricesFetchScheduler = TaskSchedulerMock()
    lazy var dataProvider = ServiceProviderMock()

    func test_init() {

        let viewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.currentCurrency, "USD")
    }

    func test_getAssetsList_Successfully() {

        // -- Given
        let viewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getAssetsList()
        dataProvider.didFetchAssetsSuccessfully()

        // -- Then
        XCTAssertNotEqual(viewModel.assets, [])
    }

    func test_getAssetsList_Error() {

        // -- Given
        let viewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getAssetsList()
        dataProvider.didFetchAssetsWithError()

        // -- Then
        XCTAssertEqual(viewModel.assets, [])
    }

    func test_getAccountsList_Successfully() {

        // -- Given
        let viewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getAccountsList()
        dataProvider.didFetchAccountsSuccessfully()

        // -- Then
        XCTAssertNotEqual(viewModel.accounts, [])
    }

    func test_getAccountsList_Error() {

        // -- Given
        let viewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getAccountsList()
        dataProvider.didFetchAccountsWithError()

        // -- Then
        XCTAssertEqual(viewModel.accounts, [])
    }

    func test_getPricesList_Successfully() {

        // -- Given
        let viewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getPricesList()
        dataProvider.didFetchPricesSuccessfully()

        // -- Then
        XCTAssertNotEqual(viewModel.prices, [])
    }

    func test_getPricesList_Error() {

        // -- Given
        let viewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getPricesList()
        dataProvider.didFetchPricesWithError()

        // -- Then
        XCTAssertEqual(viewModel.accounts, [])
    }

    func test_buildBalanceList_Successfully() {

        // -- Given
        let viewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getAssetsList()
        dataProvider.didFetchAssetsSuccessfully()

        viewModel.getAccountsList()
        dataProvider.didFetchAccountsSuccessfully()

        viewModel.getPricesList()
        dataProvider.didFetchPricesSuccessfully()

        // -- Then
        XCTAssertFalse(viewModel.balances.value.isEmpty)
    }
}

class AccountsMockViewProvider: AccountsViewProvider {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData dataModel: AccountAssetPriceModel) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, withBalance balance: AccountAssetPriceModel) {}
}
