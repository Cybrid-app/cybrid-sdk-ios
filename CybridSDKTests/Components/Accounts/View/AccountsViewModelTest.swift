//
//  AccountsViewModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 07/03/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class AccountsViewModelTest: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func createViewModel() -> AccountsViewModel {

        return AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil)
    }

    func createBalanceList() -> [BalanceUIModel] {

        let viewModel = self.createViewModel()
        let assets = AssetBankModel.cryptoAssets
        let accounts = AccountBankModel.mock
        let prices: [SymbolPriceBankModel] = .mockPrices
        return viewModel.buildModelList(assets: assets, accounts: accounts, prices: prices) ?? []
    }

    func test_init() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- Then
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.uiState.value, AccountsViewController.ViewState.LOADING)
    }

    func test_getAccounts_Successfully() async {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        dataProvider.didFetchAssetsSuccessfully()
        dataProvider.didFetchAccountsSuccessfully()
        viewModel.getAccounts()
        dataProvider.didFetchAccountsSuccessfully()

        // -- Then
        XCTAssertFalse(viewModel.accounts.isEmpty)
        XCTAssertNotNil(viewModel.pricesPolling)
    }

    func test_getPricesList() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        dataProvider.didFetchPricesSuccessfully(nil)
        viewModel.getPricesList()
        dataProvider.didFetchPricesSuccessfully(nil)

        // -- Then
        XCTAssertFalse(viewModel.prices.isEmpty)
    }

    func test_createAccountsFormatted() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.assets = AssetBankModel.cryptoAssets
        viewModel.accounts = AccountBankModel.mock
        viewModel.prices = .mockPrices
        viewModel.createAccountsFormatted()

        // -- Then
        XCTAssertFalse(viewModel.balances.value.isEmpty)
    }

    func test_buildModelList() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        let balances = self.createBalanceList()

        // -- Then
        XCTAssertFalse(balances.isEmpty)
    }

    func test_calculateTotalBalance() {

        // -- Given
        let viewModel = self.createViewModel()

        // -- When
        viewModel.assets = AssetBankModel.mock
        viewModel.accounts = AccountBankModel.mock
        viewModel.prices = .mockPrices
        viewModel.createAccountsFormatted()
        viewModel.calculateTotalBalance()

        // -- Then
        XCTAssertFalse(viewModel.balances.value.isEmpty)
        XCTAssertEqual(viewModel.accountTotalBalance.value, "$40,040,397.82 USD")
    }

    // MARK: TableView Delegation Test
    func test_TableViewRows() {

        // -- Given
        let controller = AccountsViewController()
        let tableView = controller.accountsTable
        let viewModel = self.createViewModel()

        // -- When
        viewModel.assets = AssetBankModel.cryptoAssets
        viewModel.accounts = AccountBankModel.mock
        viewModel.prices = .mockPrices
        viewModel.createAccountsFormatted()
        tableView.reloadData()

        // Then
        XCTAssertEqual(viewModel.tableView(tableView, numberOfRowsInSection: 0), 3)
    }

    func test_TableViewHeader() {

        // -- Given
        let controller = AccountsViewController()
        let tableView = controller.accountsTable
        let viewModel = self.createViewModel()

        // -- When
        viewModel.assets = AssetBankModel.cryptoAssets
        viewModel.accounts = AccountBankModel.mock
        viewModel.prices = .mockPrices
        viewModel.createAccountsFormatted()
        let headerView = viewModel.tableView(tableView, viewForHeaderInSection: 0)

        // -- Then
        XCTAssertNotNil(headerView)
        XCTAssertTrue(headerView!.isKind(of: AccountsHeaderCell.self))
    }

    func test_TableViewValidCell() {

        // -- Given
        let controller = AccountsViewController()
        let tableView = controller.accountsTable
        let viewModel = self.createViewModel()
        let indexPath = IndexPath(item: 0, section: 0)

        // -- When
        viewModel.assets = AssetBankModel.cryptoAssets
        viewModel.accounts = AccountBankModel.mock
        viewModel.prices = .mockPrices
        viewModel.createAccountsFormatted()
        tableView.reloadData()

        // -- Then
        XCTAssertTrue(viewModel.tableView(tableView, cellForRowAt: indexPath).isKind(of: AccountsCell.self))
    }

    func test_TableView_didSelectRowAtIndex() throws {

        // -- Given
        let controller = AccountsViewController()
        let tableView = controller.accountsTable
        let viewModel = self.createViewModel()
        let indexPath = IndexPath(item: 0, section: 0)
        let alertExpectation = XCTestExpectation(description: "testAlertShouldAppear")

        // -- When
        viewModel.assets = AssetBankModel.cryptoAssets
        viewModel.accounts = AccountBankModel.mock
        viewModel.prices = .mockPrices
        viewModel.createAccountsFormatted()
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData dataModel: BalanceUIModel) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, withBalance balance: BalanceUIModel) {}
}
