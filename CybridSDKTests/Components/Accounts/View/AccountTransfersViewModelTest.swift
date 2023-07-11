//
//  AccountTransfersViewModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 03/04/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class AccountTransfersViewModelTest: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func test_init() {

        let viewModel = AccountTransfersViewModel(
            cellProvider: AccountTransfersMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil)

        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.assets)
    }

    func test_getTransfers_Successfully() {

        // -- Given
        let viewModel = AccountTransfersViewModel(
            cellProvider: AccountTransfersMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil)

        // -- When
        dataProvider.didFetchTransfersListSuccessfully()
        viewModel.getTransfers(accountGuid: "")
        dataProvider.didFetchTransfersListSuccessfully()

        // -- Then
        XCTAssertNotEqual(viewModel.tranfers.value, [])
    }

    func test_getTransfers_Error() {

        // -- Given
        let viewModel = AccountTransfersViewModel(
            cellProvider: AccountTransfersMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil)

        // -- When
        viewModel.getTransfers(accountGuid: "")
        dataProvider.didFetchTransfersListWithError()

        // -- Then
        XCTAssertEqual(viewModel.tranfers.value, [])
    }

    func test_getAmountOfTransfer() {

        // -- Given
        let transferOne = TransferBankModel(guid: "123454", state: .completed, amount: nil)
        let transferTwo = TransferBankModel(guid: "986432", state: .storing, estimatedAmount: nil)

        // -- When
        let amountOne = AccountTransfersViewModel.getAmountOfTransfer(transferOne)
        let amountTwo = AccountTransfersViewModel.getAmountOfTransfer(transferTwo)

        // -- Then
        XCTAssertEqual(amountOne, "0.00")
        XCTAssertEqual(amountTwo, "0.00")
    }

    // MARK: TableView Delegation Test

    func test_TableViewRows() throws {

        // -- Given
        let balance = BalanceUIModel(
            account: AccountListBankModel.mock.objects[0],
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            price: SymbolPriceBankModel.btcUSD1)
        let controller = AccountTransfersViewController(balance: balance)
        let tableView = controller.transfersTable
        let viewModel = AccountTransfersViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            logger: nil)

        // -- When
        viewModel.getTransfers(accountGuid: "")
        dataProvider.didFetchTransfersListSuccessfully()
        tableView.reloadData()

        // -- Then
        XCTAssertEqual(viewModel.tableView(tableView, numberOfRowsInSection: 0), 1)
    }

    func test_TableViewHeader() throws {

        // -- Given
        let balance = BalanceUIModel(
            account: AccountListBankModel.mock.objects[0],
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            price: SymbolPriceBankModel.btcUSD1)
        let controller = AccountTransfersViewController(balance: balance)
        let tableView = controller.transfersTable
        let viewModel = AccountTransfersViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            logger: nil)

        // -- When
        viewModel.getTransfers(accountGuid: "")
        dataProvider.didFetchTransfersListSuccessfully()
        tableView.reloadData()
        let headerView = viewModel.tableView(tableView, viewForHeaderInSection: 0)

        // -- Then
        XCTAssertNotNil(headerView)
        XCTAssertTrue(headerView!.isKind(of: AccountTransfersHeaderCell.self))
    }

    func test_TableViewValidCell() throws {

        // -- Given
        let balance = BalanceUIModel(
            account: AccountListBankModel.mock.objects[0],
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            price: SymbolPriceBankModel.btcUSD1)
        let controller = AccountTransfersViewController(balance: balance)
        let tableView = controller.transfersTable
        let viewModel = AccountTransfersViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            logger: nil)
        let indexPath = IndexPath(item: 0, section: 0)

        // -- When
        viewModel.getTransfers(accountGuid: "")
        dataProvider.didFetchTransfersListSuccessfully()
        tableView.reloadData()

        // -- Then
        XCTAssertTrue(viewModel.tableView(tableView, cellForRowAt: indexPath).isKind(of: AccountTransfersCell.self))

    }

    func test_TableView_didSelectRowAtIndex() throws {

        // -- Given
        let balance = BalanceUIModel(
            account: AccountListBankModel.mock.objects[1],
            asset: AssetBankModel.usd,
            counterAsset: AssetBankModel.usd,
            price: SymbolPriceBankModel.btcUSD1)
        let controller = AccountTransfersViewController(balance: balance)
        let tableView = controller.transfersTable
        let viewModel = AccountTransfersViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            logger: nil)
        let indexPath = IndexPath(item: 0, section: 0)

        // -- When
        viewModel.getTransfers(accountGuid: "")
        dataProvider.didFetchTransfersListSuccessfully()
        tableView.reloadData()
        viewModel.tableView(tableView, didSelectRowAt: indexPath)
    }
}

class AccountTransfersMockViewProvider: AccountTransfersViewProvider {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData model: TransferBankModel) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, with transfer: TransferBankModel) {}
}
