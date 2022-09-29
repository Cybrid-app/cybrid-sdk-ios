//
//  AccountsViewModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 27/09/22.
//

import CybridApiBankSwift
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

    func test_getAccounts_Successfully() {

        // -- Given
        let viewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getAccounts()
        dataProvider.didFetchAssetsSuccessfully()
        dataProvider.didFetchAccountsSuccessfully()
        dataProvider.didFetchPricesSuccessfully()

        // -- Then
        XCTAssertFalse(viewModel.balances.value.isEmpty)
    }

    func test_getAccounts_Error() {

        // -- Given
        let viewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getAccounts()
        dataProvider.didFetchAssetsSuccessfully()
        dataProvider.didFetchAccountsWithError()
        dataProvider.didFetchPricesWithError()

        // -- Then
        XCTAssertTrue(viewModel.balances.value.isEmpty)
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

    func test_getAssestList_InNotEmpty() {

        // -- Given
        let viewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.assets = AssetListBankModel.mock.objects
        viewModel.getAssetsList()
        dataProvider.didFetchAccountsSuccessfully()

        // -- Then
        XCTAssertNotEqual(viewModel.accounts, [])
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

    func test_buildBalanceList_Error() {

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
        dataProvider.didFetchAccountsWithError()

        viewModel.getPricesList()
        dataProvider.didFetchPricesSuccessfully()

        // -- Then
        XCTAssertTrue(viewModel.balances.value.isEmpty)
    }

    func test_buildModelList_Nil() {

        // -- Given
        let viewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "MXN")

        // -- When
        viewModel.getAssetsList()
        dataProvider.didFetchAssetsSuccessfully()

        viewModel.getAccountsList()
        dataProvider.didFetchAccountsSuccessfully()

        viewModel.getPricesList()
        dataProvider.didFetchPricesSuccessfully()

        let list = viewModel.buildModelList(
            assets: viewModel.assets,
            accounts: viewModel.accounts,
            prices: viewModel.prices)

        // -- Then
        XCTAssertEqual(list, [])
    }

    // MARK: TableView Delegation Test

    func test_TableViewRows() {

        // -- Given
        let controller = AccountsViewController()
        let tableView = controller.accountsTable
        let viewModel = AccountsViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getAccounts()
        dataProvider.didFetchAssetsSuccessfully()
        dataProvider.didFetchAccountsSuccessfully()
        dataProvider.didFetchPricesSuccessfully()
        tableView.reloadData()

        // Then
        XCTAssertEqual(viewModel.tableView(tableView, numberOfRowsInSection: 0), 1)
    }

    func test_TableViewHeader() {

        // -- Given
        let controller = AccountsViewController()
        let tableView = controller.accountsTable
        let viewModel = AccountsViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getAccounts()
        dataProvider.didFetchAssetsSuccessfully()
        dataProvider.didFetchAccountsSuccessfully()
        dataProvider.didFetchPricesSuccessfully()
        let headerView = viewModel.tableView(tableView, viewForHeaderInSection: 0)

        // -- Then
        XCTAssertNotNil(headerView)
        XCTAssertTrue(headerView!.isKind(of: AccountsHeaderCell.self))
    }

    func test_TableViewValidCell() {

        // -- Given
        let controller = AccountsViewController()
        let tableView = controller.accountsTable
        let viewModel = AccountsViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")
        let indexPath = IndexPath(item: 0, section: 0)

        // -- When
        viewModel.getAccounts()
        dataProvider.didFetchAssetsSuccessfully()
        dataProvider.didFetchAccountsSuccessfully()
        dataProvider.didFetchPricesSuccessfully()
        tableView.reloadData()

        // -- Then
        XCTAssertTrue(viewModel.tableView(tableView, cellForRowAt: indexPath).isKind(of: AccountsCell.self))
    }

    func test_TableView_didSelectRowAtIndex() throws {

        // -- Given
        let controller = AccountsViewController()
        let tableView = controller.accountsTable
        let viewModel = AccountsViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")
        let indexPath = IndexPath(item: 0, section: 0)
        let alertExpectation = XCTestExpectation(description: "testAlertShouldAppear")

        // -- When
        viewModel.getAccounts()
        dataProvider.didFetchAssetsSuccessfully()
        dataProvider.didFetchAccountsSuccessfully()
        dataProvider.didFetchPricesSuccessfully()
        tableView.reloadData()

        viewModel.tableView(tableView, didSelectRowAt: indexPath)

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            XCTAssertNil(controller.presentingViewController)
            XCTAssertNil(controller.presentedViewController)
            XCTAssertNil(controller.navigationController)
            alertExpectation.fulfill()
        })
        wait(for: [alertExpectation], timeout: 1.0)
    }
}

class AccountsMockViewProvider: AccountsViewProvider {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData dataModel: AccountAssetPriceModel) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, withBalance balance: AccountAssetPriceModel) {}
}
